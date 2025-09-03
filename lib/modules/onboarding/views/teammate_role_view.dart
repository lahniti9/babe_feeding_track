import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_single_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';
import '../../../data/models/teammate.dart';

class TeammateRoleView extends StatelessWidget {
  const TeammateRoleView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return QuestionSingleView(
      title: "What's their role?",
      options: const [
        QuestionOption(
          value: "co_parent",
          title: "Co-parent/caregiver",
        ),
        QuestionOption(
          value: "other",
          title: "Other",
        ),
      ],
      selectedValue: controller.getAnswer<String>('teammate_role'),
      onSelectionChanged: (value) {
        controller.saveAnswer('teammate_role', value);
        // Set the teammate role based on selection
        if (value == "co_parent") {
          controller.setTeammateRole(TeammateRole.coParent);
        } else {
          controller.setTeammateRole(TeammateRole.other);
        }
        // Navigate to team ready screen
        Get.toNamed(Routes.teamReady);
      },
      autoNavigate: true,
    );
  }

}
