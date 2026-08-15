import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mi_feria_inteligente/data/mock_data.dart';
import 'package:mi_feria_inteligente/widgets/widgets.dart';

/// Pantalla principal: 60% actividad actual en vivo, 40% próximas actividades.
class T03AgendaScreen extends StatefulWidget {
  const T03AgendaScreen({super.key});

  @override
  State<T03AgendaScreen> createState() => _T03AgendaScreenState();
}

class _T03AgendaScreenState extends State<T03AgendaScreen> {
  late Timer _clock;
  late DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => _now = DateTime.now()));
  }

  @override
  void dispose() {
    _clock.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hora = '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Encabezado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Row(
                children: [
                  Text(eventName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  TvButton(label: 'Transmisión', icon: Icons.live_tv, onSelect: () => context.go('/transmision')),
                  const SizedBox(width: 12),
                  TvButton(label: 'Votación', icon: Icons.poll, onSelect: () => context.go('/resultados')),
                  const SizedBox(width: 12),
                  TvButton(label: 'Simular alerta', icon: Icons.warning_amber, onSelect: () => context.go('/alerta')),
                  const SizedBox(width: 24),
                  Text(hora, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            // Cuerpo: 60% / 40%
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: _mainActivityPanel()),
                    const SizedBox(width: 24),
                    Expanded(flex: 4, child: _nextActivitiesPanel()),
                  ],
                ),
              ),
            ),
            // Servicios del recinto
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              color: Colors.black.withValues(alpha: 0.4),
              child: const Row(
                children: [
                  Icon(Icons.wc, size: 18, color: Colors.white60),
                  SizedBox(width: 6),
                  Text('Baños al fondo', style: TextStyle(color: Colors.white60)),
                  SizedBox(width: 32),
                  Icon(Icons.medical_services, size: 18, color: Colors.white60),
                  SizedBox(width: 6),
                  Text('Primeros Auxilios', style: TextStyle(color: Colors.white60)),
                  SizedBox(width: 32),
                  Icon(Icons.exit_to_app, size: 18, color: Colors.white60),
                  SizedBox(width: 6),
                  Text('Salidas de Emergencia', style: TextStyle(color: Colors.white60)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mainActivityPanel() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusBadge(status: currentActivity.status),
          const SizedBox(height: 16),
          Text(currentActivity.title, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(currentActivity.place, style: const TextStyle(fontSize: 20, color: Colors.white70)),
          const Spacer(),
          Text('Horario: ${currentActivity.time}', style: const TextStyle(fontSize: 16, color: Colors.white54)),
        ],
      ),
    );
  }

  Widget _nextActivitiesPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Programa del día', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Expanded(
            child: nextActivities.isEmpty
                ? const Center(
                    child: Text(
                      'No hay actividades programadas',
                      style: TextStyle(color: Colors.white30),
                    ),
                  )
                : ListView.separated(
                    itemCount: nextActivities.length,
                    separatorBuilder: (context, index) => const Divider(color: Colors.white12),
                    itemBuilder: (context, i) {
                      final a = nextActivities[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            SizedBox(width: 52, child: Text(a.time, style: const TextStyle(color: Colors.white60))),
                            Expanded(child: Text(a.title, overflow: TextOverflow.ellipsis)),
                            StatusBadge(status: a.status),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
