import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../core/theme/colors.dart';
import '../models/event.dart';

class SwipeActions extends StatelessWidget {
  final EventModel model;
  final Widget child;
  final VoidCallback? onRemove;

  const SwipeActions({
    super.key,
    required this.model,
    required this.child,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(model.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: onRemove != null ? (_) => onRemove!() : null,
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Remove',
          ),
        ],
      ),
      child: child,
    );
  }
}
