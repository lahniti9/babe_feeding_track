import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../models/cry_event.dart';
import '../models/event.dart';

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
                    relativeTime(event.time),
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
              DateFormat('HH:mm').format(event.time),
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
            color: const Color(0xFF3BB3C4), // teal
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.sick_outlined,
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
