import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/colors.dart';
import '../models/spurt_models.dart';
import '../views/spurt_detail_view.dart';

class SpurtTile extends StatelessWidget {
  final int week;
  final SpurtEpisode? episode;
  final bool isCurrent;
  final String range;

  const SpurtTile({
    super.key,
    required this.week,
    required this.episode,
    required this.isCurrent,
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    final color = switch (episode?.type) {
      SpurtType.growthLeap => AppColors.coral, // Coral
      SpurtType.fussyPhase => const Color(0xFF28C076), // Green
      _ => const Color(0xFF1A1A1A), // Dark grey for normal weeks
    };

    return GestureDetector(
      onTap: episode == null ? null : () => Get.to(() => SpurtDetailView(week: week)),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            // Current week ring indicator
            if (isCurrent)
              Positioned(
                top: 4,
                left: 4,
                child: _ScribbleRing(),
              ),
            
            // Week number (top-left)
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                '$week',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            
            // Date range (bottom-left)
            Align(
              alignment: Alignment.bottomLeft,
              child: Opacity(
                opacity: 0.85,
                child: Text(
                  range,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            
            // Chevron indicator (bottom-right) - only if episode exists
            if (episode != null)
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Custom widget to draw the hand-drawn style ring for current week
class _ScribbleRing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(22, 22),
      painter: _ScribbleRingPainter(),
    );
  }
}

class _ScribbleRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.lightCoral // Light coral
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    // Draw a slightly irregular circle to simulate hand-drawn look
    final path = Path();
    
    // Create points around the circle with slight variations
    const numPoints = 16;
    final points = <Offset>[];
    
    for (int i = 0; i < numPoints; i++) {
      final angle = (i * 2 * 3.14159) / numPoints;
      final radiusVariation = radius + (i % 3 == 0 ? 1.0 : -0.5); // Slight variation
      final x = center.dx + radiusVariation * math.cos(angle);
      final y = center.dy + radiusVariation * math.sin(angle);
      points.add(Offset(x, y));
    }
    
    // Draw the path
    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      // Leave a small gap to simulate hand-drawn style
      // Don't close the path completely
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
