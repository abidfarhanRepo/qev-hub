import 'package:flutter/material.dart';

/// App color scheme matching QEV-HUB-WEB design
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF00D084); // Electric Green
  static const Color primaryDark = Color(0xFF00A86B);
  static const Color primaryLight = Color(0xFF33E3A3);

  // Secondary Colors
  static const Color secondary = Color(0xFF0F172A); // Deep Blue
  static const Color secondaryDark = Color(0xFF0A0F1D);
  static const Color secondaryLight = Color(0xFF1E293B);

  // Accent Colors
  static const Color accent = Color(0xFF7C3AED); // Electric Purple
  static const Color accentDark = Color(0xFF6D28D9);
  static const Color accentLight = Color(0xFF8B5CF6);

  // Background Colors
  static const Color background = Color(0xFF0A0A0A); // Dark
  static const Color backgroundDark = Color(0xFF050505);
  static const Color backgroundLight = Color(0xFF121212);

  // Surface Colors
  static const Color surface = Color(0xFF121212); // Card Dark
  static const Color surfaceVariant = Color(0xFF1A1A1A);
  static const Color surfaceLight = Color(0xFF242424);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB4B4B4);
  static const Color textTertiary = Color(0xFF737373);
  static const Color textDisabled = Color(0xFF4A4A4A);

  // Status Colors
  static const Color success = Color(0xFF00D084);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Border Colors
  static const Color border = Color(0xFF2A2A2A);
  static const Color borderLight = Color(0xFF3A3A3A);
  static const Color borderDark = Color(0xFF1A1A1A);

  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);

  // Gradient Colors
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const Gradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentLight],
  );

  static const Gradient surfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surface, surfaceVariant],
  );

  // Glassmorphism
  static Color glass({double opacity = 0.1}) {
    return Colors.white.withOpacity(opacity);
  }
}

/// Light color scheme (optional, for future use)
class AppColorsLight {
  AppColorsLight._();

  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color primary = Color(0xFF00C77C);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
}
