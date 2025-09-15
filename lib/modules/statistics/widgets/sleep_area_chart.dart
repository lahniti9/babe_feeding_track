import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';

/// Sleep heatmap widget for hour-of-day visualization
class SleepHeatmap extends StatelessWidget {
  final List<int> minutesByHour; // 24 hours, 0-23
  final String title;

  const SleepHeatmap({
    super.key,
    required this.minutesByHour,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (minutesByHour.length != 24) {
      return _buildEmptyState();
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: const Color(0xFF6B46C1).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: Row(
              children: [
                // Hour labels
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildHourLabel('12AM'),
                    _buildHourLabel('6AM'),
                    _buildHourLabel('12PM'),
                    _buildHourLabel('6PM'),
                  ],
                ),
                const SizedBox(width: AppSpacing.sm),
                // Heatmap grid
                Expanded(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 12,
                      childAspectRatio: 1,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: 24,
                    itemBuilder: (context, index) {
                      final intensity = _getIntensity(minutesByHour[index]);
                      return Container(
                        decoration: BoxDecoration(
                          color: _getHeatmapColor(intensity),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            index.toString().padLeft(2, '0'),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: intensity > 0.5
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Less sleep',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.only(left: 2),
                    decoration: BoxDecoration(
                      color: _getHeatmapColor(index / 4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
              Text(
                'More sleep',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHourLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        color: Colors.white.withValues(alpha: 0.6),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: const Color(0xFF6B46C1).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          'No hourly sleep data available',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  double _getIntensity(int minutes) {
    if (minutes == 0) return 0.0;
    final maxMinutes = minutesByHour.reduce((a, b) => a > b ? a : b);
    if (maxMinutes == 0) return 0.0;
    return (minutes / maxMinutes).clamp(0.1, 1.0);
  }

  Color _getHeatmapColor(double intensity) {
    const baseColor = Color(0xFF6B46C1);
    return baseColor.withValues(alpha: 0.2 + (intensity * 0.8));
  }
}

/// Modern area chart for sleep data with gradient fill
/// Shows daily sleep minutes with smooth area visualization
class SleepAreaChart extends StatelessWidget {
  final List<MapEntry<DateTime, double>> minutesPerDay;
  final String title;

  const SleepAreaChart({
    super.key,
    required this.minutesPerDay,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (minutesPerDay.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      height: 280,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: const Color(0xFF6B46C1).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart title with average
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
                      Color(0x336B46C1),
                      Color(0x1A6B46C1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF6B46C1).withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Avg: ${_getAverageHours()}h',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B46C1),
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
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
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                labelStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
                intervalType: _getIntervalType(),
              ),
              
              // Y-axis (Hours)
              primaryYAxis: NumericAxis(
                labelFormat: '{value}h',
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
              
              // Trackball for precise values
              trackballBehavior: TrackballBehavior(
                enable: true,
                activationMode: ActivationMode.singleTap,
                tooltipSettings: const InteractiveTooltip(
                  enable: true,
                  color: Color(0xFF6B46C1),
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                lineColor: const Color(0xFF6B46C1),
                lineWidth: 2,
                markerSettings: const TrackballMarkerSettings(
                  markerVisibility: TrackballVisibilityMode.visible,
                  color: Color(0xFF6B46C1),
                  borderColor: Colors.white,
                  borderWidth: 2,
                  width: 8,
                  height: 8,
                ),
              ),
              
              // Data series
              series: <AreaSeries<MapEntry<DateTime, double>, DateTime>>[
                AreaSeries(
                  dataSource: minutesPerDay,
                  xValueMapper: (entry, _) => entry.key,
                  yValueMapper: (entry, _) => entry.value / 60.0, // Convert to hours
                  color: const Color(0xFF6B46C1).withValues(alpha: 0.3),
                  borderColor: const Color(0xFF6B46C1),
                  borderWidth: 3,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0x666B46C1),
                      Color(0x1A6B46C1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    color: Color(0xFF6B46C1),
                    borderColor: Colors.white,
                    borderWidth: 2,
                    width: 6,
                    height: 6,
                  ),
                  animationDuration: 1000,
                  enableTooltip: true,
                ),
              ],
            ),
          ),
          
          // Sleep quality indicators
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
                  'Total Days',
                  minutesPerDay.length.toString(),
                  Colors.white.withValues(alpha: 0.8),
                ),
                _buildStat(
                  'Best Night',
                  '${_getBestNight()}h',
                  const Color(0xFF10B981),
                ),
                _buildStat(
                  'Recent Trend',
                  _getTrend(),
                  _getTrendColor(),
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
      height: 280,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: const Color(0xFF6B46C1).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bed,
              size: 48,
              color: const Color(0xFF6B46C1).withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No sleep data yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Start tracking sleep to see your chart',
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

  String _getAverageHours() {
    if (minutesPerDay.isEmpty) return '0.0';
    final avg = minutesPerDay.map((e) => e.value).reduce((a, b) => a + b) / minutesPerDay.length;
    return (avg / 60.0).toStringAsFixed(1);
  }

  String _getBestNight() {
    if (minutesPerDay.isEmpty) return '0.0';
    final max = minutesPerDay.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    return (max / 60.0).toStringAsFixed(1);
  }

  String _getTrend() {
    if (minutesPerDay.length < 2) return '—';
    final recentCount = minutesPerDay.length >= 3 ? 3 : minutesPerDay.length;
    final recent = minutesPerDay.skip(minutesPerDay.length - recentCount).map((e) => e.value).toList();
    final older = minutesPerDay.take(minutesPerDay.length - recentCount).map((e) => e.value).toList();
    
    if (recent.isEmpty || older.isEmpty) return '—';
    
    final recentAvg = recent.reduce((a, b) => a + b) / recent.length;
    final olderAvg = older.reduce((a, b) => a + b) / older.length;
    
    if (recentAvg > olderAvg + 30) return '↗ Better';
    if (recentAvg < olderAvg - 30) return '↘ Worse';
    return '→ Stable';
  }

  Color _getTrendColor() {
    final trend = _getTrend();
    if (trend.contains('Better')) return const Color(0xFF10B981);
    if (trend.contains('Worse')) return const Color(0xFFEF4444);
    return Colors.white.withValues(alpha: 0.8);
  }

  DateTimeIntervalType _getIntervalType() {
    if (minutesPerDay.isEmpty) return DateTimeIntervalType.days;

    final span = minutesPerDay.last.key.difference(minutesPerDay.first.key);
    if (span.inDays <= 7) return DateTimeIntervalType.days;
    if (span.inDays <= 60) return DateTimeIntervalType.days;
    return DateTimeIntervalType.months;
  }
}
