import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const seedColor = Color(0xFF1E3A8A);

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.light,
  );

  final base = ThemeData(colorScheme: scheme, useMaterial3: true);

  return base.copyWith(
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    textTheme: GoogleFonts.montserratTextTheme(base.textTheme).apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    ),
  );
}
