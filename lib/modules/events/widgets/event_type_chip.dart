import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../models/event.dart';

class EventTypeChip extends StatelessWidget {
  final EventKind kind;
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const EventTypeChip({
    super.key,
    required this.kind,
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Large circular button
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected ? color : color.withValues(alpha: 0.8),
                shape: BoxShape.circle,
                border: isSelected 
                    ? Border.all(color: AppColors.primary, width: 2)
                    : null,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: AppSpacing.iconLg,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          // Label below
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Factory methods for different event types
  static EventTypeChip sleeping({
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return EventTypeChip(
      kind: EventKind.sleeping,
      icon: Icons.bed,
      color: const Color(0xFF6B46C1), // Purple
      label: 'Sleeping',
      onTap: onTap,
      isSelected: isSelected,
    );
  }

  static EventTypeChip bedtimeRoutine({
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return EventTypeChip(
      kind: EventKind.bedtimeRoutine,
      icon: Icons.nightlight,
      color: const Color(0xFF7C3AED), // Purple variant
      label: 'Bedtime\nroutine',
      onTap: onTap,
      isSelected: isSelected,
    );
  }

  static EventTypeChip bottle({
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return EventTypeChip(
      kind: EventKind.bottle,
      icon: Icons.local_drink,
      color: const Color(0xFF059669), // Green
      label: 'Bottle',
      onTap: onTap,
      isSelected: isSelected,
    );
  }

  static EventTypeChip diaper({
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return EventTypeChip(
      kind: EventKind.diaper,
      icon: Icons.baby_changing_station,
      color: const Color(0xFFDC2626), // Red
      label: 'Diaper',
      onTap: onTap,
      isSelected: isSelected,
    );
  }

  static EventTypeChip condition({
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return EventTypeChip(
      kind: EventKind.condition,
      icon: Icons.mood,
      color: const Color(0xFFF59E0B), // Amber
      label: 'Condition',
      onTap: onTap,
      isSelected: isSelected,
    );
  }

  static EventTypeChip weight({
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return EventTypeChip(
      kind: EventKind.weight,
      icon: Icons.monitor_weight,
      color: const Color(0xFF0891B2), // Cyan
      label: 'Weight',
      onTap: onTap,
      isSelected: isSelected,
    );
  }

  static EventTypeChip height({
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return EventTypeChip(
      kind: EventKind.height,
      icon: Icons.height,
      color: const Color(0xFF7C2D12), // Brown
      label: 'Height',
      onTap: onTap,
      isSelected: isSelected,
    );
  }

  static EventTypeChip activity({
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return EventTypeChip(
      kind: EventKind.activity,
      icon: Icons.sports_gymnastics,
      color: const Color(0xFFDB2777), // Pink
      label: 'Activity',
      onTap: onTap,
      isSelected: isSelected,
    );
  }
}
