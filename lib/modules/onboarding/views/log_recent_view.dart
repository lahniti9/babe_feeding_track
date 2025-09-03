import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/bc_scaffold.dart';
import '../../../core/widgets/segment_header.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class LogRecentView extends StatelessWidget {
  const LogRecentView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    final eventTypes = [
      {'icon': Icons.bedtime, 'title': 'Sleeping', 'value': 'sleeping'},
      {'icon': Icons.restaurant, 'title': 'Feeding', 'value': 'feeding'},
      {'icon': Icons.local_drink, 'title': 'Bottle', 'value': 'bottle'},
      {'icon': Icons.baby_changing_station, 'title': 'Diaper', 'value': 'diaper'},
      {'icon': Icons.favorite, 'title': 'Condition', 'value': 'condition'},
      {'icon': Icons.bathtub, 'title': 'Bathing', 'value': 'bathing'},
      {'icon': Icons.directions_walk, 'title': 'Walking', 'value': 'walking'},
    ];
    
    return BCScaffold(
      showBack: true,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              child: Column(
                children: [
                  const SegmentHeader(
                    title: "Log a recent moment",
                    caption: "What was the last activity with your baby?",
                    padding: EdgeInsets.only(
                      top: AppSpacing.xxl,
                      bottom: AppSpacing.betweenSections,
                    ),
                  ),
                  ...eventTypes.map((eventType) => Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          eventType['icon'] as IconData,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      title: Text(
                        eventType['title'] as String,
                        style: AppTextStyles.bodyMedium,
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: AppColors.textSecondary,
                      ),
                      onTap: () {
                        controller.saveAnswer('recent_event_type', eventType['value']);
                        Get.toNamed(Routes.addEventTime);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                      ),
                      tileColor: AppColors.cardBackground,
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
