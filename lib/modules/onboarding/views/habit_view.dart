import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/info_hero_view.dart';
import '../../../routes/app_routes.dart';

class HabitView extends StatelessWidget {
  const HabitView({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoHeroView(
      title: "Turn tracking into a habit",
      body: "Consistent tracking helps you understand your baby's patterns and needs. Just like watering a plant, regular care leads to healthy growth and development.",
      ctaText: "Sounds Good",
      onCtaTap: () => Get.toNamed(Routes.alreadyAdded),
    );
  }
}
