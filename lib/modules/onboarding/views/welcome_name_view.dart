import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/info_hero_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class WelcomeNameView extends StatelessWidget {
  const WelcomeNameView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return InfoHeroView(
      title: "Welcome, ${controller.parentName}! 👋",
      body: "Great to have you here! Let's continue setting up your baby's profile.",
      ctaText: "Next",
      onCtaTap: () => Get.toNamed(Routes.babyName),
      showBack: false,
    );
  }
}
