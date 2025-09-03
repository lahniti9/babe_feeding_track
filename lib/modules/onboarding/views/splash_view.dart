import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/info_hero_view.dart';
import '../../../routes/app_routes.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoHeroView(
      title: "raise happy & healthy babies",
      body: "Welcome to your personalized baby care journey. Let's get started with understanding your needs.",
      ctaText: "Let's start",
      showBack: false,
      onCtaTap: () => Get.toNamed(Routes.startGoal),
    );
  }
}
