import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text.dart';

class EnhancedChipGroup extends StatelessWidget {
  final String label;
  final List<String> options;
  final RxSet<String> selected;
  final bool multiSelect;
  final IconData? icon;
  final Color? accentColor;
  final Function(String) onTap;

  const EnhancedChipGroup({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    this.multiSelect = true,
    this.icon,
    this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveAccentColor = accentColor ?? AppColors.coral;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enhanced section header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: effectiveAccentColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: effectiveAccentColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: effectiveAccentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: effectiveAccentColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                label.toUpperCase(),
                style: AppTextStyles.captionMedium.copyWith(
                  color: effectiveAccentColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Enhanced chips
        Obx(() => Wrap(
          spacing: 12,
          runSpacing: 12,
          children: options.map((option) {
            final isSelected = selected.contains(option);
            return GestureDetector(
              onTap: () => onTap(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected ? LinearGradient(
                    colors: [
                      effectiveAccentColor,
                      effectiveAccentColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ) : null,
                  color: isSelected ? null : AppColors.cardBackgroundSecondary,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected 
                      ? effectiveAccentColor.withValues(alpha: 0.6)
                      : AppColors.textSecondary.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: effectiveAccentColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: effectiveAccentColor.withValues(alpha: 0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ] : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) ...[
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      option,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        )),
      ],
    );
  }
}

class EnhancedSegmentedControl extends StatelessWidget {
  final String label;
  final List<String> options;
  final String selected;
  final Function(String) onSelect;
  final IconData? icon;
  final Color? accentColor;

  const EnhancedSegmentedControl({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelect,
    this.icon,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveAccentColor = accentColor ?? AppColors.coral;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enhanced section header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: effectiveAccentColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: effectiveAccentColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: effectiveAccentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: effectiveAccentColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                label.toUpperCase(),
                style: AppTextStyles.captionMedium.copyWith(
                  color: effectiveAccentColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Enhanced segmented control
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.cardBackgroundSecondary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.textSecondary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: options.map((option) {
              final isSelected = selected == option;
              
              return Expanded(
                child: GestureDetector(
                  onTap: () => onSelect(option),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: isSelected ? LinearGradient(
                        colors: [
                          effectiveAccentColor,
                          effectiveAccentColor.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ) : null,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: effectiveAccentColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ] : null,
                    ),
                    child: Text(
                      option,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
