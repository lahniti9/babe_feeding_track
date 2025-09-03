import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_single_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class StartFeedingKnowHowView extends StatelessWidget {
  const StartFeedingKnowHowView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return QuestionSingleView(
      title: "Do you already know how to start feeding?",
      options: const [
        QuestionOption(
          value: "yes_confident",
          title: "Yes, I'm confident",
        ),
        QuestionOption(
          value: "somewhat",
          title: "Somewhat, but need guidance",
        ),
        QuestionOption(
          value: "not_sure",
          title: "Not sure where to start",
        ),
        QuestionOption(
          value: "no_help_needed",
          title: "No, I need lots of help",
        ),
        QuestionOption(
          value: "difficult",
          title: "Difficult to answer",
        ),
      ],
      selectedValue: controller.getAnswer<String>('start_feeding_know_how'),
      onSelectionChanged: (value) {
        controller.saveAnswer('start_feeding_know_how', value);
        Get.toNamed(Routes.foodsUnderOne);
      },
      autoNavigate: true,
    );
  }
}
