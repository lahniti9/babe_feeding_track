import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_multi_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class LearnAboutDevView extends StatelessWidget {
  const LearnAboutDevView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return QuestionMultiView(
      title: "What would you like to learn about child development?",
      options: const [
        QuestionMultiOption(
          value: "main_stages",
          title: "Main developmental stages",
        ),
        QuestionMultiOption(
          value: "skills",
          title: "Motor and cognitive skills",
        ),
        QuestionMultiOption(
          value: "height_weight",
          title: "Normal height and weight ranges",
        ),
        QuestionMultiOption(
          value: "massage",
          title: "How to massage your baby",
        ),
        QuestionMultiOption(
          value: "playing",
          title: "Playing with your baby",
        ),
        QuestionMultiOption(
          value: "help_development",
          title: "How to help development",
        ),
        QuestionMultiOption(
          value: "none",
          title: "None of these",
        ),
      ],
      selectedValues: controller.getAnswer<List<String>>('learn_about_dev') ?? [],
      onSelectionToggled: (value) {
        final currentValues = controller.getAnswer<List<String>>('learn_about_dev') ?? <String>[];
        final newValues = List<String>.from(currentValues);
        
        if (newValues.contains(value)) {
          newValues.remove(value);
        } else {
          newValues.add(value);
        }
        
        controller.saveAnswer('learn_about_dev', newValues);
      },
      onNext: () => Get.toNamed(Routes.spurtIntro),
      requireSelection: true,
    );
  }
}
