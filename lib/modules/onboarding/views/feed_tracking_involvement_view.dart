import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/question_single_view.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class FeedTrackingInvolvementView extends StatelessWidget {
  const FeedTrackingInvolvementView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return QuestionSingleView(
      title: "How involved are you in feed tracking?",
      options: const [
        QuestionOption(
          value: "very_involved",
          title: "Very involved",
        ),
        QuestionOption(
          value: "somewhat_involved",
          title: "Somewhat involved",
        ),
        QuestionOption(
          value: "not_very_involved",
          title: "Not very involved",
        ),
        QuestionOption(
          value: "difficult_to_answer",
          title: "Difficult to answer",
        ),
      ],
      selectedValue: controller.getAnswer<String>('feed_tracking_involvement'),
      onSelectionChanged: (value) {
        controller.saveAnswer('feed_tracking_involvement', value);
        // Navigate immediately after selection
        Get.toNamed(Routes.measureGrowthFrequency);
      },
      autoNavigate: true,
    );
  }
}
