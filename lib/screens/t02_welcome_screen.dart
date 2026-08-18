import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:mi_feria_inteligente/providers/tv_state.dart';
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
    [Color(0xFFE0F2FE), Color(0xFFBAE6FD)], // Light blue
    [Color(0xFFFFEDD5), Color(0xFFFED7AA)], // Light orange
    [Color(0xFFDCFCE7), Color(0xFFBBF7D0)], // Light green
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
    final tvState = context.watch<TvState>();

    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            decoration: BoxDecoration(gradient: LinearGradient(colors: _gradients[_slide], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          ),
          Container(color: Colors.white.withValues(alpha: 0.2)),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: FadeIn(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tvState.eventName,
                            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 32),
                          const Text('Próxima actividad en:', style: TextStyle(color: Color(0xFF334155), fontSize: 18)),
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
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
        ],
      ),
    );
  }
}
