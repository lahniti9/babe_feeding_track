import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';

/// Modern stacked column chart for feeding data
/// Shows bottle vs expressing volumes with legend and tooltips
class FeedingStackedChart extends StatelessWidget {
  final List<DateTime> days;
  final List<double> bottleMl;
  final List<double> expressingMl;
  final String title;

  const FeedingStackedChart({
    super.key,
    required this.days,
    required this.bottleMl,
    required this.expressingMl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return _buildEmptyState();
    }

    final data = List.generate(
      days.length,
      (i) => FeedingData(
        date: days[i],
        bottle: i < bottleMl.length ? bottleMl[i] : 0.0,
        expressing: i < expressingMl.length ? expressingMl[i] : 0.0,
      ),
    );

    return Container(
      height: 320,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: const Color(0xFF059669).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart title
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Chart
          Expanded(
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              backgroundColor: Colors.transparent,
              margin: const EdgeInsets.all(0),
              
              // X-axis (DateTime)
              primaryXAxis: DateTimeAxis(
                intervalType: DateTimeIntervalType.days,
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                labelStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
              
              // Y-axis (Volume in ml)
              primaryYAxis: NumericAxis(
                labelFormat: '{value} ml',
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                majorGridLines: MajorGridLines(
                  width: 1,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                labelStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
              
              // Legend
              legend: const Legend(
                isVisible: true,
                position: LegendPosition.top,
                alignment: ChartAlignment.center,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                itemPadding: 16,
              ),
              
              // Tooltip
              tooltipBehavior: TooltipBehavior(
                enable: true,
                color: AppColors.cardBackgroundSecondary,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                borderColor: const Color(0xFF059669),
                borderWidth: 1,
              ),
              
              // Data series
              series: <StackedColumnSeries<FeedingData, DateTime>>[
                StackedColumnSeries<FeedingData, DateTime>(
                  name: 'Bottle',
                  dataSource: data,
                  xValueMapper: (data, _) => data.date,
                  yValueMapper: (data, _) => data.bottle,
                  color: const Color(0xFF059669), // Green for bottle
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  animationDuration: 1000,
                ),
                StackedColumnSeries<FeedingData, DateTime>(
                  name: 'Expressing',
                  dataSource: data,
                  xValueMapper: (data, _) => data.date,
                  yValueMapper: (data, _) => data.expressing,
                  color: const Color(0xFF8B5CF6), // Purple for expressing
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  animationDuration: 1000,
                ),
              ],
            ),
          ),
          
          // Summary stats
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(
                  'Total Bottle',
                  '${bottleMl.fold(0.0, (sum, val) => sum + val).toStringAsFixed(0)} ml',
                  const Color(0xFF059669),
                ),
                _buildStat(
                  'Total Expressing',
                  '${expressingMl.fold(0.0, (sum, val) => sum + val).toStringAsFixed(0)} ml',
                  const Color(0xFF8B5CF6),
                ),
                _buildStat(
                  'Daily Average',
                  '${((bottleMl.fold(0.0, (sum, val) => sum + val) + expressingMl.fold(0.0, (sum, val) => sum + val)) / (days.isNotEmpty ? days.length : 1)).toStringAsFixed(0)} ml',
                  Colors.white.withValues(alpha: 0.8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 320,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: const Color(0xFF059669).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant,
              size: 48,
              color: const Color(0xFF059669).withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No feeding data yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Start tracking feeds to see your chart',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data model for feeding chart
class FeedingData {
  final DateTime date;
  final double bottle;
  final double expressing;

  FeedingData({
    required this.date,
    required this.bottle,
    required this.expressing,
  });
}
