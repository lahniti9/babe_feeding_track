import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_single_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class StartGoalView extends StatelessWidget {
  const StartGoalView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return QuestionSingleView(
      title: "Where do you want to start?",
      options: const [
        QuestionOption(
          value: "build_schedule",
          title: "Build schedule",
        ),
        QuestionOption(
          value: "understand_needs",
          title: "Understand needs",
        ),
        QuestionOption(
          value: "development_tips",
          title: "Get development tips",
        ),
        QuestionOption(
          value: "difficult_to_answer",
          title: "Difficult to answer",
        ),
      ],
      selectedValue: controller.getAnswer<String>('start_goal'),
      onSelectionChanged: (value) {
        controller.saveAnswer('start_goal', value);
        // Navigate immediately after selection
        Get.toNamed(Routes.feedTrackingInvolvement);
      },
      autoNavigate: true,
      showSkip: false,
    );
  }
}
