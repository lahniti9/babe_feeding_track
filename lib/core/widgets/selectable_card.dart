import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/text.dart';
import 'primary_button.dart';

class SelectableCard extends StatelessWidget {
  final Widget? image;
  final String? imageAsset;
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback? onTap;
  final String buttonText;

  const SelectableCard({
    super.key,
    this.image,
    this.imageAsset,
    required this.title,
    this.subtitle,
    this.selected = false,
    this.onTap,
    this.buttonText = "Select",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Material(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(
                color: selected ? AppColors.borderSelected : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                // Image section
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.cardBackgroundSecondary,
                    borderRadius: BorderRadius.circular(AppSpacing.md),
                  ),
                  child: image ?? 
                      (imageAsset != null 
                          ? Image.asset(
                              imageAsset!,
                              fit: BoxFit.contain,
                            )
                          : const Icon(
                              Icons.baby_changing_station,
                              size: 40,
                              color: AppColors.primary,
                            )),
                ),
                const SizedBox(width: AppSpacing.lg),
                
                // Content section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyLarge,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          subtitle!,
                          style: AppTextStyles.subtitle,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.md),
                      PrimaryButton(
                        label: buttonText,
                        onTap: onTap,
                        height: 40,
                        backgroundColor: selected ? AppColors.primary : AppColors.cardBackgroundSecondary,
                        textColor: selected ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
