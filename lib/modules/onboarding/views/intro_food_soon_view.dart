import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/info_hero_view.dart';
import '../../../routes/app_routes.dart';

class IntroFoodSoonView extends StatelessWidget {
  const IntroFoodSoonView({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoHeroView(
      title: "You'll introduce food soon!",
      body: "Starting solid foods is an exciting milestone! We'll guide you through safe first foods, feeding schedules, and help you recognize when your baby is ready for this next step.",
      ctaText: "Next",
      onCtaTap: () => Get.toNamed(Routes.learnAboutDev),
      showBack: false,
    );
  }
}
