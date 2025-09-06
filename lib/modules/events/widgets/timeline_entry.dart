import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../models/event.dart';
import 'pill_tag.dart';

class TimelineEntry extends StatelessWidget {
  final EventModel model;
  final VoidCallback? onTap;
  final VoidCallback? onPlusTap;

  const TimelineEntry({
    super.key,
    required this.model,
    this.onTap,
    this.onPlusTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline line and icon
            _buildTimelineIndicator(),
            const SizedBox(width: AppSpacing.lg),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row with plus button
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          model.displayTitle,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (model.showPlus) _buildPlusButton(),
                    ],
                  ),
                  
                  // Subtitle
                  if (model.subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      model.subtitle!,
                      style: AppTextStyles.captionMedium,
                    ),
                  ],
                  
                  // Tags
                  if (model.tags.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: model.tags
                          .map((tag) => PillTag(text: tag))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(width: AppSpacing.lg),
            
            // Time
            _buildTimeDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineIndicator() {
    return Column(
      children: [
        // Timeline line (top)
        Container(
          width: 2,
          height: 12,
          color: AppColors.border,
        ),
        // Icon
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: _getKindColor(),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getKindIcon(),
            color: Colors.white,
            size: 14,
          ),
        ),
        // Timeline line (bottom)
        Container(
          width: 2,
          height: 12,
          color: AppColors.border,
        ),
      ],
    );
  }

  Widget _buildPlusButton() {
    return GestureDetector(
      onTap: onPlusTap,
      child: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: AppColors.textSecondary,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 12,
        ),
      ),
    );
  }

  Widget _buildTimeDisplay() {
    final timeFormat = DateFormat('HH:mm');
    String timeText = timeFormat.format(model.time);
    
    // Add duration for ranged events
    if (model.duration != null) {
      final duration = model.duration!;
      if (duration.inHours > 0) {
        timeText += '\n${duration.inHours}h ${duration.inMinutes % 60}m';
      } else {
        timeText += '\n${duration.inMinutes}m';
      }
    }
    
    return Text(
      timeText,
      style: AppTextStyles.caption,
      textAlign: TextAlign.right,
    );
  }

  Color _getKindColor() {
    switch (model.kind) {
      case EventKind.sleeping:
        return const Color(0xFF6B46C1);
      case EventKind.bedtimeRoutine:
        return const Color(0xFF7C3AED);
      case EventKind.bottle:
        return const Color(0xFF059669);
      case EventKind.diaper:
        return const Color(0xFFDC2626);
      case EventKind.condition:
        return const Color(0xFFF59E0B);
      case EventKind.weight:
        return const Color(0xFF0891B2);
      case EventKind.height:
        return const Color(0xFF7C2D12);
      case EventKind.activity:
        return const Color(0xFFDB2777);
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getKindIcon() {
    switch (model.kind) {
      case EventKind.sleeping:
        return Icons.bed;
      case EventKind.bedtimeRoutine:
        return Icons.nightlight;
      case EventKind.bottle:
        return Icons.local_drink;
      case EventKind.diaper:
        return Icons.baby_changing_station;
      case EventKind.condition:
        return Icons.mood;
      case EventKind.weight:
        return Icons.monitor_weight;
      case EventKind.height:
        return Icons.height;
      case EventKind.activity:
        return Icons.sports_gymnastics;
      default:
        return Icons.circle;
    }
  }
}
