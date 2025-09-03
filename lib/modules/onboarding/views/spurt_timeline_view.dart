import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/info_hero_view.dart';
import '../../../routes/app_routes.dart';

class SpurtTimelineView extends StatelessWidget {
  const SpurtTimelineView({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoHeroView(
      title: "Your spurt timeline is calculated!",
      body: "Based on your baby's age and development, we've created a personalized growth spurt timeline. You'll receive notifications before each expected spurt so you can prepare.\n\n📅 Today: Current phase\n🔜 Next: 2 weeks\n📈 Following: 6 weeks",
      ctaText: "Next",
      onCtaTap: () => Get.toNamed(Routes.promiseFingerprint),
    );
  }
}
