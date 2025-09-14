import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/text.dart';
import '../../../core/theme/colors.dart';

class ChipGroupRow extends StatelessWidget {
  final String label;
  final List<String> options;
  final RxSet<String> selected;
  final bool multi;
  final IconData? icon;
  final Color? iconColor;

  const ChipGroupRow({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    this.multi = true,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), // Reduced from AppSpacing.lg (20) to 16
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label with optional icon
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: iconColor ?? const Color(0xFF7367F0),
                  size: 18, // Reduced from 20 to 18
                ),
                const SizedBox(width: 6), // Reduced from 8 to 6
              ],
              Text(
                label.toUpperCase(),
                style: AppTextStyles.captionMedium.copyWith(
                  color: iconColor ?? const Color(0xFF7367F0),
                  fontWeight: FontWeight.w600,
                  fontSize: 12, // Reduced font size
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Reduced from 16 to 12

          // Chips
          Obx(() => Wrap(
            spacing: 8, // Reduced from 10 to 8
            runSpacing: 8, // Reduced from 12 to 8
            children: options.map((option) {
              final isSelected = selected.contains(option);
              return GestureDetector(
                onTap: () => _toggleOption(option),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), // Reduced padding
                  decoration: BoxDecoration(
                    color: isSelected
                      ? AppColors.coral.withValues(alpha: 0.2)
                      : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(16), // Reduced from 20 to 16
                    border: Border.all(
                      color: isSelected
                        ? AppColors.coral
                        : const Color(0xFF3A3A3A), // Added subtle border for unselected
                      width: 1.5, // Reduced from 2 to 1.5
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: AppColors.coral.withValues(alpha: 0.3),
                        blurRadius: 6, // Reduced from 8 to 6
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? AppColors.coral : Colors.white,
                      fontSize: 14, // Reduced from 15 to 14
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }

  void _toggleOption(String option) {
    if (multi) {
      if (selected.contains(option)) {
        selected.remove(option);
      } else {
        selected.add(option);
      }
    } else {
      // For single selection, clear and add the new option
      selected.clear();
      selected.add(option);
    }
  }
}
