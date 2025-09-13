import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/info_hero_view.dart';
import '../../../routes/app_routes.dart';

class YouCanDoItView extends StatelessWidget {
  const YouCanDoItView({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoHeroView(
      title: "You can do it! ❤️",
      body: "You have everything you need to be an amazing parent. Trust yourself, be patient, and remember that every baby is unique. We're here to support you every step of the way.",
      ctaText: "Continue",
      onCtaTap: () => Get.toNamed(Routes.setup18),
      showBack: false,
    );
  }
}
