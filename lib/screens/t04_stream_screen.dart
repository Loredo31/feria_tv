import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mi_feria_inteligente/data/mock_data.dart';
import 'package:mi_feria_inteligente/widgets/widgets.dart';

/// Streaming desde el escenario. Se activa automáticamente desde el panel web
/// del organizador; aquí se simula con un placeholder de video.
class T04StreamScreen extends StatelessWidget {
  const T04StreamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const Center(
            child: Icon(Icons.play_circle_outline, size: 96, color: Colors.white24),
          ),
          Positioned(
            top: 24,
            left: 24,
            child: Row(
              children: const [
                _LiveDot(),
                SizedBox(width: 8),
                Text('EN VIVO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ],
            ),
          ),
          const Positioned(top: 24, right: 24, child: Text('Mi Feria Inteligente', style: TextStyle(color: Colors.white70))),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(currentActivity.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(currentActivity.place, style: const TextStyle(color: Colors.white60)),
                      ],
                    ),
                  ),
                  TvButton(label: 'Volver a agenda', icon: Icons.event_note, autofocus: true, onSelect: () => context.go('/agenda')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveDot extends StatefulWidget {
  const _LiveDot();
  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _c,
      child: Container(width: 12, height: 12, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
    );
  }
}
