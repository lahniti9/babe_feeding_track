import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/spacing.dart';
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
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
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
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                label.toUpperCase(),
                style: AppTextStyles.captionMedium.copyWith(
                  color: iconColor ?? const Color(0xFF7367F0),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Chips
          Obx(() => Wrap(
            spacing: 10,
            runSpacing: 12,
            children: options.map((option) {
              final isSelected = selected.contains(option);
              return GestureDetector(
                onTap: () => _toggleOption(option),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                      ? AppColors.coral.withValues(alpha: 0.2)
                      : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                        ? AppColors.coral
                        : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: AppColors.coral.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? AppColors.coral : Colors.white,
                      fontSize: 15,
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
