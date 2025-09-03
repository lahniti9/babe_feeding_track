import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/text.dart';

enum MetricSystem { metric, imperial }

class MetricToggle extends StatelessWidget {
  final MetricSystem selectedSystem;
  final Function(MetricSystem) onChanged;

  const MetricToggle({
    super.key,
    required this.selectedSystem,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            'g/kg',
            MetricSystem.metric,
            selectedSystem == MetricSystem.metric,
          ),
          _buildToggleButton(
            'lb/oz',
            MetricSystem.imperial,
            selectedSystem == MetricSystem.imperial,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, MetricSystem system, bool isSelected) {
    return GestureDetector(
      onTap: () => onChanged(system),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        ),
        child: Text(
          label,
          style: AppTextStyles.buttonTextSmall.copyWith(
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
