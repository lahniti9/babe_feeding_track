import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/colors.dart';
import '../../core/widgets/bc_scaffold.dart';
import '../statistics/controllers/stats_home_controller.dart';
import 'views/head_circ_view.dart';
import 'views/height_view.dart';
import 'views/weight_view.dart';
import 'views/health_diary_view.dart';
import 'views/monthly_overview_view.dart';
import 'views/feeding_view.dart';
import 'views/sleeping_view.dart';
import 'views/diapers_view.dart';
import 'views/daily_results_view.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StatsHomeController());

    return BCScaffold(
      title: "Statistics",
      showBack: false,
      body: Obx(() {
        if (!controller.hasChild.value) {
          return _buildNoChildHint();
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          itemCount: 9,
          separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.lg),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return _buildEnhancedStatsRow(
                  icon: Icons.face,
                  title: "Head circumference",
                  subtitle: "Latest measurement",
                  trailing: _arrowWidget(const Color(0xFF0891B2)),
                  onTap: () => _navigateToHeadCircumference(controller),
                  iconColor: const Color(0xFF0891B2), // Cyan - same as headCircumference events
                );
              case 1:
                return _buildEnhancedStatsRow(
                  icon: Icons.height,
                  title: "Height",
                  subtitle: "Latest measurement",
                  trailing: _arrowWidget(const Color(0xFF7C2D12)),
                  onTap: () => _navigateToHeight(controller),
                  iconColor: const Color(0xFF7C2D12), // Brown - same as height events
                );
              case 2:
                return _buildEnhancedStatsRow(
                  icon: Icons.monitor_weight,
                  title: "Weight",
                  subtitle: "Latest measurement",
                  trailing: _arrowWidget(const Color(0xFF0891B2)),
                  onTap: () => _navigateToWeight(controller),
                  iconColor: const Color(0xFF0891B2), // Cyan - same as weight events
                );
              case 3:
                return _buildEnhancedStatsRow(
                  icon: Icons.restaurant,
                  title: "Feeding",
                  subtitle: "Today's total volume",
                  trailing: _arrowWidget(const Color(0xFF059669)),
                  onTap: () => _navigateToFeeding(controller),
                  iconColor: const Color(0xFF059669), // Green - same as feeding/bottle events
                );
              case 4:
                return _buildEnhancedStatsRow(
                  icon: Icons.bed,
                  title: "Sleeping",
                  subtitle: "Today's total time",
                  trailing: _arrowWidget(const Color(0xFF6B46C1)),
                  onTap: () => _navigateToSleeping(controller),
                  iconColor: const Color(0xFF6B46C1), // Purple - same as sleeping events
                );
              case 5:
                return _buildEnhancedStatsRow(
                  icon: Icons.baby_changing_station,
                  title: "Diapers",
                  subtitle: "Today's changes",
                  trailing: _arrowWidget(const Color(0xFFDC2626)),
                  onTap: () => _navigateToDiapers(controller),
                  iconColor: const Color(0xFFDC2626), // Red - same as diaper events
                );
              case 6:
                return _buildEnhancedStatsRow(
                  icon: Icons.health_and_safety,
                  title: "Health diary",
                  subtitle: "Medications & checkups",
                  trailing: _arrowWidget(const Color(0xFF3B82F6)),
                  onTap: () => _navigateToHealthDiary(controller),
                  iconColor: const Color(0xFF3B82F6), // Blue - same as doctor events
                );
              case 7:
                return _buildEnhancedStatsRow(
                  icon: Icons.calendar_view_month,
                  title: "Monthly Overview",
                  subtitle: "Active tracking days",
                  trailing: _arrowWidget(const Color(0xFFDB2777)),
                  onTap: () => _navigateToMonthlyOverview(controller),
                  iconColor: const Color(0xFFDB2777), // Pink - same as activity events
                );
              case 8:
                return _buildEnhancedStatsRow(
                  icon: Icons.pie_chart,
                  title: "Daily Results",
                  subtitle: "Comprehensive analysis",
                  trailing: _arrowWidget(const Color(0xFFF59E0B)),
                  onTap: () => _navigateToDailyResults(controller),
                  iconColor: const Color(0xFFF59E0B), // Amber - same as condition events
                );
              default:
                return const SizedBox.shrink();
            }
          },
        );
      }),
    );
  }

  // Helper widgets
  Widget _buildNoChildHint() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.child_care,
              size: 64,
              color: Colors.white54,
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'No Child Selected',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Please add a child first or complete the onboarding process',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _arrowWidget(Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Icon(
        Icons.chevron_right,
        color: color.withValues(alpha: 0.8),
        size: 20,
      ),
    );
  }

  // Enhanced UI Components
  Widget _buildEnhancedStatsRow({
    required IconData icon,
    required String title,
    String? subtitle,
    required Widget trailing,
    required VoidCallback onTap,
    required Color iconColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
           
            boxShadow: [
              BoxShadow(
                color: iconColor.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          iconColor.withValues(alpha: 0.2),
                          iconColor.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: iconColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 26,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.7),
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              trailing,
            ],
          ),
        ),
      ),
    );
  }

  // Navigation methods
  void _navigateToHeadCircumference(StatsHomeController controller) {
    if (controller.currentChildId.value != null) {
      Get.to(() => HeadCircView(childId: controller.currentChildId.value!));
    } else {
      Get.snackbar(
        "No Child Selected",
        "Please add a child first or complete the onboarding process",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void _navigateToHeight(StatsHomeController controller) {
    if (controller.currentChildId.value != null) {
      Get.to(() => HeightView(childId: controller.currentChildId.value!));
    } else {
      Get.snackbar(
        "No Child Selected",
        "Please add a child first or complete the onboarding process",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void _navigateToWeight(StatsHomeController controller) {
    if (controller.currentChildId.value != null) {
      Get.to(() => WeightView(childId: controller.currentChildId.value!));
    } else {
      Get.snackbar(
        "No Child Selected",
        "Please add a child first or complete the onboarding process",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void _navigateToHealthDiary(StatsHomeController controller) {
    if (controller.currentChildId.value != null) {
      Get.to(() => HealthDiaryView(childId: controller.currentChildId.value!));
    } else {
      Get.snackbar("Error", "No active child selected");
    }
  }

  void _navigateToMonthlyOverview(StatsHomeController controller) {
    if (controller.currentChildId.value != null) {
      Get.to(() => MonthlyOverviewView(childId: controller.currentChildId.value!));
    } else {
      Get.snackbar("Error", "No active child selected");
    }
  }

  void _navigateToFeeding(StatsHomeController controller) {
    if (controller.currentChildId.value != null) {
      Get.to(() => FeedingView(childId: controller.currentChildId.value!));
    } else {
      Get.snackbar("Error", "No active child selected");
    }
  }

  void _navigateToSleeping(StatsHomeController controller) {
    if (controller.currentChildId.value != null) {
      Get.to(() => SleepingView(childId: controller.currentChildId.value!));
    } else {
      Get.snackbar("Error", "No active child selected");
    }
  }

  void _navigateToDiapers(StatsHomeController controller) {
    if (controller.currentChildId.value != null) {
      Get.to(() => DiapersView(childId: controller.currentChildId.value!));
    } else {
      Get.snackbar("Error", "No active child selected");
    }
  }

  void _navigateToDailyResults(StatsHomeController controller) {
    if (controller.currentChildId.value != null) {
      Get.to(() => DailyResultsView(childId: controller.currentChildId.value!));
    } else {
      Get.snackbar("Error", "No active child selected");
    }
  }
}
