import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_multi_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class SleepIssuesView extends StatelessWidget {
  const SleepIssuesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return QuestionMultiView(
      title: "What sleep challenges are you experiencing?",
      options: const [
        QuestionMultiOption(
          value: "little_sleep",
          title: "Little to no sleep",
        ),
        QuestionMultiOption(
          value: "frequent_waking",
          title: "Frequent night waking",
        ),
        QuestionMultiOption(
          value: "trouble_falling_asleep",
          title: "Trouble falling asleep",
        ),
        QuestionMultiOption(
          value: "short_naps",
          title: "Very short naps",
        ),
        QuestionMultiOption(
          value: "irregular_schedule",
          title: "Irregular sleep schedule",
        ),
        QuestionMultiOption(
          value: "no_issues",
          title: "No issues - sleeping well",
        ),
        QuestionMultiOption(
          value: "difficult",
          title: "Difficult to answer",
        ),
      ],
      selectedValues: controller.getAnswer<List<String>>('sleep_issues') ?? [],
      onSelectionToggled: (value) {
        final currentValues = controller.getAnswer<List<String>>('sleep_issues') ?? <String>[];
        final newValues = List<String>.from(currentValues);
        
        if (newValues.contains(value)) {
          newValues.remove(value);
        } else {
          newValues.add(value);
        }
        
        controller.saveAnswer('sleep_issues', newValues);
      },
      onNext: () => Get.toNamed(Routes.napsPerDay),
      requireSelection: true,
    );
  }
}
