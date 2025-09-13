import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/info_hero_view.dart';
import '../../../routes/app_routes.dart';

class SpurtIntroView extends StatelessWidget {
  const SpurtIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoHeroView(
      title: "Growth spurts are coming!",
      body: "Growth spurts are periods of rapid development that can affect your baby's eating, sleeping, and behavior. Understanding these patterns will help you support your baby through these important phases.",
      ctaText: "Next",
      onCtaTap: () => Get.toNamed(Routes.similarChanges),
      showBack: false,
    );
  }
}
