import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_single_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class AppetiteView extends StatelessWidget {
  const AppetiteView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return QuestionSingleView(
      title: "How is your appetite lately?",
      options: const [
        QuestionOption(
          value: "excellent",
          title: "Excellent - eating well",
        ),
        QuestionOption(
          value: "good",
          title: "Good - normal appetite",
        ),
        QuestionOption(
          value: "fair",
          title: "Fair - sometimes skip meals",
        ),
        QuestionOption(
          value: "poor",
          title: "Poor - little appetite",
        ),
        QuestionOption(
          value: "stress_eating",
          title: "Stress eating more than usual",
        ),
        QuestionOption(
          value: "difficult",
          title: "Difficult to answer",
        ),
      ],
      selectedValue: controller.getAnswer<String>('appetite'),
      onSelectionChanged: (value) {
        controller.saveAnswer('appetite', value);
        Get.toNamed(Routes.triedToNormalize);
      },
      autoNavigate: true,
    );
  }
}
