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
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced timeline indicator
            _buildEnhancedTimelineIndicator(),
            const SizedBox(width: 16),

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
                            color: Colors.white,
                          ),
                        ),
                      ),
                      _buildEnhancedPlusButton(),
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

                  // Comment display
                  if (model.comment != null && model.comment!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildCommentDisplay(model.comment!),
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

  Widget _buildEnhancedTimelineIndicator() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _getKindColor().withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: _getKindColor().withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Icon(
        _getKindIcon(),
        color: _getKindColor(),
        size: 24,
      ),
    );
  }

  Widget _buildCommentDisplay(String comment) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.coral.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.coral.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            color: AppColors.coral,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              comment,
              style: AppTextStyles.captionMedium.copyWith(
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedPlusButton() {
    return GestureDetector(
      onTap: onPlusTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.coral.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.coral.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.add,
          color: AppColors.coral,
          size: 16,
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
