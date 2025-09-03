import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_single_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class AttitudeToAttachmentView extends StatelessWidget {
  const AttitudeToAttachmentView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return QuestionSingleView(
      title: "What's your attitude to attachment?",
      options: const [
        QuestionOption(
          value: "very_positive",
          title: "Very positive",
        ),
        QuestionOption(
          value: "positive",
          title: "Positive",
        ),
        QuestionOption(
          value: "neutral",
          title: "Neutral",
        ),
        QuestionOption(
          value: "difficult",
          title: "Difficult to answer",
        ),
      ],
      selectedValue: controller.getAnswer<String>('attitude_to_attachment'),
      onSelectionChanged: (value) {
        controller.saveAnswer('attitude_to_attachment', value);
        // Navigate immediately after selection
        Get.toNamed(Routes.teamIntro);
      },
      autoNavigate: true,
    );
  }
}
