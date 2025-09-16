import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/range_stats_controller.dart';

/// Range selection chips with smooth animations and haptic feedback
class RangeChips extends StatelessWidget {
  final StatsRange selected;
  final ValueChanged<StatsRange> onChanged;
  final Color? accentColor;

  const RangeChips({
    super.key,
    required this.selected,
    required this.onChanged,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? Colors.blue;
    
    return SegmentedButton<StatsRange>(
      segments: [
        ButtonSegment(
          value: StatsRange.day,
          label: const Text('Day'),
          icon: const Icon(Icons.today, size: 16),
        ),
        ButtonSegment(
          value: StatsRange.week,
          label: const Text('Week'),
          icon: const Icon(Icons.view_week, size: 16),
        ),
        ButtonSegment(
          value: StatsRange.month,
          label: const Text('Month'),
          icon: const Icon(Icons.calendar_view_month, size: 16),
        ),
        ButtonSegment(
          value: StatsRange.year,
          label: const Text('Year'),
          icon: const Icon(Icons.calendar_today, size: 16),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (Set<StatsRange> selection) {
        if (selection.isNotEmpty) {
          HapticFeedback.selectionClick();
          onChanged(selection.first);
        }
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return color.withValues(alpha: 0.2);
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return color;
          }
          return Colors.white.withValues(alpha: 0.7);
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BorderSide(color: color, width: 1);
          }
          return BorderSide(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          );
        }),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        minimumSize: WidgetStateProperty.all(const Size(60, 36)),
      ),
    );
  }
}

/// Compact range chips for smaller spaces
class CompactRangeChips extends StatelessWidget {
  final StatsRange selected;
  final ValueChanged<StatsRange> onChanged;
  final Color? accentColor;

  const CompactRangeChips({
    super.key,
    required this.selected,
    required this.onChanged,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? Colors.blue;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: StatsRange.values.map((range) {
        final isSelected = range == selected;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                onChanged(range);
              },
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? color.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected 
                        ? color
                        : Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  _getRangeLabel(range),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected 
                        ? color
                        : Colors.white.withValues(alpha: 0.7),
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getRangeLabel(StatsRange range) {
    switch (range) {
      case StatsRange.day:
        return '1D';
      case StatsRange.week:
        return '7D';
      case StatsRange.month:
        return '30D';
      case StatsRange.year:
        return '1Y';
    }
  }
}

/// KPI chips for displaying key metrics
class KPIChips extends StatelessWidget {
  final List<KPIData> kpis;
  final Color? accentColor;

  const KPIChips({
    super.key,
    required this.kpis,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    if (kpis.isEmpty) return const SizedBox.shrink();
    
    final color = accentColor ?? Colors.blue;
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: kpis.map((kpi) => _buildKPIChip(kpi, color)).toList(),
    );
  }

  Widget _buildKPIChip(KPIData kpi, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            kpi.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.8),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            kpi.displayValue,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.2,
            ),
          ),
          if (kpi.trend != null) ...[
            const SizedBox(width: 4),
            Icon(
              _getTrendIcon(kpi.trend!),
              size: 12,
              color: _getTrendColor(kpi.trend!),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getTrendIcon(String trend) {
    switch (trend) {
      case 'up':
        return Icons.trending_up;
      case 'down':
        return Icons.trending_down;
      case 'stable':
      default:
        return Icons.trending_flat;
    }
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case 'up':
        return Colors.green;
      case 'down':
        return Colors.red;
      case 'stable':
      default:
        return Colors.grey;
    }
  }
}

/// Empty state widget for charts
class EmptyChartState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;
  final Color? accentColor;

  const EmptyChartState({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.onAction,
    this.actionLabel,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? Colors.blue;
    
    return Container(
      height: 200,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: color.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: color.withValues(alpha: 0.2),
                foregroundColor: color,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: color.withValues(alpha: 0.3)),
                ),
              ),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

/// Loading skeleton for charts
class ChartSkeleton extends StatefulWidget {
  final double height;
  final Color? accentColor;

  const ChartSkeleton({
    super.key,
    this.height = 200,
    this.accentColor,
  });

  @override
  State<ChartSkeleton> createState() => _ChartSkeletonState();
}

class _ChartSkeletonState extends State<ChartSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.accentColor ?? Colors.blue;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: widget.height,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Skeleton bars
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(7, (index) {
                    final height = (0.3 + (index * 0.1)) * _animation.value;
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: widget.height * height,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: _animation.value * 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 8),
              // Skeleton labels
              Row(
                children: List.generate(7, (index) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 12,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: _animation.value * 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
