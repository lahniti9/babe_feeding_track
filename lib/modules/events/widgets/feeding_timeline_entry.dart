import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../models/breast_feeding_event.dart';
import '../models/event.dart';

class FeedingTimelineEntry extends StatelessWidget {
  final BreastFeedingEvent event;
  final VoidCallback? onTap;
  final VoidCallback? onPlusTap;

  const FeedingTimelineEntry({
    super.key,
    required this.event,
    this.onTap,
    this.onPlusTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = childNameById(event.childId);
    final title = '$name was breastfed for ${prettySecs(event.total.inSeconds)}';

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
                  // Top left caption (relative time)
                  Text(
                    relativeTime(event.startAt),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  
                  // Title row with plus button
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _buildPlusButton(),
                    ],
                  ),
                  
                  // Detail lines
                  const SizedBox(height: AppSpacing.sm),
                  _buildDetailLines(),
                ],
              ),
            ),
            
            const SizedBox(width: AppSpacing.lg),
            
            // Time (right-aligned)
            Text(
              DateFormat('HH:mm').format(event.startAt),
              style: AppTextStyles.caption,
              textAlign: TextAlign.right,
            ),
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
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFE14E63), // red
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.child_care,
            color: Colors.white,
            size: 18,
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
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(
          Icons.add,
          size: 16,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildDetailLines() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DetailLine('Total ${prettySecs(event.total.inSeconds)}'
            + (event.volumeOz != null ? ' • ${event.volumeOz} oz' : '')),
        _DetailLine('Left ${prettySecs(event.left.inSeconds)}  •  Right ${prettySecs(event.right.inSeconds)}'),
        if (event.comment != null && event.comment!.isNotEmpty)
          _CommentLine(event.comment!),
      ],
    );
  }
}

class _DetailLine extends StatelessWidget {
  final String text;

  const _DetailLine(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _CommentLine extends StatelessWidget {
  final String comment;

  const _CommentLine(this.comment);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.comment_outlined,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              comment,
              style: AppTextStyles.captionMedium.copyWith(
                color: AppColors.textPrimary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper function to get child name by ID
String childNameById(String childId) {
  // TODO: Implement proper child name lookup
  return 'Baby'; // Placeholder
}

// Helper function to format relative time
String relativeTime(DateTime time) {
  final now = DateTime.now();
  final difference = now.difference(time);
  
  if (difference.inMinutes < 1) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  } else {
    return '${difference.inDays}d ago';
  }
}
