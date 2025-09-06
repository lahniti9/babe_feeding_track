import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../widgets/chart_scaffold.dart';
import '../widgets/empty_chart.dart';
import '../controllers/diapers_controller.dart';
import '../models/stats_models.dart';

class DiapersView extends StatelessWidget {
  final String childId;

  const DiapersView({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DiapersController(childId: childId));

    return Obx(() => ChartScaffold(
          title: 'Diapers',
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : controller.diaperData.isEmpty
                  ? EmptyChart(
                      icon: Icons.baby_changing_station,
                      label: 'Diaper',
                    )
                  : _buildChart(controller),
          filterOptions: const ['Day', 'Week', 'Month'],
          selectedFilter: controller.selectedPeriod.value,
          onFilterChanged: controller.changePeriod,
        ));
  }

  Widget _buildChart(DiapersController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SfCartesianChart(
        backgroundColor: Colors.transparent,
        plotAreaBackgroundColor: Colors.black,
        title: ChartTitle(
          text: 'Wet/Dirty counts by ${controller.selectedPeriod.value}',
          textStyle: const TextStyle(color: Colors.grey),
        ),
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
          labelStyle: const TextStyle(color: Colors.grey),
        ),
        primaryYAxis: NumericAxis(
          title: AxisTitle(
            text: 'Count',
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
          ColumnSeries<Bar, String>(
            dataSource: controller.diaperData,
            xValueMapper: (Bar bar, _) => bar.x.toString(),
            yValueMapper: (Bar bar, _) => bar.y,
            color: Colors.brown,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
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
}
