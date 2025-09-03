import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/bc_scaffold.dart';
import '../../../core/widgets/segment_header.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../../../data/models/child.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class BabyGenderView extends StatefulWidget {
  const BabyGenderView({super.key});

  @override
  State<BabyGenderView> createState() => _BabyGenderViewState();
}

class _BabyGenderViewState extends State<BabyGenderView> {
  late OnboardingController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<OnboardingController>();
  }

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
                    title: "Is your baby a boy or girl?",
                    padding: EdgeInsets.only(
                      top: AppSpacing.xxl,
                      bottom: AppSpacing.betweenSections,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            controller.setBabyGender(Gender.boy);
                            setState(() {});
                          },
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                              border: Border.all(
                                color: controller.babyGender == Gender.boy
                                    ? AppColors.borderSelected
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: controller.babyGender == Gender.boy
                                        ? AppColors.primary
                                        : AppColors.cardBackgroundSecondary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.boy,
                                    color: AppColors.textPrimary,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'Boy',
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            controller.setBabyGender(Gender.girl);
                            setState(() {});
                          },
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                              border: Border.all(
                                color: controller.babyGender == Gender.girl
                                    ? AppColors.borderSelected
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: controller.babyGender == Gender.girl
                                        ? AppColors.primary
                                        : AppColors.cardBackgroundSecondary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.girl,
                                    color: AppColors.textPrimary,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'Girl',
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: PrimaryButton(
                label: "Next",
                onTap: () => Get.toNamed(Routes.birthWeightMetric),
                isEnabled: true, // Always enabled since a default gender is set
              ),
            ),
          ),
        ],
      ),
    );
  }
}
