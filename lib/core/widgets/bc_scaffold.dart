import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/text.dart';

class BCScaffold extends StatelessWidget {
  final String? title;
  final bool showBack;
  final Widget body;
  final Widget? bottomBar;
  final Widget? floatingActionButton;
  final String? skipText;
  final VoidCallback? onSkip;

  const BCScaffold({
    super.key,
    this.title,
    this.showBack = true,
    required this.body,
    this.bottomBar,
    this.floatingActionButton,
    this.skipText,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: title != null || showBack || skipText != null
          ? AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              leading: showBack
                  ? IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.textPrimary,
                        size: AppSpacing.iconMd,
                      ),
                      onPressed: () => Get.back(),
                    )
                  : null,
              title: title != null
                  ? Text(
                      title!,
                      style: AppTextStyles.titleMedium,
                    )
                  : null,
              centerTitle: true,
              actions: skipText != null && onSkip != null
                  ? [
                      TextButton(
                        onPressed: onSkip,
                        child: Text(
                          skipText!,
                          style: AppTextStyles.buttonTextSmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                    ]
                  : null,
            )
          : null,
      body: SafeArea(
        child: body,
      ),
      bottomNavigationBar: bottomBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
