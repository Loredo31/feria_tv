import 'package:go_router/go_router.dart';
import '../../screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const T01LinkScreen()),
    GoRoute(path: '/bienvenida', builder: (context, state) => const T02WelcomeScreen()),
    GoRoute(path: '/agenda', builder: (context, state) => const T03AgendaScreen()),
    GoRoute(path: '/transmision', builder: (context, state) => const T04StreamScreen()),
    GoRoute(path: '/resultados', builder: (context, state) => const T05ResultsScreen()),
    GoRoute(path: '/alerta', builder: (context, state) => const T06AlertScreen()),
  ],
);
