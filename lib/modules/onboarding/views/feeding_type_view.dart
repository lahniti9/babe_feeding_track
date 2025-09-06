import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/selectable_cards_view.dart';
import '../../../core/theme/colors.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class FeedingTypeView extends StatelessWidget {
  const FeedingTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Obx(() => SelectableCardsView(
      title: "What type of feeding are you doing?",
      options: [
        SelectableCardOption(
          value: "mixed",
          title: "Mixed",
          subtitle: "Breast milk and formula",
          image: Icon(
            Icons.baby_changing_station,
            size: 48,
            color: AppColors.primary,
          ),
        ),
        SelectableCardOption(
          value: "formula",
          title: "Formula",
          subtitle: "Formula feeding only",
          image: Icon(
            Icons.local_drink,
            size: 48,
            color: AppColors.primary,
          ),
        ),
        SelectableCardOption(
          value: "breast",
          title: "Breast",
          subtitle: "Breastfeeding only",
          image: Icon(
            Icons.favorite,
            size: 48,
            color: AppColors.primary,
          ),
        ),
      ],
      selectedValue: controller.getAnswer<String>('feeding_type'),
      onSelectionChanged: (value) {
        controller.saveAnswer('feeding_type', value);
      },
      onNext: () => Get.toNamed(Routes.feedingRightPlace),
    ));
  }
}
