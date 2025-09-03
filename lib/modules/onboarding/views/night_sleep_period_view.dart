import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/picker_time_range_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class NightSleepPeriodView extends StatelessWidget {
  const NightSleepPeriodView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return PickerTimeRangeView(
      title: "When does your baby typically sleep at night?",
      startLabel: "Falls asleep",
      endLabel: "Wakes up",
      startTime: controller.getAnswer<TimeOfDay>('sleep_start_time') ?? const TimeOfDay(hour: 21, minute: 0),
      endTime: controller.getAnswer<TimeOfDay>('sleep_end_time') ?? const TimeOfDay(hour: 6, minute: 0),
      onStartTimeChanged: (time) {
        controller.saveAnswer('sleep_start_time', time);
      },
      onEndTimeChanged: (time) {
        controller.saveAnswer('sleep_end_time', time);
      },
      showSkip: true,
      skipText: "I don't know",
      onSkip: () => Get.toNamed(Routes.lastFellAsleep),
      onNext: () => Get.toNamed(Routes.lastFellAsleep),
    );
  }
}
