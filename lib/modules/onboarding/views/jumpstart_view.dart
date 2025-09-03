import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/info_hero_view.dart';
import '../../../routes/app_routes.dart';

class JumpstartView extends StatelessWidget {
  const JumpstartView({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoHeroView(
      title: "Jumpstart your journey in the app!",
      body: "You're all set! Your personalized baby care experience is ready. Track feeding, monitor sleep, celebrate milestones, and get expert guidance whenever you need it.",
      ctaText: "Get Started",
      onCtaTap: () => Get.toNamed(Routes.logRecent),
    );
  }
}
