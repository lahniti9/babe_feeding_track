import 'package:flutter/material.dart';
import 'event.dart';

// Quick action config for the header row
class QuickAction {
  final EventKind kind;
  final String label;
  final IconData icon;         // swap with your custom icon pack
  final Color bgColor;         // circle color (matches your palette)
  final Set<UserRole> roles;   // who can see it
  
  const QuickAction({
    required this.kind,
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.roles,
  });
}
