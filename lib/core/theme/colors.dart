import 'package:flutter/material.dart';

class AppColors {
  // Dark theme colors
  static const Color background = Color(0xFF0F0F0F);
  static const Color cardBackground = Color(0xFF181818);
  static const Color cardBackgroundSecondary = Color(0xFF1A1A1A);
  
  // Primary colors
  static const Color primary = Color(0xFFFFA629); // Amber-orange
  static const Color primaryDark = Color(0xFFE6941F);
  
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
  static const Color growthLeap = primary; // Orange
  static const Color fussyPhase = Color(0xFF4CAF50); // Green
  static const Color inactive = Color(0xFF424242); // Dark grey
  
  // Transparent overlays
  static const Color overlay = Color(0x80000000);
  static const Color shimmer = Color(0xFF2C2C2C);
}
