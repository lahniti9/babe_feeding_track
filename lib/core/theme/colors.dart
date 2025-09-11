import 'package:flutter/material.dart';

class AppColors {
  // 🎨 Primary Brand Colors (Maintained Exactly)
  static const Color coral = Color(0xFFFF6B6B);
  static const Color softCoral = Color(0xFFFF8A80);
  static const Color lightCoral = Color(0xFFFFB3BA);
  static const Color cream = Color(0xFFFFF8F0);

  // Dark theme colors
  static const Color background = Color(0xFF0F0F0F);
  static const Color cardBackground = Color(0xFF181818);
  static const Color cardBackgroundSecondary = Color(0xFF1A1A1A);

  // Primary colors (Updated to use coral)
  static const Color primary = coral;
  static const Color primaryDark = Color(0xFFE55A5A);
  static const Color primaryLight = softCoral;
  static const Color primaryAccent = lightCoral;
  
  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color textCaption = Color(0xFF757575);
  
  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Border colors
  static const Color border = Color(0xFF2C2C2C);
  static const Color borderSelected = primary;
  
  // Growth spurt calendar colors
  static const Color growthLeap = coral; // Coral
  static const Color fussyPhase = Color(0xFF4CAF50); // Green
  static const Color inactive = Color(0xFF424242); // Dark grey
  
  // Transparent overlays
  static const Color overlay = Color(0x80000000);
  static const Color shimmer = Color(0xFF2C2C2C);
}
