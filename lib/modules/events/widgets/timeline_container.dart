import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';

class TimelineContainer extends StatelessWidget {
  final Widget child;
  final bool isFirst;
  final bool isLast;
  final bool isSeparator;
  final Color? lineColor;
  final double lineWidth;
  final double indicatorSize;

  const TimelineContainer({
    super.key,
    required this.child,
    this.isFirst = false,
    this.isLast = false,
    this.isSeparator = false,
    this.lineColor,
    this.lineWidth = 2.0,
    this.indicatorSize = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveLineColor = lineColor ?? AppColors.coral.withValues(alpha: 0.3);
    
    return Stack(
      children: [
        // Timeline line
        if (!isSeparator) _buildTimelineLine(effectiveLineColor),
        
        // Content with proper spacing for timeline
        Padding(
          padding: EdgeInsets.only(
            left: isSeparator ? 0 : (indicatorSize / 2) + AppSpacing.lg,
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildTimelineLine(Color lineColor) {
    return Positioned(
      left: (indicatorSize / 2) - (lineWidth / 2),
      top: isFirst ? indicatorSize / 2 : 0,
      bottom: isLast ? null : 0,
      child: Container(
        width: lineWidth,
        height: isLast ? indicatorSize / 2 : null,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              lineColor,
              lineColor.withValues(alpha: 0.1),
            ],
            stops: const [0.0, 1.0],
          ),
        ),
      ),
    );
  }
}

class TimelineIndicator extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final double size;
  final bool isActive;
  final bool isPulse;

  const TimelineIndicator({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.size = 48.0,
    this.isActive = false,
    this.isPulse = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? AppColors.cardBackground;
    final effectiveBorderColor = borderColor ?? AppColors.coral;

    Widget indicator = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: effectiveBorderColor.withValues(alpha: isActive ? 1.0 : 0.3),
          width: isActive ? 3 : 2,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: effectiveBorderColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (isPulse && isActive) {
      indicator = _buildPulseAnimation(indicator, effectiveBorderColor);
    }

    return indicator;
  }

  Widget _buildPulseAnimation(Widget child, Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 2),
      builder: (context, value, _) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Pulse ring
            Container(
              width: size + (20 * value),
              height: size + (20 * value),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: 0.3 * (1 - value)),
                  width: 2,
                ),
              ),
            ),
            // Main indicator
            child,
          ],
        );
      },
    );
  }
}

class TimelineDot extends StatelessWidget {
  final Color color;
  final double size;
  final bool isActive;

  const TimelineDot({
    super.key,
    required this.color,
    this.size = 12.0,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
    );
  }
}
