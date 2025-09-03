import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/bc_scaffold.dart';
import '../../../core/widgets/segment_header.dart';
import '../../../core/widgets/emoji_grid.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/theme/spacing.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class EmotionGridView extends StatelessWidget {
  const EmotionGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return BCScaffold(
      showBack: true,
      skipText: "Skip",
      onSkip: () => Get.toNamed(Routes.selfCare),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              child: Column(
                children: [
                  const SegmentHeader(
                    title: "How are you feeling right now?",
                    padding: EdgeInsets.only(
                      top: AppSpacing.xxl,
                      bottom: AppSpacing.betweenSections,
                    ),
                  ),
                  EmojiGrid(
                    emojis: const [
                      EmojiItem(emoji: "😊", label: "Happy", value: "happy"),
                      EmojiItem(emoji: "😌", label: "Calm", value: "calm"),
                      EmojiItem(emoji: "😴", label: "Tired", value: "tired"),
                      EmojiItem(emoji: "😅", label: "Stressed", value: "stressed"),
                      EmojiItem(emoji: "😰", label: "Anxious", value: "anxious"),
                      EmojiItem(emoji: "😢", label: "Sad", value: "sad"),
                      EmojiItem(emoji: "😤", label: "Frustrated", value: "frustrated"),
                      EmojiItem(emoji: "🤗", label: "Loving", value: "loving"),
                      EmojiItem(emoji: "🥱", label: "Sleepy", value: "sleepy"),
                      EmojiItem(emoji: "😵", label: "Overwhelmed", value: "overwhelmed"),
                      EmojiItem(emoji: "🤯", label: "Mind blown", value: "mind_blown"),
                      EmojiItem(emoji: "❤️", label: "Love", value: "love"),
                    ],
                    selectedValue: controller.getAnswer<String>('emotion_grid'),
                    onSelectionChanged: (value) {
                      controller.saveAnswer('emotion_grid', value);
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: PrimaryButton(
              label: "Next",
              onTap: () => Get.toNamed(Routes.selfCare),
            ),
          ),
        ],
      ),
    );
  }
}
