import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_multi_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class RoutineImproveView extends StatelessWidget {
  const RoutineImproveView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return QuestionMultiView(
      title: "What would you like to improve about your routine?",
      options: const [
        QuestionMultiOption(
          value: "fewer_feedings",
          title: "Fewer feedings",
        ),
        QuestionMultiOption(
          value: "more_frequent",
          title: "More frequent feedings",
        ),
        QuestionMultiOption(
          value: "better_schedule",
          title: "Better feeding schedule",
        ),
        QuestionMultiOption(
          value: "sleep_routine",
          title: "Sleep routine",
        ),
        QuestionMultiOption(
          value: "playtime",
          title: "More structured playtime",
        ),
        QuestionMultiOption(
          value: "none",
          title: "None - everything is working well",
        ),
      ],
      selectedValues: controller.getAnswer<List<String>>('routine_improve') ?? [],
      onSelectionToggled: (value) {
        final currentValues = controller.getAnswer<List<String>>('routine_improve') ?? <String>[];
        final newValues = List<String>.from(currentValues);
        
        if (newValues.contains(value)) {
          newValues.remove(value);
        } else {
          newValues.add(value);
        }
        
        controller.saveAnswer('routine_improve', newValues);
      },
      onNext: () => Get.toNamed(Routes.nightFeeds),
      requireSelection: true,
    );
  }
}
