import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(seedColor: Colors.green);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: scheme.surface,
      ),
      inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
    );
  }
}
