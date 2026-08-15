import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mi_feria_inteligente/widgets/widgets.dart';

/// Solo la ve el operador al configurar la pantalla. El código lo entregan
/// los organizadores; al "verificarlo" la TV se registra en el backend.
class T01LinkScreen extends StatefulWidget {
  const T01LinkScreen({super.key});

  @override
  State<T01LinkScreen> createState() => _T01LinkScreenState();
}

class _T01LinkScreenState extends State<T01LinkScreen> {
  String _status = 'Sin internet';

  void _connect() async {
    setState(() => _status = 'Conectando...');
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _status = 'Conectado');
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) context.go('/bienvenida');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 480,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Vincular Pantalla', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Ingrese el código proporcionado por los organizadores', style: TextStyle(color: Colors.white60)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['K', 'F', 'G', 'X', '4', '7']
                    .map((c) => Container(
                          width: 44,
                          height: 56,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
                          child: Text(c, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              Text(_status, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
              const SizedBox(height: 24),
              TvButton(label: 'Conectar al servidor', icon: Icons.wifi, autofocus: true, onSelect: _connect),
            ],
          ),
        ),
      ),
    );
  }
}
