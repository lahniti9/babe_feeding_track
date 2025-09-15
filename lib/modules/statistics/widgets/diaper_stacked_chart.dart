import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';

/// Modern stacked column chart for diaper changes
/// Shows wet/dirty/mixed counts with color coding
class DiaperStackedChart extends StatelessWidget {
  final List<DateTime> days;
  final List<int> wetCounts;
  final List<int> dirtyCounts;
  final List<int> mixedCounts;
  final String title;

  const DiaperStackedChart({
    super.key,
    required this.days,
    required this.wetCounts,
    required this.dirtyCounts,
    required this.mixedCounts,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return _buildEmptyState();
    }

    final data = List.generate(
      days.length,
      (i) => DiaperData(
        date: days[i],
        wet: i < wetCounts.length ? wetCounts[i] : 0,
        dirty: i < dirtyCounts.length ? dirtyCounts[i] : 0,
        mixed: i < mixedCounts.length ? mixedCounts[i] : 0,
      ),
    );

    return Container(
      height: 320,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: const Color(0xFFDC2626).withValues(alpha: 0.2),
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
              
              // Y-axis (Count)
              primaryYAxis: NumericAxis(
                labelFormat: '{value}',
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
                borderColor: const Color(0xFFDC2626),
                borderWidth: 1,
              ),
              
              // Data series
              series: <StackedColumnSeries<DiaperData, DateTime>>[
                StackedColumnSeries<DiaperData, DateTime>(
                  name: 'Wet',
                  dataSource: data,
                  xValueMapper: (data, _) => data.date,
                  yValueMapper: (data, _) => data.wet,
                  color: const Color(0xFF3B82F6), // Blue for wet
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  animationDuration: 1000,
                ),
                StackedColumnSeries<DiaperData, DateTime>(
                  name: 'Dirty',
                  dataSource: data,
                  xValueMapper: (data, _) => data.date,
                  yValueMapper: (data, _) => data.dirty,
                  color: const Color(0xFF92400E), // Brown for dirty
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  animationDuration: 1000,
                ),
                StackedColumnSeries<DiaperData, DateTime>(
                  name: 'Mixed',
                  dataSource: data,
                  xValueMapper: (data, _) => data.date,
                  yValueMapper: (data, _) => data.mixed,
                  color: const Color(0xFFDC2626), // Red for mixed
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
                  'Total Wet',
                  wetCounts.fold(0, (sum, val) => sum + val).toString(),
                  const Color(0xFF3B82F6),
                ),
                _buildStat(
                  'Total Dirty',
                  dirtyCounts.fold(0, (sum, val) => sum + val).toString(),
                  const Color(0xFF92400E),
                ),
                _buildStat(
                  'Daily Average',
                  ((wetCounts.fold(0, (sum, val) => sum + val) + 
                    dirtyCounts.fold(0, (sum, val) => sum + val) + 
                    mixedCounts.fold(0, (sum, val) => sum + val)) / 
                    (days.isNotEmpty ? days.length : 1)).toStringAsFixed(1),
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
          color: const Color(0xFFDC2626).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.baby_changing_station,
              size: 48,
              color: const Color(0xFFDC2626).withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No diaper data yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Start tracking changes to see your chart',
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

/// Data model for diaper chart
class DiaperData {
  final DateTime date;
  final int wet;
  final int dirty;
  final int mixed;

  DiaperData({
    required this.date,
    required this.wet,
    required this.dirty,
    required this.mixed,
  });

  int get total => wet + dirty + mixed;
}
