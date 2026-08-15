import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mi_feria_inteligente/data/mock_data.dart';
import 'package:mi_feria_inteligente/models/feria_alert.dart';
import 'package:mi_feria_inteligente/widgets/widgets.dart';

/// Máxima prioridad: interrumpe cualquier contenido. En producción solo el
/// panel web del organizador puede desactivarla; aquí se simula un cierre.
class T06AlertScreen extends StatelessWidget {
  const T06AlertScreen({super.key, this.alert = demoAlert});
  final FeriaAlert alert;

  @override
  Widget build(BuildContext context) {
    final isEmergencia = alert.level == AlertLevel.emergencia;
    final bg = isEmergencia ? const Color(0xFF7F1D1D) : const Color(0xFF78350F);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: bg,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded, size: 96, color: Colors.white),
                const SizedBox(height: 16),
                Text(isEmergencia ? '¡ALERTA DE EMERGENCIA!' : 'AVISO URGENTE',
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: 1)),
                const SizedBox(height: 24),
                Text(alert.message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 12),
                Text(alert.instruction, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, color: Colors.white70)),
                const SizedBox(height: 40),
                // En el sistema real este botón no existe: solo el panel web
                // del organizador puede cerrar la alerta. Se deja para demo.
                TvButton(label: 'Simular cierre (solo panel web)', icon: Icons.admin_panel_settings, onSelect: () => context.go('/agenda')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
