import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/info_hero_view.dart';
import '../../../routes/app_routes.dart';

class FeedingRightPlaceView extends StatelessWidget {
  const FeedingRightPlaceView({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoHeroView(
      title: "You're in the right place!",
      body: "Great choice! We'll help you track feeding patterns, understand your baby's needs, and provide personalized guidance for your feeding journey.",
      ctaText: "Next",
      onCtaTap: () => Get.toNamed(Routes.sleepIssues),
    );
  }
}
