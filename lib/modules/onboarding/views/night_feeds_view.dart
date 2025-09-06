import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_single_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class NightFeedsView extends StatelessWidget {
  const NightFeedsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Obx(() => QuestionSingleView(
      title: "How often does your baby feed at night?",
      options: const [
        QuestionOption(
          value: "more_than_5",
          title: "More than 5 times",
        ),
        QuestionOption(
          value: "3_to_5",
          title: "3-5 times",
        ),
        QuestionOption(
          value: "1_to_2",
          title: "1-2 times",
        ),
        QuestionOption(
          value: "rarely",
          title: "Rarely or never",
        ),
        QuestionOption(
          value: "difficult",
          title: "Difficult to answer",
        ),
      ],
      selectedValue: controller.getAnswer<String>('night_feeds'),
      onSelectionChanged: (value) {
        controller.saveAnswer('night_feeds', value);
        // Small delay to show selection feedback
        Future.delayed(const Duration(milliseconds: 150), () {
          Get.toNamed(Routes.feedingType);
        });
      },
      autoNavigate: true,
    ));
  }
}
