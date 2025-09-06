import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_multi_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class SelfCareView extends StatelessWidget {
  const SelfCareView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Obx(() => QuestionMultiView(
      title: "How do you take care of yourself?",
      options: const [
        QuestionMultiOption(
          value: "exercise",
          title: "Regular exercise",
        ),
        QuestionMultiOption(
          value: "healthy_eating",
          title: "Healthy eating",
        ),
        QuestionMultiOption(
          value: "enough_sleep",
          title: "Getting enough sleep",
        ),
        QuestionMultiOption(
          value: "social_time",
          title: "Time with friends/family",
        ),
        QuestionMultiOption(
          value: "hobbies",
          title: "Pursuing hobbies",
        ),
        QuestionMultiOption(
          value: "difficult",
          title: "Difficult to answer",
        ),
      ],
      selectedValues: controller.getAnswer<List<String>>('self_care') ?? [],
      onSelectionToggled: (value) {
        final currentValues = controller.getAnswer<List<String>>('self_care') ?? <String>[];
        final newValues = List<String>.from(currentValues);
        
        if (newValues.contains(value)) {
          newValues.remove(value);
        } else {
          newValues.add(value);
        }
        
        controller.saveAnswer('self_care', newValues);
      },
      onNext: () => Get.toNamed(Routes.sleepStatement),
      requireSelection: true,
    ));
  }
}
