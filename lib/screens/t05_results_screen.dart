import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:mi_feria_inteligente/data/mock_data.dart';
import 'package:mi_feria_inteligente/models/models.dart';
import 'package:mi_feria_inteligente/widgets/widgets.dart';

/// Refleja en tiempo real los votos emitidos desde la app móvil (M-07).
class T05ResultsScreen extends StatelessWidget {
  const T05ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final total = voteResults.fold<int>(0, (sum, v) => sum + v.votes);
    final winner = voteResults.isEmpty ? null : voteResults.reduce((a, b) => a.votes >= b.votes ? a : b);
    final colors = [Colors.redAccent, Colors.amber, Colors.lightGreen, Colors.blueAccent];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
          child: Column(
            children: [
              const Text('Resultados de Votación', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              const Text('¿Cuál fue el mejor stand?', style: TextStyle(color: Colors.white60, fontSize: 18)),
              const SizedBox(height: 32),
              Expanded(
                child: voteResults.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay votos registrados',
                          style: TextStyle(color: Colors.white30, fontSize: 20),
                        ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (var i = 0; i < voteResults.length; i++)
                            _bar(context, voteResults[i], total, colors[i % colors.length]),
                        ],
                      ),
              ),
              const SizedBox(height: 24),
              if (winner != null)
                FadeInUp(
                  child: Text(
                    '${winner.label.toUpperCase()} — GANADOR',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              const SizedBox(height: 24),
              TvButton(label: 'Volver a agenda', icon: Icons.event_note, autofocus: true, onSelect: () => context.go('/agenda')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bar(BuildContext context, VoteOption v, int total, Color color) {
    final pct = total == 0 ? 0.0 : v.votes / total;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('${(pct * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: pct),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) => Container(
            width: 70,
            height: 220 * value,
            decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.vertical(top: Radius.circular(8))),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(width: 100, child: Text(v.label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Colors.white70))),
      ],
    );
  }
}
