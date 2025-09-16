import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../children/services/children_store.dart';
import '../controllers/live_sleeping_stats_controller.dart';
import '../controllers/range_stats_controller.dart';
import '../widgets/chart_card.dart';
import '../widgets/range_chips.dart';
import '../bindings/live_stats_binding.dart';

/// Live sleeping statistics view with duration chart and hourly heatmap
class LiveSleepingChartView extends StatelessWidget {
  const LiveSleepingChartView({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      // Check if we have an active child first
      final childrenStore = Get.find<ChildrenStore>();
      final activeChildId = childrenStore.activeId.value;

      if (activeChildId == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Sleep Statistics')),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.child_care, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No Active Child',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  'Please select a child to view sleep statistics',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      }

      // Initialize controller for active child
      LiveStatsManager.initializeForActiveChild();

      final controller = Get.sleepingStats;
      if (controller == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Sleep Statistics')),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Initializing sleep statistics...'),
              ],
            ),
          ),
        );
      }

      // Return the main UI with the controller
      return _buildMainUI(controller);
    } catch (e) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sleep Statistics')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Error Loading Statistics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Error: $e',
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }
  }

  /// Build the main UI with the controller
  Widget _buildMainUI(LiveSleepingStatsController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Statistics'),
        backgroundColor: const Color(0xFF111217),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF111217),
      body: RefreshIndicator(
        onRefresh: () async => controller.refresh(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Sleep Duration Chart
              _buildSleepDurationCard(controller),

              const SizedBox(height: 24),

              // Hourly Sleep Heatmap
              _buildHourlyHeatmapCard(controller),
            ],
          ),
        ),
      ),
    );
  }

  /// Sleep duration chart card
  Widget _buildSleepDurationCard(LiveSleepingStatsController controller) {
    return Obx(() {
      return ChartCard(
        title: 'Sleep Duration',
        accentColor: const Color(0xFF6B46C1),
        kpi: controller.kpiString,
        isLoading: controller.isLoading.value,
        onRefresh: controller.refresh,
        actions: [
          RangeChips(
            selected: controller.range.value,
            onChanged: controller.setRange,
            accentColor: const Color(0xFF6B46C1),
          ),
        ],
        chart: controller.sleepDuration.isEmpty
            ? EmptyChartState(
                title: 'No Sleep Data',
                message: 'Start tracking sleep to see duration trends',
                icon: Icons.bed,
                accentColor: const Color(0xFF6B46C1),
              )
            : SizedBox(
                height: 280,
                child: SfCartesianChart(
                  backgroundColor: Colors.transparent,
                  plotAreaBorderWidth: 0,
                  margin: const EdgeInsets.all(0),
                  primaryXAxis: DateTimeAxis(
                    dateFormat: _getDateFormat(controller.range.value),
                    intervalType: _getIntervalType(controller.range.value),
                    majorGridLines: MajorGridLines(
                      width: 0.5,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    axisLine: const AxisLine(width: 0),
                    labelStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(
                      text: 'Hours',
                      textStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    majorGridLines: MajorGridLines(
                      width: 0.5,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    axisLine: const AxisLine(width: 0),
                    labelStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                    numberFormat: NumberFormat.compact(),
                  ),
                  trackballBehavior: TrackballBehavior(
                    enable: true,
                    activationMode: ActivationMode.singleTap,
                    tooltipSettings: const InteractiveTooltip(
                      enable: true,
                      color: Color(0xFF6B46C1),
                      textStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePinching: true,
                    enablePanning: true,
                    zoomMode: ZoomMode.x,
                  ),
                  series: [
                    ColumnSeries<TimeSeriesPoint, DateTime>(
                      dataSource: controller.sleepDuration,
                      xValueMapper: (point, _) => point.date,
                      yValueMapper: (point, _) => point.value,
                      color: const Color(0xFF6B46C1),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF6B46C1),
                          const Color(0xFF6B46C1).withValues(alpha: 0.6),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: false,
                      ),
                      animationDuration: 600,
                    ),
                  ],
                ),
              ),
        empty: EmptyChartState(
          title: 'No Sleep Data',
          message: 'Start tracking sleep to see duration trends',
          icon: Icons.bed,
          accentColor: const Color(0xFF6B46C1),
        ),
      );
    });
  }

  /// Hourly sleep heatmap card
  Widget _buildHourlyHeatmapCard(LiveSleepingStatsController controller) {
    return Obx(() {
      return ChartCard(
        title: 'When Baby Sleeps Most',
        accentColor: const Color(0xFF6B46C1),
        kpi: 'Peak hours: ${_getPeakHours(controller.hourlyHeatmap)}',
        isLoading: controller.isLoading.value,
        onRefresh: controller.refresh,
        actions: const [],
        chart: controller.hourlyHeatmap.isEmpty
            ? EmptyChartState(
                title: 'No Sleep Pattern Data',
                message: 'Track more sleep sessions to see hourly patterns',
                icon: Icons.access_time,
                accentColor: const Color(0xFF6B46C1),
              )
            : SizedBox(
                height: 200,
                child: _buildHourlyBarChart(controller.hourlyHeatmap),
              ),
        empty: EmptyChartState(
          title: 'No Sleep Pattern Data',
          message: 'Track more sleep sessions to see hourly patterns',
          icon: Icons.access_time,
          accentColor: const Color(0xFF6B46C1),
        ),
      );
    });
  }

  /// Build hourly bar chart
  Widget _buildHourlyBarChart(List<HourlyData> data) {
    return SfCartesianChart(
      backgroundColor: Colors.transparent,
      plotAreaBorderWidth: 0,
      margin: const EdgeInsets.all(0),
      primaryXAxis: NumericAxis(
        minimum: 0,
        maximum: 23,
        interval: 3,
        majorGridLines: MajorGridLines(
          width: 0.5,
          color: Colors.white.withValues(alpha: 0.1),
        ),
        axisLine: const AxisLine(width: 0),
        labelStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.7),
          fontSize: 10,
        ),
        labelFormat: '{value}:00',
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(
          text: 'Minutes',
          textStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        majorGridLines: MajorGridLines(
          width: 0.5,
          color: Colors.white.withValues(alpha: 0.1),
        ),
        axisLine: const AxisLine(width: 0),
        labelStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.7),
          fontSize: 10,
        ),
        numberFormat: NumberFormat.compact(),
      ),
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipSettings: const InteractiveTooltip(
          enable: true,
          color: Color(0xFF6B46C1),
          textStyle: TextStyle(color: Colors.white),
        ),
      ),
      series: [
        ColumnSeries<HourlyData, int>(
          dataSource: data,
          xValueMapper: (point, _) => point.hour,
          yValueMapper: (point, _) => point.value,
          pointColorMapper: (point, _) => _getHourColor(point.hour),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2),
            topRight: Radius.circular(2),
          ),
          dataLabelSettings: const DataLabelSettings(
            isVisible: false,
          ),
          animationDuration: 600,
        ),
      ],
    );
  }

  /// Get color for hour based on time of day
  Color _getHourColor(int hour) {
    if (hour >= 21 || hour <= 6) {
      // Night time - darker purple
      return const Color(0xFF4C1D95);
    } else if (hour >= 7 && hour <= 11) {
      // Morning - lighter purple
      return const Color(0xFF7C3AED);
    } else if (hour >= 12 && hour <= 17) {
      // Afternoon - medium purple
      return const Color(0xFF6B46C1);
    } else {
      // Evening - purple
      return const Color(0xFF5B21B6);
    }
  }

  /// Get peak sleep hours
  String _getPeakHours(List<HourlyData> data) {
    if (data.isEmpty) return 'No data';
    
    final sorted = data.toList()..sort((a, b) => b.value.compareTo(a.value));
    final top3 = sorted.take(3).where((d) => d.value > 0).toList();
    
    if (top3.isEmpty) return 'No data';
    
    return top3.map((d) => '${d.hour}:00').join(', ');
  }

  /// Get date format based on range
  DateFormat _getDateFormat(StatsRange range) {
    switch (range) {
      case StatsRange.day:
        return DateFormat.Hm();
      case StatsRange.week:
        return DateFormat.E();
      case StatsRange.month:
        return DateFormat.MMMd();
      case StatsRange.year:
        return DateFormat.MMM();
    }
  }

  /// Get interval type based on range
  DateTimeIntervalType _getIntervalType(StatsRange range) {
    switch (range) {
      case StatsRange.day:
        return DateTimeIntervalType.hours;
      case StatsRange.week:
        return DateTimeIntervalType.days;
      case StatsRange.month:
        return DateTimeIntervalType.days;
      case StatsRange.year:
        return DateTimeIntervalType.months;
    }
  }
}
