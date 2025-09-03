import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/info_hero_view.dart';
import '../../../routes/app_routes.dart';

class NeedsLearnToSleepView extends StatelessWidget {
  const NeedsLearnToSleepView({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoHeroView(
      title: "Your baby needs to learn how to sleep",
      body: "Just like walking and talking, sleeping is a skill that babies need to learn. We'll help you understand your baby's sleep patterns and provide gentle guidance to improve rest for the whole family.",
      ctaText: "Next",
      onCtaTap: () => Get.toNamed(Routes.startFeedingKnowHow),
    );
  }
}
