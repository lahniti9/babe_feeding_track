import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';

/// Premium chart card component with live data and interactions
/// Provides title, range chips, KPIs, chart, empty states, and refresh
class ChartCard extends StatelessWidget {
  final String title;
  final Widget chart;
  final List<Widget> actions; // range chips, toggles, etc.
  final String? kpi;
  final Widget? empty;
  final bool isLoading;
  final VoidCallback? onRefresh;
  final VoidCallback? onTap;
  final Color? accentColor;

  const ChartCard({
    super.key,
    required this.title,
    required this.chart,
    this.actions = const [],
    this.kpi,
    this.empty,
    this.isLoading = false,
    this.onRefresh,
    this.onTap,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    // Show empty state if provided and not loading
    if (!isLoading && empty != null) {
      return empty!;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: const Color(0xFF111217),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
            border: Border.all(
              color: accentColor?.withValues(alpha: 0.2) ??
                     Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: RefreshIndicator(
            onRefresh: onRefresh != null ? () async => onRefresh!() : () async {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and actions
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    if (isLoading)
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            accentColor ?? Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                  ],
                ),

                // KPI display
                if (kpi != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor?.withValues(alpha: 0.1) ??
                             Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: accentColor?.withValues(alpha: 0.2) ??
                               Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      kpi!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: accentColor ?? Colors.white.withValues(alpha: 0.8),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],

                // Actions (range chips, toggles, etc.)
                if (actions.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: actions,
                  ),
                ],

                // Chart content
                const SizedBox(height: AppSpacing.md),
                if (isLoading)
                  SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          accentColor ?? Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  )
                else
                  chart,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Range selection bar with sticky chips
class RangeBar extends StatelessWidget {
  final int selected; // index: 0..n
  final void Function(int) onSelect;
  final Widget? trailing; // e.g., unit toggle

  const RangeBar({
    super.key,
    required this.selected,
    required this.onSelect,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final labels = ['7D', '14D', '30D', '90D', 'YTD', 'Custom'];
    
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(labels.length, (i) {
                final isSelected = i == selected;
                return Padding(
                  padding: EdgeInsets.only(right: i < labels.length - 1 ? 8 : 0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onSelect(i);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? AppColors.coral.withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected 
                                ? AppColors.coral.withValues(alpha: 0.4)
                                : Colors.white.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          labels[i],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected 
                                ? AppColors.coral
                                : Colors.white.withValues(alpha: 0.8),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: AppSpacing.md),
          trailing!,
        ],
      ],
    );
  }
}

/// Unit toggle switch (kg↔lb, cm↔in)
class UnitToggle extends StatelessWidget {
  final String left, right;   // 'kg' | 'lb', 'cm' | 'in'
  final bool rightOn;
  final VoidCallback onToggle;

  const UnitToggle({
    super.key,
    required this.left,
    required this.right,
    required this.rightOn,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onToggle();
        },
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                left,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: !rightOn 
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '/',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                right,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: rightOn 
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Metric badge for displaying latest/avg/total values
class MetricBadge extends StatelessWidget {
  final String label; // Latest / Avg / Total
  final String value; // "61.2 cm", "8h 12m"
  final Color color;

  const MetricBadge({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
        color: color.withValues(alpha: 0.08),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$label • $value',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
