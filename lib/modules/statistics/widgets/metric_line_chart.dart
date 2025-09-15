import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';

/// Modern line chart for growth metrics (Height/Weight/Head Circumference)
/// Features: DateTime axis, trackball, annotations, smooth animations
class MetricLineChart extends StatelessWidget {
  final List<MapEntry<DateTime, double>> points;
  final String yUnit; // 'cm', 'kg', etc.
  final String title;
  final Color color;
  final bool showLatestAnnotation;

  const MetricLineChart({
    super.key,
    required this.points,
    required this.yUnit,
    required this.title,
    required this.color,
    this.showLatestAnnotation = true,
  });

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      height: 280,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
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
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                labelStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
                intervalType: _getIntervalType(),
              ),
              
              // Y-axis (Values)
              primaryYAxis: NumericAxis(
                labelFormat: '{value} $yUnit',
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
                tooltipSettings: InteractiveTooltip(
                  enable: true,
                  color: color.withValues(alpha: 0.9),
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                lineColor: color.withValues(alpha: 0.8),
                lineWidth: 2,
                markerSettings: TrackballMarkerSettings(
                  markerVisibility: TrackballVisibilityMode.visible,
                  color: color,
                  borderColor: Colors.white,
                  borderWidth: 2,
                  width: 8,
                  height: 8,
                ),
              ),
              
              // Data series
              series: <LineSeries<MapEntry<DateTime, double>, DateTime>>[
                LineSeries(
                  dataSource: points,
                  xValueMapper: (entry, _) => entry.key,
                  yValueMapper: (entry, _) => entry.value,
                  color: color,
                  width: 3,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    color: color,
                    borderColor: Colors.white,
                    borderWidth: 2,
                    width: 6,
                    height: 6,
                  ),
                  animationDuration: 1000,
                  enableTooltip: true,
                ),
              ],
              
              // Latest value annotation
              annotations: showLatestAnnotation && points.isNotEmpty
                  ? <CartesianChartAnnotation>[
                      CartesianChartAnnotation(
                        widget: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                color.withValues(alpha: 0.2),
                                color.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: color.withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${points.last.value.toStringAsFixed(1)} $yUnit',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: color,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        coordinateUnit: CoordinateUnit.point,
                        x: points.last.key,
                        y: points.last.value,
                        horizontalAlignment: ChartAlignment.center,
                        verticalAlignment: ChartAlignment.far,
                      ),
                    ]
                  : null,
            ),
          ),
        ],
      ),
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
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.show_chart,
              size: 48,
              color: color.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No $title data yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Start tracking to see your chart',
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

  DateTimeIntervalType _getIntervalType() {
    if (points.isEmpty) return DateTimeIntervalType.days;

    final span = points.last.key.difference(points.first.key);
    if (span.inDays <= 7) return DateTimeIntervalType.days;
    if (span.inDays <= 60) return DateTimeIntervalType.days;
    return DateTimeIntervalType.months;
  }
}
