import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_single_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class LastFellAsleepView extends StatelessWidget {
  const LastFellAsleepView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return QuestionSingleView(
      title: "Did your baby fall asleep easily last night?",
      options: const [
        QuestionOption(
          value: "yes",
          title: "Yes, fell asleep easily",
        ),
        QuestionOption(
          value: "sleeping_now",
          title: "My baby is sleeping now",
        ),
        QuestionOption(
          value: "not_sure",
          title: "I'm not sure",
        ),
        QuestionOption(
          value: "difficult",
          title: "Difficult to answer",
        ),
      ],
      selectedValue: controller.getAnswer<String>('last_fell_asleep'),
      onSelectionChanged: (value) {
        controller.saveAnswer('last_fell_asleep', value);
        Get.toNamed(Routes.mark3Days);
      },
      autoNavigate: true,
    );
  }
}
