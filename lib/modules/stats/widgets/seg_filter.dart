import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';

class SegFilter extends StatelessWidget {
  final List<String> options;
  final String selectedOption;
  final Function(String) onChanged;

  const SegFilter({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = option == selectedOption;
          final isFirst = index == 0;
          final isLast = index == options.length - 1;

          return GestureDetector(
            onTap: () => onChanged(option),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isFirst ? AppSpacing.sm : 0),
                  bottomLeft: Radius.circular(isFirst ? AppSpacing.sm : 0),
                  topRight: Radius.circular(isLast ? AppSpacing.sm : 0),
                  bottomRight: Radius.circular(isLast ? AppSpacing.sm : 0),
                ),
              ),
              child: Text(
                option,
                style: AppTextStyles.caption.copyWith(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Predefined filter sets for common use cases
class FilterSets {
  static const List<String> dayWeekMonthYear = ['Day', 'Week', 'Month', 'Year'];
  static const List<String> weekMonthYear = ['Week', 'Month', 'Year'];
  static const List<String> dayMonthYear = ['Day', 'Month', 'Year'];
  static const List<String> weekMonth = ['Week', 'Month'];
  
  // Monthly overview filters
  static const List<String> monthlyOverview = [
    'All events',
    'Bottle',
    'Daytime sleep',
  ];
  
  // Feeding type filters
  static const List<String> feedingTypes = [
    'Formula',
    'Breast milk',
  ];
}
