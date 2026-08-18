import 'package:go_router/go_router.dart';
import '../../providers/tv_state.dart';
import '../../models/models.dart';
import '../../screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: tvState,
  redirect: (context, state) {
    if (tvState.activeAlert != null) {
      if (state.matchedLocation != '/alerta') {
        return '/alerta';
      }
    } else {
      if (state.matchedLocation == '/alerta') {
        return '/agenda';
      }
    }
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const T01LinkScreen()),
    GoRoute(path: '/bienvenida', builder: (context, state) => const T02WelcomeScreen()),
    GoRoute(path: '/agenda', builder: (context, state) => const T03AgendaScreen()),
    GoRoute(path: '/transmision', builder: (context, state) => const T04StreamScreen()),
    GoRoute(path: '/resultados', builder: (context, state) => const T05ResultsScreen()),
    GoRoute(
      path: '/alerta',
      builder: (context, state) => T06AlertScreen(
        alert: tvState.activeAlert ?? const FeriaAlert(
          message: 'Sin alertas activas',
          instruction: 'Todo opera con normalidad.',
          level: AlertLevel.aviso,
        ),
      ),
    ),
  ],
);
