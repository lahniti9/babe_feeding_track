import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/bc_scaffold.dart';
import '../statistics/controllers/stats_home_controller.dart';
import '../statistics/views/live_sleeping_chart_view.dart';
import '../paywall/widgets/premium_gate.dart';
import 'views/height_view.dart';
import 'views/weight_view.dart';
import 'views/monthly_overview_view.dart';
import 'views/feeding_view.dart';
import 'views/diapers_view.dart';

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
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            children: [
              // Growth Metrics Section
              _buildSectionHeader('Growth & Development'),
              const SizedBox(height: AppSpacing.md),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildHeightTile(controller),
                  _buildWeightTile(controller),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              // Daily Activities Section
              _buildSectionHeader('Daily Activities'),
              const SizedBox(height: AppSpacing.md),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildFeedingTile(controller),
                  _buildSleepingTile(controller),
                  _buildDiapersTile(controller),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              // Analysis Section
              _buildSectionHeader('Analysis'),
              const SizedBox(height: AppSpacing.md),
              _buildMonthlyOverviewTile(controller),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        );
      }),
    );
  }

  // Section header
  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // Compact statistics tiles
  Widget _buildCompactStatsTile({
    required String title,
    required String value,
    String? unit,
    required String subtitle,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF111217),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 16,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.trending_up,
                    color: color.withValues(alpha: 0.6),
                    size: 14,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Value
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  if (unit != null) ...[
                    const SizedBox(width: 2),
                    Text(
                      unit,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: color.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),

              // Subtitle
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeightTile(StatsHomeController controller) {
    return PremiumTile(
      featureName: 'Height Tracking',
      onTap: () => _navigateToHeight(controller),
      child: _buildCompactStatsTile(
        title: 'Height',
        value: controller.lastHeightCm.value?.toStringAsFixed(1) ?? '--',
        unit: 'cm',
        subtitle: 'Latest measurement',
        color: const Color(0xFF7C2D12),
        icon: Icons.height,
        onTap: () => _navigateToHeight(controller),
      ),
    );
  }

  Widget _buildWeightTile(StatsHomeController controller) {
    return PremiumTile(
      featureName: 'Weight Tracking',
      onTap: () => _navigateToWeight(controller),
      child: _buildCompactStatsTile(
        title: 'Weight',
        value: controller.lastWeightKg.value?.toStringAsFixed(1) ?? '--',
        unit: 'kg',
        subtitle: 'Latest measurement',
        color: const Color(0xFF0891B2),
        icon: Icons.monitor_weight,
        onTap: () => _navigateToWeight(controller),
      ),
    );
  }

  Widget _buildFeedingTile(StatsHomeController controller) {
    return _buildCompactStatsTile(
      title: 'Feeding',
      value: '${controller.todayFeedVolumeMl.value.toInt()}',
      unit: 'ml',
      subtitle: 'Today\'s volume',
      color: const Color(0xFF059669),
      icon: Icons.restaurant,
      onTap: () => _navigateToFeeding(controller),
    );
  }

  Widget _buildSleepingTile(StatsHomeController controller) {
    final hours = controller.todaySleepMinutes.value / 60;
    return _buildCompactStatsTile(
      title: 'Sleeping',
      value: hours.toStringAsFixed(1),
      unit: 'h',
      subtitle: 'Today\'s total',
      color: const Color(0xFF6B46C1),
      icon: Icons.bed,
      onTap: () => _navigateToSleeping(controller),
    );
  }

  Widget _buildDiapersTile(StatsHomeController controller) {
    final total = controller.todayWet.value + controller.todayPoop.value + controller.todayMixed.value;
    return _buildCompactStatsTile(
      title: 'Diapers',
      value: '$total',
      subtitle: 'Today\'s changes',
      color: const Color(0xFFDC2626),
      icon: Icons.baby_changing_station,
      onTap: () => _navigateToDiapers(controller),
    );
  }

  Widget _buildMonthlyOverviewTile(StatsHomeController controller) {
    return PremiumTile(
      featureName: 'Monthly Analytics',
      onTap: () => _navigateToMonthlyOverview(controller),
      child: SizedBox(
        width: double.infinity,
        child: _buildCompactStatsTile(
          title: 'Monthly Overview',
          value: '${controller.monthlyActiveDays.value}',
          unit: 'days',
          subtitle: 'Active tracking',
          color: const Color(0xFFDB2777),
          icon: Icons.calendar_view_month,
          onTap: () => _navigateToMonthlyOverview(controller),
        ),
      ),
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





  // Navigation methods
  void _navigateToHeight(StatsHomeController controller) {
    if (controller.currentChildId.value != null) {
      requirePremium(
        () => Get.to(() => HeightView(childId: controller.currentChildId.value!)),
        feature: 'Height Tracking',
      );
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
      requirePremium(
        () => Get.to(() => WeightView(childId: controller.currentChildId.value!)),
        feature: 'Weight Tracking',
      );
    } else {
      Get.snackbar(
        "No Child Selected",
        "Please add a child first or complete the onboarding process",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void _navigateToMonthlyOverview(StatsHomeController controller) {
    if (controller.currentChildId.value != null) {
      requirePremium(
        () => Get.to(() => MonthlyOverviewView(childId: controller.currentChildId.value!)),
        feature: 'Monthly Analytics',
      );
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
      Get.to(() => const LiveSleepingChartView());
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

}
