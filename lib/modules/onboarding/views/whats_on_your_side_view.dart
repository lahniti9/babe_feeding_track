import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/info_hero_view.dart';
import '../../../routes/app_routes.dart';

class WhatsOnYourSideView extends StatelessWidget {
  const WhatsOnYourSideView({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoHeroView(
      title: "What's on your side",
      body: "You have everything you need to be a great parent. Trust your instincts, lean on your support system, and remember that every baby is unique.",
      ctaText: "Next",
      onCtaTap: () => Get.toNamed(Routes.emotionalState),
    );
  }
}
