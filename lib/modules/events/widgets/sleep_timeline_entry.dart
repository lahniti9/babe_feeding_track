import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../models/sleep_event.dart';
import '../../children/services/children_store.dart';
import 'timeline_container.dart';

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator with connecting line
        TimelineIndicator(
          backgroundColor: Colors.purple.withValues(alpha: 0.1),
          borderColor: Colors.purple,
          isActive: true,
          child: const Icon(
            Icons.bed,
            color: Colors.purple,
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
                  color: Colors.purple.withValues(alpha: 0.2),
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
                          'Sleeping',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      _buildTimeDisplay(),
                      const SizedBox(width: AppSpacing.sm),
                      _buildPlusButton(),
                    ],
                  ),

                  // Child name subtitle
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _getChildName(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  // Sleep details
                  const SizedBox(height: AppSpacing.sm),
                  _buildSleepDetails(),

                  // Comment display
                  if (event.comment != null && event.comment!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _buildCommentDisplay(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }



  Widget _buildPlusButton() {
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

  String _getChildName() {
    try {
      final childrenStore = Get.find<ChildrenStore>();
      final child = childrenStore.getChildById(event.childId);
      return child?.name ?? 'Baby';
    } catch (e) {
      return 'Baby';
    }
  }

  Widget _buildSleepDetails() {
    final duration = event.duration;
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    String durationText;
    if (hours > 0) {
      durationText = '${hours}h ${minutes}m';
    } else {
      durationText = '${minutes}m';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Duration
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              'Duration: $durationText',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),

        // Sleep times
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.bedtime,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              '${DateFormat('HH:mm').format(event.fellAsleep)} - ${DateFormat('HH:mm').format(event.wokeUp)}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),

        // Tags if available
        if (_hasTags()) ...[
          const SizedBox(height: 8),
          _buildTags(),
        ],
      ],
    );
  }

  bool _hasTags() {
    return event.startTags.isNotEmpty ||
           event.endTags.isNotEmpty ||
           event.howTags.isNotEmpty;
  }

  Widget _buildTags() {
    final allTags = [
      ...event.startTags,
      ...event.endTags,
      ...event.howTags,
    ];

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: allTags.map((tag) => _buildTag(tag)).toList(),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        tag,
        style: AppTextStyles.captionMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTimeDisplay() {
    final timeFormat = DateFormat('HH:mm');
    String timeText = timeFormat.format(event.fellAsleep);

    // Add duration if available
    final duration = event.wokeUp.difference(event.fellAsleep);
    if (duration.inHours > 0) {
      timeText += ' (${duration.inHours}h ${duration.inMinutes % 60}m)';
    } else {
      timeText += ' (${duration.inMinutes}m)';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(
          color: Colors.purple.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        timeText,
        style: AppTextStyles.caption.copyWith(
          color: Colors.purple,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCommentDisplay() {
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
              event.comment!,
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