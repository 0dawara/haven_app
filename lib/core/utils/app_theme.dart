import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF141018); // Dark background
  static const Color cardColor = Color(
    0xFF25222A,
  ); // Slightly lighter for cards/bars
  static const Color primaryPurple = Color(0xFFBC00FF); // Vibrant purple
  static const Color accentGreen = Color(0xFF4CAF50); // SFW Green
  static const Color accentOrange = Color(0xFFFF9800); // Sketchy Orange
  static const Color accentRed = Color(0xFFF44336); // NSFW Red
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: primaryPurple,
      colorScheme: const ColorScheme.dark(
        primary: primaryPurple,
        surface: cardColor,
        onSurface: textPrimary,
      ),
      iconTheme: const IconThemeData(color: textPrimary),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: textPrimary),
        titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      ),
    );
  }
}
