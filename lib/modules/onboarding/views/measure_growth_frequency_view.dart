import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_single_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class MeasureGrowthFrequencyView extends StatelessWidget {
  const MeasureGrowthFrequencyView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return QuestionSingleView(
      title: "How often do you measure growth?",
      options: const [
        QuestionOption(
          value: "weekly",
          title: "Weekly",
        ),
        QuestionOption(
          value: "biweekly",
          title: "Biweekly",
        ),
        QuestionOption(
          value: "monthly",
          title: "Monthly",
        ),
        QuestionOption(
          value: "doctor_visits_only",
          title: "Only during doctor visits",
        ),
        QuestionOption(
          value: "difficult",
          title: "Difficult",
        ),
      ],
      selectedValue: controller.getAnswer<String>('measure_growth_frequency'),
      onSelectionChanged: (value) {
        controller.saveAnswer('measure_growth_frequency', value);
        // Navigate immediately after selection
        Get.toNamed(Routes.timeOnSleepSchedule);
      },
      autoNavigate: true,
    );
  }
}
