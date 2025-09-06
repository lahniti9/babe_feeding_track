import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/bc_scaffold.dart';
import 'controllers/stats_home_controller.dart';
import 'widgets/stats_row.dart';
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
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          // Statistics rows
          StatsRow(
            icon: Icons.face,
            title: "Head circumference",
            onTap: () => _navigateToHeadCircumference(controller),
            iconColor: Colors.blue,
          ),
          StatsRow(
            icon: Icons.height,
            title: "Height",
            onTap: () => _navigateToHeight(controller),
            iconColor: Colors.green,
          ),
          StatsRow(
            icon: Icons.monitor_weight,
            title: "Weight",
            onTap: () => _navigateToWeight(controller),
            iconColor: Colors.orange,
          ),
          StatsRow(
            icon: Icons.health_and_safety,
            title: "Health diary",
            onTap: () => _navigateToHealthDiary(controller),
            iconColor: Colors.red,
          ),
          StatsRow(
            icon: Icons.calendar_view_month,
            title: "Monthly Overview",
            onTap: () => _navigateToMonthlyOverview(controller),
            iconColor: Colors.purple,
          ),
          StatsRow(
            icon: Icons.restaurant,
            title: "Feeding",
            onTap: () => _navigateToFeeding(controller),
            iconColor: Colors.amber,
          ),
          StatsRow(
            icon: Icons.bed,
            title: "Sleeping",
            onTap: () => _navigateToSleeping(controller),
            iconColor: Colors.indigo,
          ),
          StatsRow(
            icon: Icons.baby_changing_station,
            title: "Diapers",
            onTap: () => _navigateToDiapers(controller),
            iconColor: Colors.brown,
          ),
          StatsRow(
            icon: Icons.pie_chart,
            title: "Daily Results",
            onTap: () => _navigateToDailyResults(controller),
            iconColor: Colors.teal,
          ),
        ],
      ),
    );
  }

  // Navigation methods
  void _navigateToHeadCircumference(StatsHomeController controller) {
    if (controller.currentChildId != null) {
      Get.to(() => HeadCircView(childId: controller.currentChildId!));
    } else {
      Get.snackbar("Error", "No active child selected");
    }
  }

  void _navigateToHeight(StatsHomeController controller) {
    if (controller.currentChildId != null) {
      Get.to(() => HeightView(childId: controller.currentChildId!));
    } else {
      Get.snackbar("Error", "No active child selected");
    }
  }

  void _navigateToWeight(StatsHomeController controller) {
    if (controller.currentChildId != null) {
      Get.to(() => WeightView(childId: controller.currentChildId!));
    } else {
      Get.snackbar("Error", "No active child selected");
    }
  }

  void _navigateToHealthDiary(StatsHomeController controller) {
    if (controller.currentChildId != null) {
      Get.to(() => HealthDiaryView(childId: controller.currentChildId!));
    } else {
      Get.snackbar("Error", "No active child selected");
    }
  }

  void _navigateToMonthlyOverview(StatsHomeController controller) {
    if (controller.currentChildId != null) {
      Get.to(() => MonthlyOverviewView(childId: controller.currentChildId!));
    } else {
      Get.snackbar("Error", "No active child selected");
    }
  }

  void _navigateToFeeding(StatsHomeController controller) {
    if (controller.currentChildId != null) {
      Get.to(() => FeedingView(childId: controller.currentChildId!));
    } else {
      Get.snackbar("Error", "No active child selected");
    }
  }

  void _navigateToSleeping(StatsHomeController controller) {
    if (controller.currentChildId != null) {
      Get.to(() => SleepingView(childId: controller.currentChildId!));
    } else {
      Get.snackbar("Error", "No active child selected");
    }
  }

  void _navigateToDiapers(StatsHomeController controller) {
    if (controller.currentChildId != null) {
      Get.to(() => DiapersView(childId: controller.currentChildId!));
    } else {
      Get.snackbar("Error", "No active child selected");
    }
  }

  void _navigateToDailyResults(StatsHomeController controller) {
    if (controller.currentChildId != null) {
      Get.to(() => DailyResultsView(childId: controller.currentChildId!));
    } else {
      Get.snackbar("Error", "No active child selected");
    }
  }
}
