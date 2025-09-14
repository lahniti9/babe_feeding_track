import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text.dart';
import '../models/breast_feeding_event.dart';
import '../../children/services/children_store.dart';

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
            _buildTimelineIndicator(),
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
                          'Breast Feeding',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      _buildPlusButton(),
                    ],
                  ),

                  // Child name subtitle
                  const SizedBox(height: 4),
                  Text(
                    _getChildName(),
                    style: AppTextStyles.captionMedium,
                  ),

                  // Feeding details
                  const SizedBox(height: 12),
                  _buildFeedingDetails(),

                  // Comment display
                  if (event.comment != null && event.comment!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildCommentDisplay(),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Time
            _buildTimeDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineIndicator() {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 3,
        ),
      ),
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

  Widget _buildFeedingDetails() {
    final leftMinutes = event.left.inMinutes;
    final rightMinutes = event.right.inMinutes;
    final totalMinutes = event.total.inMinutes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Total duration
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              'Total: ${totalMinutes}m',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),

        // Left/Right breakdown
        if (leftMinutes > 0 || rightMinutes > 0) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.baby_changing_station,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Left: ${leftMinutes}m • Right: ${rightMinutes}m',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],

        // Volume if available
        if (event.volumeOz != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.local_drink,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Volume: ${event.volumeOz} oz',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTimeDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          DateFormat('HH:mm').format(event.startAt),
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          DateFormat('MMM d').format(event.startAt),
          style: AppTextStyles.captionMedium,
        ),
      ],
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

