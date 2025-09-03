import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/picker_date_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class BabyBirthdayView extends StatelessWidget {
  const BabyBirthdayView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return PickerDateView(
      title: "When was your baby born?",
      selectedDate: controller.babyBirthday,
      maximumDate: DateTime.now(),
      onDateChanged: (date) {
        controller.setBabyBirthday(date);
      },
      onNext: () => Get.toNamed(Routes.babyGender),
    );
  }
}
