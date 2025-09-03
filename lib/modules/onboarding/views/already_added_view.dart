import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/info_hero_view.dart';
import '../../../routes/app_routes.dart';

class AlreadyAddedView extends StatelessWidget {
  const AlreadyAddedView({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoHeroView(
      title: "Already added to your timeline!",
      body: "Great! Your first event has been recorded and added to your baby's timeline. You can view all activities in the Events tab and track patterns over time.",
      ctaText: "Got it!",
      onCtaTap: () => Get.toNamed(Routes.streak),
    );
  }
}
