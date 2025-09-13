import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text.dart';
import '../models/cry_event.dart';

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
    final name = childNameById(event.childId);
    final title = '$name was crying';

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
                ],
              ),
            ),

            // Time (right-aligned)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  relativeTime(event.time),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('HH:mm').format(event.time),
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
        color: const Color(0xFFFF6B6B).withValues(alpha: 0.1), // Red for crying
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.sentiment_very_dissatisfied,
        color: Color(0xFFFF6B6B),
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
        if (event.sounds.isNotEmpty)
          _DetailLine('Sounds: ${_joinHuman(event.sounds.map((s) => s.displayName).toList())}'),
        if (event.volume.isNotEmpty)
          _DetailLine('Volume: ${_joinHuman(event.volume.map((v) => v.displayName).toList())}'),
        if (event.rhythm.isNotEmpty)
          _DetailLine('Rhythm: ${_joinHuman(event.rhythm.map((r) => r.displayName).toList())}'),
        if (event.duration.isNotEmpty)
          _DetailLine('Duration: ${_joinHuman(event.duration.map((d) => d.displayName).toList())}'),
        if (event.behaviour.isNotEmpty)
          _DetailLine('Behaviour: ${_joinHuman(event.behaviour.map((b) => b.displayName).toList())}'),
      ],
    );
  }

  String _joinHuman(List<String> xs) =>
      xs.length == 1 ? xs.first.toLowerCase()
      : '${xs.take(xs.length - 1).join(', ').toLowerCase()} and ${xs.last.toLowerCase()}';
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
