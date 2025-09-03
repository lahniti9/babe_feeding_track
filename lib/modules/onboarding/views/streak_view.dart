import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/bc_scaffold.dart';
import '../../../core/widgets/segment_header.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../controllers/onboarding_controller.dart';
import '../../profile/profile_controller.dart';

class StreakView extends StatelessWidget {
  const StreakView({super.key});

  @override
  Widget build(BuildContext context) {
    return BCScaffold(
      showBack: true,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              child: Column(
                children: [
                  const SegmentHeader(
                    title: "Your first streak!",
                    padding: EdgeInsets.only(
                      top: AppSpacing.xxl,
                      bottom: AppSpacing.betweenSections,
                    ),
                  ),
                  // Streak coins
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStreakCoin("YESTERDAY", false),
                      _buildStreakCoin("TODAY", true),
                      _buildStreakCoin("DAY 2", false),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    "Keep tracking daily to build your streak and unlock insights about your baby's patterns!",
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: PrimaryButton(
              label: "Let's do it!",
              onTap: () => _completeOnboarding(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCoin(String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.cardBackground,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.border,
              width: 2,
            ),
          ),
          child: Icon(
            Icons.star,
            color: isActive ? Colors.white : AppColors.textSecondary,
            size: 30,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isActive ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  void _completeOnboarding() {
    final onboardingController = Get.find<OnboardingController>();
    final profileController = Get.find<ProfileController>();
    
    // Create profile from onboarding data
    profileController.createProfileFromOnboarding(
      parentName: onboardingController.parentName,
      parentRole: onboardingController.parentRole,
      babyName: onboardingController.babyName,
      babyBirthday: onboardingController.babyBirthday,
      babyGender: onboardingController.babyGender,
      birthWeight: onboardingController.birthWeight!,
      teammateName: onboardingController.teammateName.isNotEmpty ? onboardingController.teammateName : null,
      teammateRole: onboardingController.teammateName.isNotEmpty ? onboardingController.teammateRole : null,
      metricSystem: onboardingController.metricSystem,
    );
    
    // Mark onboarding as completed and navigate to main app
    onboardingController.completeOnboarding();
  }
}
