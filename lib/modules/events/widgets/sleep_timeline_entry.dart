import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text.dart';
import '../models/sleep_event.dart';
import '../views/sleep_exact_view.dart';



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
                          title,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      _buildEnhancedPlusButton(),
                    ],
                  ),

                  // Subtitle with child name
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: AppTextStyles.captionMedium,
                  ),

                  // Detail lines
                  const SizedBox(height: 8),
                  _buildDetailLines(),

                  // Comment display
                  if (event.comment != null && event.comment!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildCommentDisplay(event.comment!),
                  ],
                ],
              ),
            ),

            // Time (right-aligned)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  relativeTime(event.wokeUp),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('HH:mm').format(event.wokeUp),
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
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
        color: const Color(0xFF8C5BFF).withValues(alpha: 0.1), // Purple for sleep
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF8C5BFF).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.nightlight_round,
        color: Color(0xFF8C5BFF),
        size: 24,
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
          size: 18,
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
        // Comment removed from here - it's displayed separately below
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


