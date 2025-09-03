import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/info_hero_view.dart';
import '../../../routes/app_routes.dart';

class TeamIntroView extends StatelessWidget {
  const TeamIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoHeroView(
      title: "Let's build your team!",
      body: "Great parenting is a team effort. Let's set up your care team so everyone can stay connected and informed about your baby's needs.",
      ctaText: "Let's do it!",
      onCtaTap: () => Get.toNamed(Routes.parentName),
    );
  }
}
