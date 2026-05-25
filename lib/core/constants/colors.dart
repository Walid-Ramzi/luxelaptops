import 'package:flutter/material.dart';

/// Premium dark palette for LuxeLaptops.
abstract final class AppColors {
  static const Color background = Color(0xFF0A0A0F);
  static const Color card = Color(0xFF12121E);
  static const Color cardElevated = Color(0xFF1A1A2A);
  static const Color primary = Color(0xFF00A2FF);
  static const Color secondary = Color(0xFF00FFCC);
  static const Color textPrimary = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color border = Color(0xFF2A2A3E);
  static const Color error = Color(0xFFFF453A);
  static const Color success = Color(0xFF32D74B);

  static const LinearGradient primaryGlow = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static List<BoxShadow> neonGlow(Color color, {double blur = 24}) => [
        BoxShadow(
          color: color.withValues(alpha: 0.45),
          blurRadius: blur,
          spreadRadius: -4,
        ),
        BoxShadow(
          color: color.withValues(alpha: 0.2),
          blurRadius: blur * 2,
          spreadRadius: -8,
        ),
      ];
}
