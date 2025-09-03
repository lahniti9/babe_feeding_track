import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/info_hero_view.dart';
import '../../../routes/app_routes.dart';

class Mark3DaysView extends StatelessWidget {
  const Mark3DaysView({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoHeroView(
      title: "Mark the next 3 days",
      body: "• Track feeding and sleep patterns\n• Note any changes in behavior\n• Record growth measurements\n\nThis will help us create personalized recommendations for your baby.",
      ctaText: "Next",
      onCtaTap: () => Get.toNamed(Routes.whatsOnYourSide),
    );
  }
}
