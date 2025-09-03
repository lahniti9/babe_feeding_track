import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/text_input_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class BabyNameView extends StatelessWidget {
  const BabyNameView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return TextInputView(
      title: "What's your baby's name?",
      value: controller.babyName,
      hint: "Enter baby's name",
      onValueChanged: (value) {
        controller.setBabyName(value);
      },
      onNext: () => Get.toNamed(Routes.babyBirthday),
    );
  }
}
