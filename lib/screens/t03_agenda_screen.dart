import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:mi_feria_inteligente/providers/tv_state.dart';
import 'package:mi_feria_inteligente/models/models.dart';
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
    final tvState = context.watch<TvState>();
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
                  Text(tvState.eventName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  TvButton(label: 'Transmisión', icon: Icons.live_tv, onSelect: () => context.go('/transmision')),
                  const SizedBox(width: 12),
                  TvButton(label: 'Votación', icon: Icons.poll, onSelect: () => context.go('/resultados')),
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
                    Expanded(flex: 6, child: _mainActivityPanel(tvState.currentActivity)),
                    const SizedBox(width: 24),
                    Expanded(flex: 4, child: _nextActivitiesPanel(tvState.nextActivities)),
                  ],
                ),
              ),
            ),
            // Servicios del recinto
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
              child: Row(
                children: [
                  Icon(Icons.wc, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text('Baños al fondo', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  const SizedBox(width: 32),
                  Icon(Icons.medical_services, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text('Primeros Auxilios', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  const SizedBox(width: 32),
                  Icon(Icons.exit_to_app, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text('Salidas de Emergencia', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mainActivityPanel(FeriaActivity activity) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusBadge(status: activity.status),
          const SizedBox(height: 16),
          Text(activity.title, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(activity.place, style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const Spacer(),
          Text(
            'Horario: ${activity.time}',
            style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }

  Widget _nextActivitiesPanel(List<FeriaActivity> activities) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Programa del día', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Expanded(
            child: activities.isEmpty
                ? const Center(
                    child: Text(
                      'No hay actividades programadas',
                      style: TextStyle(color: Colors.black38),
                    ),
                  )
                : ListView.separated(
                    itemCount: activities.length,
                    separatorBuilder: (context, index) => const Divider(color: Colors.black12),
                    itemBuilder: (context, i) {
                      final a = activities[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                a.time,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                  fontSize: 12,
                                ),
                              ),
                            ),
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
