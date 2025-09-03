import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_single_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class NapsPerDayView extends StatelessWidget {
  const NapsPerDayView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return QuestionSingleView(
      title: "How many naps does your baby take per day?",
      caption: "Let's understand your baby's current sleep pattern",
      options: const [
        QuestionOption(
          value: "more_than_12",
          title: "More than 12",
        ),
        QuestionOption(
          value: "8_to_12",
          title: "8-12 naps",
        ),
        QuestionOption(
          value: "4_to_7",
          title: "4-7 naps",
        ),
        QuestionOption(
          value: "2_to_3",
          title: "2-3 naps",
        ),
        QuestionOption(
          value: "1_or_less",
          title: "1 or less",
        ),
        QuestionOption(
          value: "difficult",
          title: "Difficult to answer",
        ),
      ],
      selectedValue: controller.getAnswer<String>('naps_per_day'),
      onSelectionChanged: (value) {
        controller.saveAnswer('naps_per_day', value);
        Get.toNamed(Routes.nightSleepPeriod);
      },
      autoNavigate: true,
    );
  }
}
