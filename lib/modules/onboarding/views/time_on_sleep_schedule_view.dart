import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_single_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class TimeOnSleepScheduleView extends StatelessWidget {
  const TimeOnSleepScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return QuestionSingleView(
      title: "How much time do you spend on sleep schedule?",
      options: const [
        QuestionOption(
          value: "a_lot",
          title: "A lot",
        ),
        QuestionOption(
          value: "often",
          title: "Often",
        ),
        QuestionOption(
          value: "sometimes",
          title: "Sometimes",
        ),
        QuestionOption(
          value: "not_interested",
          title: "Not interested",
        ),
        QuestionOption(
          value: "difficult",
          title: "Difficult",
        ),
      ],
      selectedValue: controller.getAnswer<String>('time_on_sleep_schedule'),
      onSelectionChanged: (value) {
        controller.saveAnswer('time_on_sleep_schedule', value);
        // Navigate immediately after selection
        Get.toNamed(Routes.importanceOfHealthInfo);
      },
      autoNavigate: true,
    );
  }
}
