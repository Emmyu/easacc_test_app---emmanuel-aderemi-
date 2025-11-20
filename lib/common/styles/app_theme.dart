import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// Holds both light and dark themes for the app.
class AppTheme {
  const AppTheme({
    required this.lightTheme,
    required this.darkTheme,
  });

  final ThemeData lightTheme;
  final ThemeData darkTheme;
}

/// Provides an [AppTheme] instance to the widget tree.
final appThemeProvider = Provider<AppTheme>((ref) {
  final baseLight = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    textTheme: GoogleFonts.interTextTheme(),
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF6F6F8),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );

  final baseDark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.dark,
    ),
    textTheme: GoogleFonts.interTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ),
    useMaterial3: true,
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );

  return AppTheme(lightTheme: baseLight, darkTheme: baseDark);
});


