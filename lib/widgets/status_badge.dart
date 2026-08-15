import 'package:flutter/material.dart';
import 'package:mi_feria_inteligente/models/activity.dart';

class StatusBadge extends StatelessWidget {
  final ActivityStatus status;
  const StatusBadge({super.key, required this.status});

  (String, Color) get _data => switch (status) {
        ActivityStatus.enCurso => ('EN VIVO', Colors.green),
        ActivityStatus.cancelado => ('CANCELADO', Colors.red),
        ActivityStatus.reprogramado => ('REPROGRAMADO', Colors.amber),
        ActivityStatus.finalizado => ('FINALIZADO', Colors.white38),
        ActivityStatus.proximo => ('PRÓXIMO', Colors.white54),
      };

  @override
  Widget build(BuildContext context) {
    final (label, color) = _data;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6), border: Border.all(color: color)),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}
