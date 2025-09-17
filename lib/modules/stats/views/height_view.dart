import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../widgets/chart_scaffold.dart';
import '../widgets/empty_chart.dart';
import '../controllers/height_controller.dart';
import '../models/stats_models.dart';

class HeightView extends StatelessWidget {
  final String childId;

  const HeightView({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HeightController(childId: childId));

    return Obx(() => ChartScaffold(
          title: 'Height',
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : controller.measurements.isEmpty
                  ? EmptyChart(
                      icon: Icons.height,
                      label: 'Height',
                    )
                  : _buildChart(controller),
          filterOptions: const ['Week', 'Month'],
          selectedFilter: controller.selectedPeriod.value,
          onFilterChanged: controller.changePeriod,
        ));
  }

  Widget _buildChart(HeightController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SfCartesianChart(
        backgroundColor: Colors.transparent,
        plotAreaBackgroundColor: Colors.black,
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
          labelStyle: const TextStyle(color: Colors.grey),
          minimum: _getMinimumDate(controller),
          maximum: DateTime.now(),
          intervalType: _getIntervalType(controller),
          dateFormat: _getDateFormat(controller),
        ),
        primaryYAxis: NumericAxis(
          title: AxisTitle(
            text: controller.useMetric.value ? 'cm' : 'in',
            textStyle: const TextStyle(color: Colors.grey),
          ),
          majorGridLines: MajorGridLines(
            width: 1,
            color: Colors.grey.withValues(alpha: 0.3),
          ),
          axisLine: const AxisLine(width: 0),
          labelStyle: const TextStyle(color: Colors.grey),
        ),
        series: <CartesianSeries>[
          LineSeries<Point, DateTime>(
            dataSource: controller.measurements,
            xValueMapper: (Point point, _) => point.x,
            yValueMapper: (Point point, _) => controller.useMetric.value
                ? point.y
                : UnitConverter.cmToInches(point.y),
            color: Colors.green,
            width: 2,
            markerSettings: const MarkerSettings(
              isVisible: true,
              color: Colors.green,
              borderColor: Colors.white,
              borderWidth: 2,
            ),
          ),
        ],
        tooltipBehavior: TooltipBehavior(
          enable: true,
          color: Colors.black87,
          textStyle: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  DateTime _getMinimumDate(HeightController controller) {
    switch (controller.selectedPeriod.value) {
      case 'Week':
        return DateTime.now().subtract(const Duration(days: 7));
      case 'Month':
        return DateTime.now().subtract(const Duration(days: 30));
      default:
        return DateTime.now().subtract(const Duration(days: 30));
    }
  }

  DateTimeIntervalType _getIntervalType(HeightController controller) {
    switch (controller.selectedPeriod.value) {
      case 'Week':
        return DateTimeIntervalType.days;
      case 'Month':
        return DateTimeIntervalType.days;
      default:
        return DateTimeIntervalType.days;
    }
  }

  DateFormat _getDateFormat(HeightController controller) {
    switch (controller.selectedPeriod.value) {
      case 'Week':
        return DateFormat('MMM dd');
      case 'Month':
        return DateFormat('MMM dd');
      default:
        return DateFormat('MMM dd');
    }
  }
}
