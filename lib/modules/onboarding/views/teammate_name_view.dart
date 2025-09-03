import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/text_input_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';
import '../../profile/profile_controller.dart';

class TeammateNameView extends StatelessWidget {
  const TeammateNameView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return TextInputView(
      title: "Any other teammates?",
      caption: "Add family members or caregivers who help with baby care",
      value: controller.teammateName,
      hint: "Enter teammate's name",
      required: false,
      showSkip: true,
      skipText: "Skip",
      onSkip: () => _completeOnboardingWithoutTeammate(), // Skip to main app
      onValueChanged: (value) {
        controller.setTeammateName(value);
      },
      onNext: () {
        if (controller.teammateName.isNotEmpty) {
          Get.toNamed(Routes.teammateRole);
        } else {
          _completeOnboardingWithoutTeammate();
        }
      },
    );
  }

  void _completeOnboardingWithoutTeammate() {
    final controller = Get.find<OnboardingController>();
    final profileController = Get.find<ProfileController>();

    // Create profile from onboarding data without teammate
    profileController.createProfileFromOnboarding(
      parentName: controller.parentName,
      parentRole: controller.parentRole,
      babyName: controller.babyName,
      babyBirthday: controller.babyBirthday,
      babyGender: controller.babyGender,
      birthWeight: controller.birthWeight!,
      teammateName: null,
      teammateRole: null,
      metricSystem: controller.metricSystem,
    );

    // Mark onboarding as completed and navigate to main app
    controller.completeOnboarding();
  }
}
