import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text.dart';
import '../models/cry_event.dart';
import '../../children/services/children_store.dart';

class CryTimelineEntry extends StatelessWidget {
  final CryEvent event;
  final VoidCallback? onTap;
  final VoidCallback? onPlusTap;

  const CryTimelineEntry({
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
                          'Crying',
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

                  // Cry details
                  const SizedBox(height: 12),
                  _buildCryDetails(),
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
        color: AppColors.error,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
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

  Widget _buildCryDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cry characteristics
        if (event.sounds.isNotEmpty) ...[
          Row(
            children: [
              Icon(
                Icons.volume_up,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Sound: ${event.sounds.first.name}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],

        if (event.volume.isNotEmpty) ...[
          Row(
            children: [
              Icon(
                Icons.graphic_eq,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Volume: ${event.volume.first.name}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],

        // Tags if available
        if (_hasTags()) ...[
          _buildTags(),
        ],
      ],
    );
  }

  bool _hasTags() {
    return event.rhythm.isNotEmpty ||
           event.duration.isNotEmpty ||
           event.behaviour.isNotEmpty;
  }

  Widget _buildTags() {
    final allTags = [
      ...event.rhythm.map((r) => r.name),
      ...event.duration.map((d) => d.name),
      ...event.behaviour.map((b) => b.name),
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
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        tag,
        style: AppTextStyles.captionMedium.copyWith(
          color: AppColors.error,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTimeDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          DateFormat('HH:mm').format(event.time),
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          DateFormat('MMM d').format(event.time),
          style: AppTextStyles.captionMedium,
        ),
      ],
    );
  }
}
