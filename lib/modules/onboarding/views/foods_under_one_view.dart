import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_single_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class FoodsUnderOneView extends StatelessWidget {
  const FoodsUnderOneView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return QuestionSingleView(
      title: "Do you know which foods not to give babies under 1 year?",
      options: const [
        QuestionOption(
          value: "yes_know_well",
          title: "Yes, I know them well",
        ),
        QuestionOption(
          value: "know_some",
          title: "I know some of them",
        ),
        QuestionOption(
          value: "heard_about",
          title: "I've heard about it",
        ),
        QuestionOption(
          value: "no_idea",
          title: "No, I have no idea",
        ),
        QuestionOption(
          value: "difficult",
          title: "Difficult to answer",
        ),
      ],
      selectedValue: controller.getAnswer<String>('foods_under_one'),
      onSelectionChanged: (value) {
        controller.saveAnswer('foods_under_one', value);
        Get.toNamed(Routes.introFoodSoon);
      },
      autoNavigate: true,
    );
  }
}
