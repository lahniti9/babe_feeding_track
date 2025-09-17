import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/colors.dart';

class SingleSelectChips<T> extends StatelessWidget {
  final List<T> options;
  final Rx<T?> selected;
  final Function(T) onTap;
  final String Function(T) getDisplayName;
  final Color? accentColor;

  const SingleSelectChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onTap,
    required this.getDisplayName,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveAccentColor = accentColor ?? AppColors.coral;
    
    return Obx(() => Wrap(
      spacing: 6, 
      runSpacing: 6,
      children: options.map((option) {
        final isSelected = selected.value == option;
        return GestureDetector(
          onTap: () => onTap(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), 
            decoration: BoxDecoration(
              gradient: isSelected ? LinearGradient(
                colors: [
                  effectiveAccentColor,
                  effectiveAccentColor.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ) : null,
              color: isSelected ? null : const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(14), // Slightly smaller radius
              border: Border.all(
                color: isSelected 
                  ? effectiveAccentColor.withValues(alpha: 0.6)
                  : const Color(0xFF3A3A3A),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: effectiveAccentColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
                BoxShadow(
                  color: effectiveAccentColor.withValues(alpha: 0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ] : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              getDisplayName(option),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 13, // Reduced font size to make it more compact
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    ));
  }
}
