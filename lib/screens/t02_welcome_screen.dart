import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:mi_feria_inteligente/data/mock_data.dart';
import 'package:mi_feria_inteligente/widgets/widgets.dart';

/// Pantalla de espera entre actividades: cuenta regresiva + slideshow + ticker.
class T02WelcomeScreen extends StatefulWidget {
  const T02WelcomeScreen({super.key});

  @override
  State<T02WelcomeScreen> createState() => _T02WelcomeScreenState();
}

class _T02WelcomeScreenState extends State<T02WelcomeScreen> {
  Duration _left = const Duration(minutes: 15, seconds: 30);
  int _slide = 0;
  late final Timer _clock;
  late final Timer _slideshow;

  final _gradients = const [
    [Color(0xFF1E3A8A), Color(0xFF2563EB)],
    [Color(0xFF7C2D12), Color(0xFFEA580C)],
    [Color(0xFF166534), Color(0xFF22C55E)],
  ];

  @override
  void initState() {
    super.initState();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _left = _left.inSeconds > 0 ? _left - const Duration(seconds: 1) : Duration.zero;
      });
    });
    _slideshow = Timer.periodic(const Duration(seconds: 8), (_) {
      setState(() => _slide = (_slide + 1) % _gradients.length);
    });
  }

  @override
  void dispose() {
    _clock.cancel();
    _slideshow.cancel();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final h = _left.inHours, m = _left.inMinutes % 60, s = _left.inSeconds % 60;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            decoration: BoxDecoration(gradient: LinearGradient(colors: _gradients[_slide], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          ),
          Container(color: Colors.black.withValues(alpha: 0.45)),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: FadeIn(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(eventName, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 32),
                          const Text('Próxima actividad en:', style: TextStyle(color: Colors.white70, fontSize: 18)),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _timeBox(_two(h), 'Horas'),
                              const SizedBox(width: 16),
                              _timeBox(_two(m), 'Minutos'),
                              const SizedBox(width: 16),
                              _timeBox(_two(s), 'Segundos'),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TvButton(label: 'Iniciar programa', icon: Icons.event_note, autofocus: true, onSelect: () => context.go('/agenda')),
                              const SizedBox(width: 16),
                              TvButton(label: 'Iniciar streaming', icon: Icons.videocam, onSelect: () => context.go('/transmision')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const TickerBar(
                  text: '[ NOTICIAS ]  Bienvenidos al evento — No olviden visitar la zona de comida — '
                      'Consulten la agenda en la app móvil — Síguenos en redes sociales @MiFeriaInteligente',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeBox(String value, String label) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.white60)),
        ],
      ),
    );
  }
}
