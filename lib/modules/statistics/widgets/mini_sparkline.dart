import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import '../../../core/theme/colors.dart';

/// Mini sparkline chart for statistics tiles
/// Shows trend data in a compact format
class MiniSparkline extends StatelessWidget {
  final List<double> data;
  final Color color;
  final double width;
  final double height;
  final bool showTrend;

  const MiniSparkline({
    super.key,
    required this.data,
    required this.color,
    this.width = 60,
    this.height = 30,
    this.showTrend = true,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty || data.length < 2) {
      return SizedBox(
        width: width,
        height: height,
        child: Container(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Icon(
              Icons.more_horiz,
              size: 16,
              color: color.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: SfSparkLineChart(
        data: data,
        color: color,
        width: 2,
        marker: SparkChartMarker(
          displayMode: SparkChartMarkerDisplayMode.none,
        ),
        trackball: const SparkChartTrackball(
          activationMode: SparkChartActivationMode.tap,
        ),
        plotBand: SparkChartPlotBand(
          start: data.isNotEmpty ? data.reduce((a, b) => a < b ? a : b) : 0,
          end: data.isNotEmpty ? data.reduce((a, b) => a > b ? a : b) : 0,
          color: color.withValues(alpha: 0.1),
        ),
      ),
    );
  }
}

/// Trend indicator widget for statistics tiles
class TrendIndicator extends StatelessWidget {
  final List<double> data;
  final Color color;
  final String? label;

  const TrendIndicator({
    super.key,
    required this.data,
    required this.color,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final trend = _calculateTrend();
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
        ],
        Icon(
          _getTrendIcon(trend),
          size: 12,
          color: _getTrendColor(trend),
        ),
        const SizedBox(width: 2),
        Text(
          _getTrendText(trend),
          style: TextStyle(
            fontSize: 10,
            color: _getTrendColor(trend),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  double _calculateTrend() {
    if (data.length < 2) return 0.0;
    
    // Simple trend calculation: compare recent vs older values
    final recentCount = (data.length / 3).ceil();
    final recent = data.skip(data.length - recentCount);
    final older = data.take(data.length - recentCount);
    
    if (recent.isEmpty || older.isEmpty) return 0.0;
    
    final recentAvg = recent.reduce((a, b) => a + b) / recent.length;
    final olderAvg = older.reduce((a, b) => a + b) / older.length;
    
    if (olderAvg == 0) return 0.0;
    
    return (recentAvg - olderAvg) / olderAvg;
  }

  IconData _getTrendIcon(double trend) {
    if (trend > 0.05) return Icons.trending_up;
    if (trend < -0.05) return Icons.trending_down;
    return Icons.trending_flat;
  }

  Color _getTrendColor(double trend) {
    if (trend > 0.05) return const Color(0xFF10B981); // Green for up
    if (trend < -0.05) return const Color(0xFFEF4444); // Red for down
    return Colors.white.withValues(alpha: 0.6); // Gray for flat
  }

  String _getTrendText(double trend) {
    if (trend > 0.05) return '+${(trend * 100).toStringAsFixed(0)}%';
    if (trend < -0.05) return '${(trend * 100).toStringAsFixed(0)}%';
    return 'Stable';
  }
}

/// Enhanced statistics tile with sparkline
class StatsTileWithSparkline extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final List<double> trendData;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  const StatsTileWithSparkline({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.trendData,
    required this.color,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with icon and sparkline
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: 0.2),
                          color.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 16,
                    ),
                  ),
                  const Spacer(),
                  MiniSparkline(
                    data: trendData,
                    color: color,
                    width: 40,
                    height: 20,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),

              // Value
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2),

              // Subtitle and trend
              Flexible(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TrendIndicator(
                      data: trendData,
                      color: color,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Grid of statistics tiles with sparklines
class StatsGrid extends StatelessWidget {
  final List<StatsTileWithSparkline> tiles;

  const StatsGrid({
    super.key,
    required this.tiles,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: tiles.length,
      itemBuilder: (context, index) => tiles[index],
    );
  }
}
