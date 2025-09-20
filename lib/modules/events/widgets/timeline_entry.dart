import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../models/event.dart';
import '../utils/event_colors.dart';
import 'pill_tag.dart';
import 'timeline_container.dart';

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator with connecting line
        TimelineIndicator(
          backgroundColor: _getKindColor().withValues(alpha: 0.1),
          borderColor: _getKindColor(),
          isActive: true,
          child: Icon(
            _getKindIcon(),
            color: _getKindColor(),
            size: 24,
          ),
        ),

        const SizedBox(width: AppSpacing.lg),

        // Event content card
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(
                  color: _getKindColor().withValues(alpha: 0.2),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row with plus button and time
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          model.displayTitle,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      _buildTimeDisplay(),
                      const SizedBox(width: AppSpacing.sm),
                      _buildEnhancedPlusButton(),
                    ],
                  ),

                  // Subtitle
                  if (model.subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      model.subtitle!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
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
                    const SizedBox(height: AppSpacing.sm),
                    _buildCommentDisplay(model.comment!),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }



  Widget _buildCommentDisplay(String comment) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.coral.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.coral.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
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
              style: AppTextStyles.bodyMedium.copyWith(
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
    if (onPlusTap == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onPlusTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.add,
          size: 14,
          color: AppColors.primary,
        ),
      ),
    );
  }



  Widget _buildTimeDisplay() {
    final timeFormat = DateFormat('HH:mm');
    String timeText = timeFormat.format(model.time);

    // Add duration for ranged events (more compact)
    if (model.duration != null) {
      final duration = model.duration!;
      if (duration.inHours > 0) {
        timeText += ' (${duration.inHours}h ${duration.inMinutes % 60}m)';
      } else {
        timeText += ' (${duration.inMinutes}m)';
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _getKindColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(
          color: _getKindColor().withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        timeText,
        style: AppTextStyles.caption.copyWith(
          color: _getKindColor(),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getKindColor() {
    return EventColors.getEventKindColor(model.kind);
  }

  IconData _getKindIcon() {
    return EventColors.getEventKindIcon(model.kind);
  }
}
