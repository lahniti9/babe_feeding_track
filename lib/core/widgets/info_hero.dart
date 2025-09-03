import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/text.dart';
import 'primary_button.dart';

class InfoHero extends StatelessWidget {
  final Widget? image;
  final String? imageAsset;
  final String title;
  final String? body;
  final String ctaText;
  final VoidCallback? onCtaTap;
  final bool autoAdvance;
  final Duration autoAdvanceDelay;

  const InfoHero({
    super.key,
    this.image,
    this.imageAsset,
    required this.title,
    this.body,
    this.ctaText = "Next",
    this.onCtaTap,
    this.autoAdvance = false,
    this.autoAdvanceDelay = const Duration(seconds: 3),
  });

  @override
  Widget build(BuildContext context) {
    if (autoAdvance && onCtaTap != null) {
      Future.delayed(autoAdvanceDelay, () {
        if (context.mounted) {
          onCtaTap!();
        }
      });
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (image != null || imageAsset != null) ...[
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLarge),
                        ),
                        child: image ?? 
                            (imageAsset != null 
                                ? Image.asset(
                                    imageAsset!,
                                    fit: BoxFit.contain,
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.cardBackground,
                                      borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLarge),
                                    ),
                                    child: const Icon(
                                      Icons.baby_changing_station,
                                      size: 80,
                                      color: AppColors.primary,
                                    ),
                                  )),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                    ],
                    Text(
                      title,
                      style: AppTextStyles.hero,
                      textAlign: TextAlign.center,
                    ),
                    if (body != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        body!,
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              if (!autoAdvance)
                PrimaryButton(
                  label: ctaText,
                  onTap: onCtaTap,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
