import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_multi_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class TriedToNormalizeView extends StatelessWidget {
  const TriedToNormalizeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Obx(() => QuestionMultiView(
      title: "What have you tried to normalize sleep?",
      options: const [
        QuestionMultiOption(
          value: "bedtime_rituals",
          title: "Bedtime rituals",
        ),
        QuestionMultiOption(
          value: "sleep_environment",
          title: "Optimizing sleep environment",
        ),
        QuestionMultiOption(
          value: "sleep_training",
          title: "Sleep training methods",
        ),
        QuestionMultiOption(
          value: "pediatrician",
          title: "Consulted pediatrician",
        ),
        QuestionMultiOption(
          value: "tried_everything",
          title: "Tried everything I can think of",
        ),
        QuestionMultiOption(
          value: "difficult",
          title: "Difficult to answer",
        ),
      ],
      selectedValues: controller.getAnswer<List<String>>('tried_to_normalize') ?? [],
      onSelectionToggled: (value) {
        final currentValues = controller.getAnswer<List<String>>('tried_to_normalize') ?? <String>[];
        final newValues = List<String>.from(currentValues);
        
        if (newValues.contains(value)) {
          newValues.remove(value);
        } else {
          newValues.add(value);
        }
        
        controller.saveAnswer('tried_to_normalize', newValues);
      },
      onNext: () => Get.toNamed(Routes.needsLearnToSleep),
      requireSelection: true,
    ));
  }
}
