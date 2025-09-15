import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';

/// Modern donut chart for daily time allocation
/// Shows sleep, feeding, activity breakdown with center stats
class DailyResultsDonut extends StatelessWidget {
  final double sleepMinutes;
  final double feedingMinutes;
  final double activityMinutes;
  final String title;
  final DateTime date;

  const DailyResultsDonut({
    super.key,
    required this.sleepMinutes,
    required this.feedingMinutes,
    required this.activityMinutes,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final totalMinutes = sleepMinutes + feedingMinutes + activityMinutes;
    final freeTime = (24 * 60) - totalMinutes;

    if (totalMinutes <= 0) {
      return _buildEmptyState();
    }

    final data = [
      TimeAllocationData('Sleep', sleepMinutes, const Color(0xFF6B46C1)),
      TimeAllocationData('Feeding', feedingMinutes, const Color(0xFF059669)),
      TimeAllocationData('Activity', activityMinutes, const Color(0xFFDB2777)),
      TimeAllocationData('Free Time', freeTime > 0 ? freeTime : 0, const Color(0xFF6B7280)),
    ].where((item) => item.minutes > 0).toList();

    return Container(
      height: 360,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart title with date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0x33F59E0B),
                      Color(0x1AF59E0B),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Text(
                  _formatDate(date),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF59E0B),
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Chart
          Expanded(
            child: SfCircularChart(
              backgroundColor: Colors.transparent,
              margin: const EdgeInsets.all(0),
              
              // Tooltip
              tooltipBehavior: TooltipBehavior(
                enable: true,
                color: AppColors.cardBackgroundSecondary,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                borderColor: const Color(0xFFF59E0B),
                borderWidth: 1,
                format: 'point.x: point.yh point.ym',
              ),
              
              // Legend
              legend: const Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                alignment: ChartAlignment.center,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                itemPadding: 12,
                overflowMode: LegendItemOverflowMode.wrap,
              ),
              
              // Data series
              series: <DoughnutSeries<TimeAllocationData, String>>[
                DoughnutSeries<TimeAllocationData, String>(
                  dataSource: data,
                  xValueMapper: (data, _) => data.category,
                  yValueMapper: (data, _) => data.minutes,
                  pointColorMapper: (data, _) => data.color,
                  innerRadius: '60%',
                  radius: '90%',
                  strokeColor: AppColors.cardBackground,
                  strokeWidth: 3,
                  animationDuration: 1000,
                  enableTooltip: true,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    labelIntersectAction: LabelIntersectAction.shift,
                  ),
                  dataLabelMapper: (data, _) => '${(data.minutes / 60).toStringAsFixed(1)}h',
                ),
              ],
              
              // Center content
              annotations: <CircularChartAnnotation>[
                CircularChartAnnotation(
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(totalMinutes / 60).toStringAsFixed(1)}h',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tracked Time',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
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
                  'Sleep %',
                  '${((sleepMinutes / (24 * 60)) * 100).toStringAsFixed(0)}%',
                  const Color(0xFF6B46C1),
                ),
                _buildStat(
                  'Active %',
                  '${(((feedingMinutes + activityMinutes) / (24 * 60)) * 100).toStringAsFixed(0)}%',
                  const Color(0xFF059669),
                ),
                _buildStat(
                  'Efficiency',
                  _getEfficiencyRating(),
                  _getEfficiencyColor(),
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
      height: 360,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart,
              size: 48,
              color: const Color(0xFFF59E0B).withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No activity data yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Start tracking activities to see your breakdown',
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

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _getEfficiencyRating() {
    final sleepHours = sleepMinutes / 60;
    final activeHours = (feedingMinutes + activityMinutes) / 60;
    
    if (sleepHours >= 12 && activeHours >= 4) return 'Great';
    if (sleepHours >= 10 && activeHours >= 3) return 'Good';
    if (sleepHours >= 8) return 'Fair';
    return 'Low';
  }

  Color _getEfficiencyColor() {
    final rating = _getEfficiencyRating();
    switch (rating) {
      case 'Great': return const Color(0xFF10B981);
      case 'Good': return const Color(0xFF059669);
      case 'Fair': return const Color(0xFFF59E0B);
      default: return const Color(0xFFEF4444);
    }
  }
}

/// Data model for time allocation chart
class TimeAllocationData {
  final String category;
  final double minutes;
  final Color color;

  TimeAllocationData(this.category, this.minutes, this.color);
}
