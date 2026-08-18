import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/models.dart';

final tvState = TvState();

class TvState extends ChangeNotifier {
  WebSocketChannel? _channel;
  bool _isConnecting = false;
  Timer? _reconnectTimer;

  bool isConnected = false;
  String eventName = 'Mi Feria Inteligente';
  String? userName;
  String? userEmail;

  FeriaActivity currentActivity = const FeriaActivity(
    title: 'Esperando actividad...',
    time: '--:--',
    place: 'Por definir',
    status: ActivityStatus.proximo,
  );

  List<FeriaActivity> nextActivities = [];
  
  String pollQuestion = '¿Cuál fue el mejor stand?';
  List<VoteOption> voteResults = [];

  FeriaAlert? activeAlert;

  String connectionStatus = 'Sin conectar';

  TvState() {
    // No conectamos automáticamente en el constructor para permitir que la pantalla de vinculación
    // inicie la conexión de forma explícita o automática al presionar el botón.
  }

  void connect() {
    if (_isConnecting || isConnected) return;
    _isConnecting = true;
    
    final host = kIsWeb
        ? 'localhost'
        : (defaultTargetPlatform == TargetPlatform.android ? '10.0.2.2' : 'localhost');
    final url = 'ws://$host:8080';
    
    debugPrint('TvState: Conectando al socket en $url');
    connectionStatus = 'Conectando...';
    notifyListeners();

    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _channel!.stream.listen(
        (data) {
          _isConnecting = false;
          isConnected = true;
          connectionStatus = 'Conectado';
          _handleMessage(data as String);
        },
        onDone: () {
          _isConnecting = false;
          _handleDisconnect();
        },
        onError: (e) {
          _isConnecting = false;
          _handleDisconnect();
        },
      );
      
      // Solicitar sincronización inicial al conectar
      requestManualSync();
    } catch (e) {
      _isConnecting = false;
      _handleDisconnect();
    }
  }

  void _handleDisconnect() {
    isConnected = false;
    connectionStatus = 'Desconectado (Reintentando...)';
    notifyListeners();

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      connect();
    });
  }

  void _handleMessage(String rawData) {
    try {
      final msg = jsonDecode(rawData) as Map<String, dynamic>;
      final type = msg['type'];
      debugPrint('TvState: Mensaje recibido: $msg');

      if (type == 'auth_state') {
        userName = msg['name'];
        userEmail = msg['email'];
        if (userName != null && userName!.isNotEmpty) {
          eventName = 'Bienvenido, $userName';
        }
      } else if (type == 'favorites') {
        final list = msg['favorites'] as List<dynamic>;
        final parsedActivities = list.map((item) {
          final title = item['name'] ?? '';
          final time = '${item['time'] ?? ''} - ${item['endTime'] ?? ''}';
          final place = item['location'] ?? '';
          final statusStr = item['status'] ?? 'upcoming';
          
          ActivityStatus statusVal = ActivityStatus.proximo;
          if (statusStr == 'ongoing') {
            statusVal = ActivityStatus.enCurso;
          } else if (statusStr == 'finished') {
            statusVal = ActivityStatus.finalizado;
          }
          
          return FeriaActivity(
            title: title,
            time: time,
            place: place,
            status: statusVal,
          );
        }).toList();

        // Determinar actividad actual: la que está en curso (enCurso). 
        // Si no hay ninguna en curso, tomar la primera próxima.
        final ongoing = parsedActivities.where((a) => a.status == ActivityStatus.enCurso).toList();
        if (ongoing.isNotEmpty) {
          currentActivity = ongoing.first;
        } else {
          final upcoming = parsedActivities.where((a) => a.status == ActivityStatus.proximo).toList();
          if (upcoming.isNotEmpty) {
            currentActivity = upcoming.first;
          } else if (parsedActivities.isNotEmpty) {
            currentActivity = parsedActivities.first;
          }
        }

        // El listado general en la pantalla de TV mostrará todas las actividades
        nextActivities = parsedActivities;
      } else if (type == 'polls') {
        final list = msg['polls'] as List<dynamic>;
        if (list.isNotEmpty) {
          final firstPoll = list.first as Map<String, dynamic>;
          pollQuestion = firstPoll['question'] ?? '¿Cuál fue el mejor stand?';
          final options = firstPoll['options'] as List<dynamic>;
          final votesMap = firstPoll['votes'] as Map<String, dynamic>;
          
          voteResults = options.map((opt) {
            final label = opt as String;
            final votesCount = votesMap[label] ?? 0;
            return VoteOption(label: label, votes: votesCount);
          }).toList();
        }
      } else if (type == 'trigger_alert') {
        final alertData = msg['alert'] as Map<String, dynamic>;
        AlertLevel levelVal = AlertLevel.aviso;
        if (alertData['urgency'] == 'emergency' || alertData['urgency'] == 'AlertUrgency.emergency') {
          levelVal = AlertLevel.emergencia;
        }
        activeAlert = FeriaAlert(
          message: alertData['message'] ?? '',
          instruction: alertData['fullMessage'] ?? '',
          level: levelVal,
        );
      } else if (type == 'dismiss_alert') {
        activeAlert = null;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('TvState: Error al interpretar mensaje: $e');
    }
  }

  void dismissAlert() {
    activeAlert = null;
    if (_channel != null && isConnected) {
      try {
        _channel!.sink.add(jsonEncode({'type': 'dismiss_alert'}));
      } catch (_) {}
    }
    notifyListeners();
  }

  void requestManualSync() {
    if (_channel != null && isConnected) {
      try {
        _channel!.sink.add(jsonEncode({'type': 'request_sync'}));
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    super.dispose();
  }
}
