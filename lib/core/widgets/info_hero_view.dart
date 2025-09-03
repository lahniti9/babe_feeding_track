import 'package:flutter/material.dart';
import 'bc_scaffold.dart';
import 'info_hero.dart';

class InfoHeroView extends StatelessWidget {
  final Widget? image;
  final String? imageAsset;
  final String title;
  final String? body;
  final String ctaText;
  final VoidCallback? onCtaTap;
  final bool autoAdvance;
  final Duration autoAdvanceDelay;
  final bool showBack;

  const InfoHeroView({
    super.key,
    this.image,
    this.imageAsset,
    required this.title,
    this.body,
    this.ctaText = "Next",
    this.onCtaTap,
    this.autoAdvance = false,
    this.autoAdvanceDelay = const Duration(seconds: 3),
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return BCScaffold(
      showBack: showBack,
      body: InfoHero(
        image: image,
        imageAsset: imageAsset,
        title: title,
        body: body,
        ctaText: ctaText,
        onCtaTap: onCtaTap,
        autoAdvance: autoAdvance,
        autoAdvanceDelay: autoAdvanceDelay,
      ),
    );
  }
}
