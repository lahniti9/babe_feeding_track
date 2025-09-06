import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_single_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class EmotionalStateView extends StatelessWidget {
  const EmotionalStateView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Obx(() => QuestionSingleView(
      title: "How are you feeling emotionally?",
      options: const [
        QuestionOption(
          value: "great",
          title: "Great - feeling confident",
        ),
        QuestionOption(
          value: "good",
          title: "Good - managing well",
        ),
        QuestionOption(
          value: "overwhelmed",
          title: "Overwhelmed sometimes",
        ),
        QuestionOption(
          value: "struggling",
          title: "Struggling - need support",
        ),
        QuestionOption(
          value: "difficult",
          title: "Difficult to answer",
        ),
      ],
      selectedValue: controller.getAnswer<String>('emotional_state'),
      onSelectionChanged: (value) {
        controller.saveAnswer('emotional_state', value);
        // Small delay to show selection feedback
        Future.delayed(const Duration(milliseconds: 150), () {
          Get.toNamed(Routes.emotionGrid);
        });
      },
      autoNavigate: true,
    ));
  }
}
