import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/quick_actions_config.dart';

class QuickActionsHeader extends StatelessWidget {
  final UserRole role;
  final void Function(EventKind kind) onTap;
  final void Function(EventKind kind)? onLongPressFilter;

  const QuickActionsHeader({
    super.key,
    required this.role,
    required this.onTap,
    this.onLongPressFilter,
  });

  @override
  Widget build(BuildContext context) {
    final visible = quickActions.where((q) => q.roles.contains(role)).toList();

    return SizedBox(
      height: 112, // circle + label
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          final q = visible[i];
          return _Chip(
            label: q.label,
            icon: q.icon,
            color: q.bgColor,
            onTap: () => onTap(q.kind),
            onLongPress: () => onLongPressFilter?.call(q.kind),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: visible.length,
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  
  const _Chip({
    required this.label, 
    required this.icon, 
    required this.color, 
    required this.onTap, 
    this.onLongPress
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 68, 
            height: 68,
            decoration: BoxDecoration(
              color: color, 
              shape: BoxShape.circle
            ),
            child: Icon(
              icon, 
              color: Colors.white, 
              size: 30
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 76,
            child: Text(
              label, 
              maxLines: 1, 
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center, 
              style: const TextStyle(
                fontSize: 12, 
                color: Colors.white
              )
            ),
          ),
        ],
      ),
    );
  }
}
