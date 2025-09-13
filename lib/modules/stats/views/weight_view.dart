import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../widgets/chart_scaffold.dart';
import '../widgets/empty_chart.dart';
import '../controllers/weight_controller.dart';
import '../models/stats_models.dart';

class WeightView extends StatelessWidget {
  final String childId;

  const WeightView({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WeightController(childId: childId));

    return Obx(() => ChartScaffold(
          title: 'Weight',
          showLock: true, // Premium feature
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : controller.measurements.isEmpty
                  ? EmptyChart(
                      icon: Icons.monitor_weight,
                      label: 'Weight',
                    )
                  : _buildChart(controller),
          filterOptions: const ['Week', 'Month', 'Year'],
          selectedFilter: controller.selectedPeriod.value,
          onFilterChanged: controller.changePeriod,
        ));
  }

  Widget _buildChart(WeightController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SfCartesianChart(
        backgroundColor: Colors.transparent,
        plotAreaBackgroundColor: Colors.black,
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
          labelStyle: const TextStyle(color: Colors.grey),
        ),
        primaryYAxis: NumericAxis(
          title: AxisTitle(
            text: controller.useMetric.value ? 'kg' : 'lbs',
            textStyle: const TextStyle(color: Colors.grey),
          ),
          majorGridLines: MajorGridLines(
            width: 1,
            color: Colors.grey.withValues(alpha: 0.3),
          ),
          axisLine: const AxisLine(width: 0),
          labelStyle: const TextStyle(color: Colors.grey),
          labelFormat: controller.useMetric.value ? '{value} kg' : '{value} lbs',
        ),
        series: <CartesianSeries>[
          SplineSeries<Point, DateTime>(
            dataSource: controller.measurements,
            xValueMapper: (Point point, _) => point.x,
            yValueMapper: (Point point, _) => controller.useMetric.value
                ? point.y / 1000 // Convert grams to kg
                : UnitConverter.gramsToLbs(point.y.toInt()),
            color: Colors.orange,
            width: 3,
            markerSettings: const MarkerSettings(
              isVisible: true,
              color: Colors.orange,
              borderColor: Colors.white,
              borderWidth: 2,
              width: 8,
              height: 8,
            ),
          ),
        ],
        tooltipBehavior: TooltipBehavior(
          enable: true,
          color: Colors.black87,
          textStyle: const TextStyle(color: Colors.white),
          format: controller.useMetric.value 
              ? 'point.x: point.y kg'
              : 'point.x: point.y lbs',
        ),
      ),
    );
  }
}
