import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../widgets/chart_scaffold.dart';
import '../widgets/seg_filter.dart';
import '../controllers/sleeping_controller.dart';
import '../models/stats_models.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';

class SleepingView extends StatelessWidget {
  final String childId;

  const SleepingView({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SleepingController(childId: childId));

    return Obx(() => ChartScaffold(
          title: 'Sleeping',
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildContent(controller),
        ));
  }

  Widget _buildContent(SleepingController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sleep duration trends
          _buildDurationSection(controller),
          const SizedBox(height: AppSpacing.xl),
          
          // When baby sleeps the most
          _buildHourlySection(controller),
        ],
      ),
    );
  }

  Widget _buildDurationSection(SleepingController controller) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Sleep Duration',
                  style: AppTextStyles.h4,
                ),
              ),
              SegFilter(
                options: const ['Day', 'Month', 'Year'],
                selectedOption: controller.durationPeriod.value,
                onChanged: controller.changeDurationPeriod,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Duration chart
          SizedBox(
            height: 200,
            child: controller.durationData.isEmpty
                ? const Center(
                    child: Text(
                      'No sleep duration data',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : SfCartesianChart(
                    backgroundColor: Colors.transparent,
                    plotAreaBackgroundColor: Colors.black,
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      axisLine: const AxisLine(width: 0),
                      labelStyle: const TextStyle(color: Colors.grey),
                    ),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(
                        text: 'Hours',
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
                        dataSource: controller.durationData,
                        xValueMapper: (Bar bar, _) => bar.x.toString(),
                        yValueMapper: (Bar bar, _) => bar.y,
                        color: Colors.purple,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
          ),
          
          // Note about night sleep
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.xs),
            ),
            child: Text(
              'Night sleep from 21:00 to 09:00 is counted on the next day',
              style: AppTextStyles.caption.copyWith(
                color: Colors.purple,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlySection(SleepingController controller) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'When my baby sleeps the most',
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Hourly histogram
          SizedBox(
            height: 200,
            child: controller.hourlyData.isEmpty
                ? const Center(
                    child: Text(
                      'No hourly sleep data',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : SfCartesianChart(
                    backgroundColor: Colors.transparent,
                    plotAreaBackgroundColor: Colors.black,
                    primaryXAxis: NumericAxis(
                      minimum: 0,
                      maximum: 23,
                      interval: 3,
                      majorGridLines: const MajorGridLines(width: 0),
                      axisLine: const AxisLine(width: 0),
                      labelStyle: const TextStyle(color: Colors.grey),
                      title: AxisTitle(
                        text: 'Hour of day',
                        textStyle: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(
                        text: 'Hours slept',
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
                      ColumnSeries<Bar, double>(
                        dataSource: controller.hourlyData,
                        xValueMapper: (Bar bar, _) => bar.x as double,
                        yValueMapper: (Bar bar, _) => bar.y,
                        color: Colors.indigo,
                        spacing: 0.1,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(2),
                          topRight: Radius.circular(2),
                        ),
                      ),
                    ],
                  ),
          ),
          
          // Period filter for hourly data
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: SegFilter(
              options: const ['Day', 'Month', 'Year'],
              selectedOption: controller.hourlyPeriod.value,
              onChanged: controller.changeHourlyPeriod,
            ),
          ),
        ],
      ),
    );
  }
}
