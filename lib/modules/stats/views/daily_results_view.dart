import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../widgets/chart_scaffold.dart';
import '../controllers/daily_results_controller.dart';
import '../models/stats_models.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';

class DailyResultsView extends StatelessWidget {
  final String childId;

  const DailyResultsView({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DailyResultsController(childId: childId));

    return Obx(() => ChartScaffold(
          title: 'Daily Results',
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildContent(controller),
        ));
  }

  Widget _buildContent(DailyResultsController controller) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Legend chips
          _buildLegend(),
          const SizedBox(height: AppSpacing.xl),
          
          // Circular day ring
          Expanded(
            child: Center(
              child: _buildDayRing(controller),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Bottle', Colors.orange),
        const SizedBox(width: AppSpacing.lg),
        _buildLegendItem('Daytime sleep', Colors.purple),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
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
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayRing(DailyResultsController controller) {
    return SizedBox(
      width: 300,
      height: 300,
      child: CustomPaint(
        painter: DayRingPainter(
          arcs: controller.dayArcs,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Today',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                controller.todayDate,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DayRingPainter extends CustomPainter {
  final List<RadialArc> arcs;

  DayRingPainter({required this.arcs});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    final strokeWidth = 20.0;

    // Draw background ring
    final backgroundPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw hour markers
    _drawHourMarkers(canvas, center, radius, strokeWidth);

    // Draw arcs for events
    for (final arc in arcs) {
      final paint = Paint()
        ..color = _getColorFromString(arc.color ?? 'blue')
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final startAngle = (arc.startAngle - 90) * math.pi / 180; // Adjust for 12 o'clock start
      final sweepAngle = arc.sweepAngle * math.pi / 180;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  void _drawHourMarkers(Canvas canvas, Offset center, double radius, double strokeWidth) {
    final markerPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.5)
      ..strokeWidth = 2;

    for (int hour = 0; hour < 24; hour += 3) {
      final angle = (hour * 15 - 90) * math.pi / 180; // 15 degrees per hour, start at 12 o'clock
      final innerRadius = radius - strokeWidth / 2 - 5;
      final outerRadius = radius + strokeWidth / 2 + 5;

      final innerPoint = Offset(
        center.dx + innerRadius * math.cos(angle),
        center.dy + innerRadius * math.sin(angle),
      );
      final outerPoint = Offset(
        center.dx + outerRadius * math.cos(angle),
        center.dy + outerRadius * math.sin(angle),
      );

      canvas.drawLine(innerPoint, outerPoint, markerPaint);

      // Draw hour labels
      final textPainter = TextPainter(
        text: TextSpan(
          text: hour.toString().padLeft(2, '0'),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final labelRadius = outerRadius + 15;
      final labelOffset = Offset(
        center.dx + labelRadius * math.cos(angle) - textPainter.width / 2,
        center.dy + labelRadius * math.sin(angle) - textPainter.height / 2,
      );

      textPainter.paint(canvas, labelOffset);
    }
  }

  Color _getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
