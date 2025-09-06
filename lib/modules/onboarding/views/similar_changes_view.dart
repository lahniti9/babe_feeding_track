import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_multi_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class SimilarChangesView extends StatelessWidget {
  const SimilarChangesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Obx(() => QuestionMultiView(
      title: "Have you noticed any of these changes recently?",
      options: const [
        QuestionMultiOption(
          value: "more_formula",
          title: "Requires more formula/milk",
        ),
        QuestionMultiOption(
          value: "restless_sleep",
          title: "More restless sleep",
        ),
        QuestionMultiOption(
          value: "irritable",
          title: "More irritable than usual",
        ),
        QuestionMultiOption(
          value: "weight_gain",
          title: "Rapid weight gain",
        ),
        QuestionMultiOption(
          value: "none",
          title: "None of these",
        ),
        QuestionMultiOption(
          value: "difficult",
          title: "Difficult to answer",
        ),
      ],
      selectedValues: controller.getAnswer<List<String>>('similar_changes') ?? [],
      onSelectionToggled: (value) {
        final currentValues = controller.getAnswer<List<String>>('similar_changes') ?? <String>[];
        final newValues = List<String>.from(currentValues);
        
        if (newValues.contains(value)) {
          newValues.remove(value);
        } else {
          newValues.add(value);
        }
        
        controller.saveAnswer('similar_changes', newValues);
      },
      onNext: () => Get.toNamed(Routes.spurtTimeline),
      requireSelection: true,
    ));
  }
}
