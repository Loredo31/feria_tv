import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:mi_feria_inteligente/providers/tv_state.dart';
import 'package:mi_feria_inteligente/widgets/widgets.dart';

/// Solo la ve el operador al configurar la pantalla. El código lo entregan
/// los organizadores; al "verificarlo" la TV se registra en el backend.
class T01LinkScreen extends StatefulWidget {
  const T01LinkScreen({super.key});

  @override
  State<T01LinkScreen> createState() => _T01LinkScreenState();
}

class _T01LinkScreenState extends State<T01LinkScreen> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<TvState>();

    // Redirigir a bienvenida si ya está conectado
    if (state.isConnected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/bienvenida');
      });
    }

    return Scaffold(
      body: Center(
        child: Container(
          width: 480,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Vincular Pantalla', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                'Ingrese el código proporcionado por los organizadores',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['K', 'F', 'G', 'X', '4', '7']
                    .map((c) => Container(
                          width: 44,
                          height: 56,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(c, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              Text(state.connectionStatus, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600)),
              const SizedBox(height: 24),
              TvButton(
                label: 'Conectar al servidor',
                icon: Icons.wifi,
                autofocus: true,
                onSelect: () => context.read<TvState>().connect(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
