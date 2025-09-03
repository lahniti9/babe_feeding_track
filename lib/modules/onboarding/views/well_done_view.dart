import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/bc_scaffold.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../../../routes/app_routes.dart';

class WellDoneView extends StatefulWidget {
  const WellDoneView({super.key});

  @override
  State<WellDoneView> createState() => _WellDoneViewState();
}

class _WellDoneViewState extends State<WellDoneView> {
  @override
  void initState() {
    super.initState();
    // Auto-navigate after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Get.toNamed(Routes.habit);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BCScaffold(
      showBack: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: AppColors.textPrimary,
                  size: 60,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                "Well done!",
                style: AppTextStyles.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                "Your first event has been logged successfully.",
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
