import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_single_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class SleepStatementView extends StatelessWidget {
  const SleepStatementView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return QuestionSingleView(
      title: "Which statement best describes your sleep beliefs?",
      options: const [
        QuestionOption(
          value: "sleep_training_works",
          title: "Sleep training works well",
        ),
        QuestionOption(
          value: "gentle_approach",
          title: "Prefer gentle approaches",
        ),
        QuestionOption(
          value: "follow_baby_lead",
          title: "Follow baby's natural rhythm",
        ),
        QuestionOption(
          value: "unsure",
          title: "Not sure what works best",
        ),
        QuestionOption(
          value: "difficult",
          title: "Difficult to answer",
        ),
      ],
      selectedValue: controller.getAnswer<String>('sleep_statement'),
      onSelectionChanged: (value) {
        controller.saveAnswer('sleep_statement', value);
        // Small delay to show selection feedback
        Future.delayed(const Duration(milliseconds: 150), () {
          Get.toNamed(Routes.appetite);
        });
      },
      autoNavigate: true,
    );
  }
}
