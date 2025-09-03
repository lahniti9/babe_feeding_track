import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_single_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';
import '../../../data/models/teammate.dart';

class RoleCheckView extends StatelessWidget {
  const RoleCheckView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return QuestionSingleView(
      title: "Are you the baby's mom?",
      options: const [
        QuestionOption(
          value: "yes",
          title: "Yes",
        ),
        QuestionOption(
          value: "family_member",
          title: "I'm family member or babysitter",
        ),
      ],
      selectedValue: controller.getAnswer<String>('role_check'),
      onSelectionChanged: (value) {
        controller.saveAnswer('role_check', value);
        // Set the parent role based on selection
        if (value == "yes") {
          controller.setParentRole(TeammateRole.mother);
        } else {
          controller.setParentRole(TeammateRole.familyMember);
        }
        // Navigate immediately after selection
        Get.toNamed(Routes.welcomeName);
      },
      autoNavigate: true,
    );
  }
}
