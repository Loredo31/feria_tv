import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/tv_state.dart';
import 'config/router/router.dart';
import 'config/theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider.value(
      value: tvState,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mi Feria Inteligente - TV',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: appRouter,
    );
  }
}
