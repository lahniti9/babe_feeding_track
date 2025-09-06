import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../widgets/chart_scaffold.dart';
import '../widgets/seg_filter.dart';
import '../controllers/feeding_controller.dart';
import '../models/stats_models.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';

class FeedingView extends StatelessWidget {
  final String childId;

  const FeedingView({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FeedingController(childId: childId));

    return Obx(() => ChartScaffold(
          title: 'Feeding',
          showFullReport: true,
          onFullReportTap: controller.openFullReport,
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildContent(controller),
        ));
  }

  Widget _buildContent(FeedingController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Feeding volume trends
          _buildVolumeSection(controller),
          const SizedBox(height: AppSpacing.xl),
          
          // Number of feedings
          _buildCountSection(controller),
          const SizedBox(height: AppSpacing.xl),
          
          // Breast feeding analysis
          _buildBreastFeedingSection(controller),
        ],
      ),
    );
  }

  Widget _buildVolumeSection(FeedingController controller) {
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
              Text(
                'Feeding volume trends',
                style: AppTextStyles.h4,
              ),
              SegFilter(
                options: const ['Week', 'Month'],
                selectedOption: controller.volumePeriod.value,
                onChanged: controller.changeVolumePeriod,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Volume chart
          SizedBox(
            height: 200,
            child: controller.volumeData.isEmpty
                ? const Center(
                    child: Text(
                      'No feeding volume data',
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
                        text: 'Volume (oz)',
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
                        dataSource: controller.volumeData,
                        xValueMapper: (Bar bar, _) => bar.x.toString(),
                        yValueMapper: (Bar bar, _) => bar.y,
                        color: Colors.amber,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountSection(FeedingController controller) {
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
              Text(
                'Number of feedings',
                style: AppTextStyles.h4,
              ),
              SegFilter(
                options: const ['Week', 'Month'],
                selectedOption: controller.countPeriod.value,
                onChanged: controller.changeCountPeriod,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Count chart
          SizedBox(
            height: 200,
            child: controller.countData.isEmpty
                ? const Center(
                    child: Text(
                      'No feeding count data',
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
                        dataSource: controller.countData,
                        xValueMapper: (Bar bar, _) => bar.x.toString(),
                        yValueMapper: (Bar bar, _) => bar.y,
                        color: Colors.orange,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreastFeedingSection(FeedingController controller) {
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
            'With what breast do you feed more often',
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Month',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Breast feeding chart
          SizedBox(
            height: 200,
            child: controller.breastFeedingData.isEmpty
                ? const Center(
                    child: Text(
                      'No breast feeding data',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : SfCircularChart(
                    backgroundColor: Colors.transparent,
                    legend: Legend(
                      isVisible: true,
                      position: LegendPosition.bottom,
                      textStyle: const TextStyle(color: Colors.grey),
                    ),
                    series: <CircularSeries>[
                      DoughnutSeries<Bar, String>(
                        dataSource: controller.breastFeedingData,
                        xValueMapper: (Bar bar, _) => bar.x.toString(),
                        yValueMapper: (Bar bar, _) => bar.y,
                        pointColorMapper: (Bar bar, _) {
                          return bar.x == 'Left' ? Colors.pink : Colors.purple;
                        },
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          textStyle: TextStyle(color: Colors.white),
                        ),
                        innerRadius: '60%',
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
