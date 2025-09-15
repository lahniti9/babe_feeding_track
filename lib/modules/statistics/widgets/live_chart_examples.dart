import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/weight_stats_controller.dart';
import '../controllers/feeding_stats_controller.dart';
import '../controllers/sleeping_stats_controller.dart';
import '../controllers/daily_results_controller.dart';
import '../controllers/stats_home_controller.dart';
import 'metric_line_chart.dart';
import 'feeding_stacked_chart.dart';
import 'sleep_area_chart.dart';
import 'diaper_stacked_chart.dart';
import 'daily_results_donut.dart';

/// Examples of how to integrate modern charts with existing GetX controllers
/// These widgets demonstrate live updates from your reactive data streams
class LiveChartExamples extends StatelessWidget {
  final String childId;

  const LiveChartExamples({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Charts Demo'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Weight Chart - Live from WeightStatsController
            _buildWeightChart(),
            const SizedBox(height: 24),
            
            // Feeding Chart - Live from FeedingStatsController
            _buildFeedingChart(),
            const SizedBox(height: 24),
            
            // Sleep Chart - Live from SleepingStatsController
            _buildSleepChart(),
            const SizedBox(height: 24),
            
            // Sleep Heatmap - Live hourly data
            _buildSleepHeatmap(),
            const SizedBox(height: 24),
            
            // Diaper Chart - Live from StatsHomeController
            _buildDiaperChart(),
            const SizedBox(height: 24),
            
            // Daily Results - Live from DailyResultsController
            _buildDailyResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightChart() {
    return GetBuilder<WeightStatsController>(
      init: WeightStatsController(childId: childId),
      builder: (controller) {
        return Obx(() => MetricLineChart(
          points: controller.points,
          yUnit: 'kg',
          title: 'Weight Progress',
          color: const Color(0xFF0891B2), // Cyan theme
          showLatestAnnotation: true,
        ));
      },
    );
  }

  Widget _buildFeedingChart() {
    return GetBuilder<FeedingStatsController>(
      init: FeedingStatsController(childId: childId),
      builder: (controller) {
        return Obx(() {
          // Extract data for stacked chart
          final volumeData = controller.volumePerDay;
          final days = volumeData.map((e) => e.key).toList();
          final bottleMl = volumeData.map((e) => e.value).toList();
          
          // For demo - you'd get expressing data from another source
          final expressingMl = List.generate(days.length, (i) => 
            (bottleMl.isNotEmpty && i < bottleMl.length) ? bottleMl[i] * 0.3 : 0.0);

          return FeedingStackedChart(
            days: days,
            bottleMl: bottleMl,
            expressingMl: expressingMl,
            title: 'Daily Feeding Volume',
          );
        });
      },
    );
  }

  Widget _buildSleepChart() {
    return GetBuilder<SleepingStatsController>(
      init: SleepingStatsController(childId: childId),
      builder: (controller) {
        return Obx(() => SleepAreaChart(
          minutesPerDay: controller.minutesPerDay,
          title: 'Sleep Patterns',
        ));
      },
    );
  }

  Widget _buildSleepHeatmap() {
    return GetBuilder<SleepingStatsController>(
      init: SleepingStatsController(childId: childId),
      builder: (controller) {
        return Obx(() => SleepHeatmap(
          minutesByHour: controller.minutesByHour,
          title: 'Sleep by Hour of Day',
        ));
      },
    );
  }

  Widget _buildDiaperChart() {
    return GetBuilder<StatsHomeController>(
      init: StatsHomeController(),
      builder: (controller) {
        return Obx(() {
          // For demo - you'd extract real diaper data from controller
          // This shows how to structure the data
          final days = List.generate(7, (i) => 
            DateTime.now().subtract(Duration(days: 6 - i)));
          final wetCounts = List.generate(7, (i) => 
            controller.todayWet.value + (i % 3));
          final dirtyCounts = List.generate(7, (i) => 
            controller.todayPoop.value + (i % 2));
          final mixedCounts = List.generate(7, (i) => 
            controller.todayMixed.value);

          return DiaperStackedChart(
            days: days,
            wetCounts: wetCounts,
            dirtyCounts: dirtyCounts,
            mixedCounts: mixedCounts,
            title: 'Diaper Changes',
          );
        });
      },
    );
  }

  Widget _buildDailyResults() {
    return GetBuilder<DailyResultsController>(
      init: DailyResultsController(
        childId: childId,
        day: DateTime.now(),
      ),
      builder: (controller) {
        return Obx(() {
          // Convert hourly data to total minutes
          final sleepMinutes = controller.sleep.fold(0.0, (sum, val) => sum + val);
          final feedingMinutes = controller.feed.fold(0.0, (sum, val) => sum + val);
          final activityMinutes = controller.activity.fold(0.0, (sum, val) => sum + val);

          return DailyResultsDonut(
            sleepMinutes: sleepMinutes,
            feedingMinutes: feedingMinutes,
            activityMinutes: activityMinutes,
            title: 'Today\'s Time Allocation',
            date: DateTime.now(),
          );
        });
      },
    );
  }
}

/// Example of how to create a comprehensive statistics screen with multiple charts
class ModernStatsScreen extends StatelessWidget {
  final String childId;

  const ModernStatsScreen({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareStats(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Growth metrics section
            _buildSection(
              'Growth & Development',
              [
                _buildHeightChart(),
                const SizedBox(height: 16),
                _buildWeightChart(),
              ],
            ),
            
            // Daily activities section
            _buildSection(
              'Daily Activities',
              [
                _buildFeedingChart(),
                const SizedBox(height: 16),
                _buildSleepChart(),
              ],
            ),
            
            // Analysis section
            _buildSection(
              'Analysis',
              [
                _buildDailyResults(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildHeightChart() {
    return GetBuilder<WeightStatsController>(
      init: WeightStatsController(childId: childId),
      builder: (controller) {
        return Obx(() => MetricLineChart(
          points: controller.points, // You'd use height controller here
          yUnit: 'cm',
          title: 'Height Progress',
          color: const Color(0xFF7C2D12), // Brown theme
        ));
      },
    );
  }

  Widget _buildWeightChart() {
    return GetBuilder<WeightStatsController>(
      init: WeightStatsController(childId: childId),
      builder: (controller) {
        return Obx(() => MetricLineChart(
          points: controller.points,
          yUnit: 'kg',
          title: 'Weight Progress',
          color: const Color(0xFF0891B2), // Cyan theme
        ));
      },
    );
  }

  Widget _buildFeedingChart() {
    return GetBuilder<FeedingStatsController>(
      init: FeedingStatsController(childId: childId),
      builder: (controller) {
        return Obx(() {
          final volumeData = controller.volumePerDay;
          final days = volumeData.map((e) => e.key).toList();
          final bottleMl = volumeData.map((e) => e.value).toList();
          final expressingMl = List.generate(days.length, (i) => 0.0); // Add real data

          return FeedingStackedChart(
            days: days,
            bottleMl: bottleMl,
            expressingMl: expressingMl,
            title: 'Feeding Trends',
          );
        });
      },
    );
  }

  Widget _buildSleepChart() {
    return GetBuilder<SleepingStatsController>(
      init: SleepingStatsController(childId: childId),
      builder: (controller) {
        return Obx(() => SleepAreaChart(
          minutesPerDay: controller.minutesPerDay,
          title: 'Sleep Quality',
        ));
      },
    );
  }

  Widget _buildDailyResults() {
    return GetBuilder<DailyResultsController>(
      init: DailyResultsController(childId: childId, day: DateTime.now()),
      builder: (controller) {
        return Obx(() => DailyResultsDonut(
          sleepMinutes: controller.sleep.fold(0.0, (sum, val) => sum + val),
          feedingMinutes: controller.feed.fold(0.0, (sum, val) => sum + val),
          activityMinutes: controller.activity.fold(0.0, (sum, val) => sum + val),
          title: 'Time Breakdown',
          date: DateTime.now(),
        ));
      },
    );
  }

  void _shareStats() {
    // Implement stats sharing functionality
    Get.snackbar(
      'Share Stats',
      'Stats sharing functionality would go here',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
