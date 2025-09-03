import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/text_input_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class ParentNameView extends StatelessWidget {
  const ParentNameView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return TextInputView(
      title: "What's your name?",
      value: controller.parentName,
      hint: "Enter your name",
      onValueChanged: (value) {
        controller.setParentName(value);
      },
      onNext: () => Get.toNamed(Routes.roleCheck),
    );
  }
}
