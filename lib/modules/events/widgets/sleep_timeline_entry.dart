import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../models/sleep_event.dart';
import '../views/sleep_exact_view.dart';
import '../views/comment_sheet.dart';
import '../models/event.dart';
import '../controllers/events_controller.dart';

class SleepTimelineEntry extends StatelessWidget {
  final SleepEvent event;
  final VoidCallback? onTap;
  final VoidCallback? onPlusTap;

  const SleepTimelineEntry({
    super.key,
    required this.event,
    this.onTap,
    this.onPlusTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = childNameById(event.childId);
    final title = '$name slept ${humanDuration(event.duration)}';

    return GestureDetector(
      onTap: onTap ?? () => _openEditSheet(),
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
                    relativeTime(event.wokeUp),
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
              DateFormat('HH:mm').format(event.wokeUp),
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
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF8C5BFF), // Purple for sleep
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.nightlight_round,
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
      onTap: onPlusTap ?? _openCommentSheet,
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

  Widget _buildDetailLines() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (event.startTags.isNotEmpty)
          _DetailLine('Start of sleep: ${event.startTags.first.toLowerCase()}'),
        if (event.endTags.isNotEmpty)
          _DetailLine('End of sleep: ${_joinHuman(event.endTags)}'),
        if (event.howTags.isNotEmpty)
          _DetailLine('How: ${_joinHuman(event.howTags)}'),
        if (event.comment != null && event.comment!.isNotEmpty)
          _CommentLine(event.comment!),
      ],
    );
  }

  String _joinHuman(List<String> xs) =>
      xs.length == 1 ? xs.first.toLowerCase()
      : '${xs.take(xs.length - 1).join(', ').toLowerCase()} and ${xs.last.toLowerCase()}';

  void _openEditSheet() {
    Get.bottomSheet(
      SleepExactView(childId: event.childId, initial: event),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _openCommentSheet() {
    Get.bottomSheet(
      CommentSheet(kind: EventKind.sleeping),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class _DetailLine extends StatelessWidget {
  final String text;

  const _DetailLine(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF8EA0FF) // bluish like screenshot
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
