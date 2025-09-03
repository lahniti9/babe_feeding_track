import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_single_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class ImportanceOfHealthInfoView extends StatelessWidget {
  const ImportanceOfHealthInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return QuestionSingleView(
      title: "How important is health information to you?",
      options: const [
        QuestionOption(
          value: "very_important",
          title: "Very important",
        ),
        QuestionOption(
          value: "important",
          title: "Important",
        ),
        QuestionOption(
          value: "somewhat_important",
          title: "Somewhat important",
        ),
        QuestionOption(
          value: "not_important",
          title: "Not important",
        ),
        QuestionOption(
          value: "difficult",
          title: "Difficult",
        ),
      ],
      selectedValue: controller.getAnswer<String>('importance_of_health_info'),
      onSelectionChanged: (value) {
        controller.saveAnswer('importance_of_health_info', value);
        // Navigate immediately after selection
        Get.toNamed(Routes.attitudeToAttachment);
      },
      autoNavigate: true,
    );
  }
}
