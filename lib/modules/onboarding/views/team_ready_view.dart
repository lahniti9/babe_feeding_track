import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/info_hero_view.dart';
import '../../../routes/app_routes.dart';

class TeamReadyView extends StatelessWidget {
  const TeamReadyView({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoHeroView(
      title: "What. A. Team!",
      body: "Your care team is all set up! Now everyone can stay connected and work together to give your baby the best care possible.",
      ctaText: "Let's Care Together",
      onCtaTap: () => Get.toNamed(Routes.routineImprove),
    );
  }
}
