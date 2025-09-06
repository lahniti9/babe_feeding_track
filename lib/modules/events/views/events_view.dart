import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../../../core/widgets/bc_scaffold.dart';
import '../controllers/events_controller.dart';
import '../widgets/quick_actions_header.dart';
import '../widgets/timeline_entry.dart';
import '../widgets/timeline_separator.dart';
import '../widgets/swipe_actions.dart';
import '../widgets/sleep_timeline_entry.dart';
import '../models/event.dart';
import '../models/sleep_event.dart';
import '../views/comment_sheet.dart';

class EventsView extends StatelessWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EventsController());
    
    return BCScaffold(
      showBack: false,
      body: Column(
        children: [
          // Quick action chips
          Obx(() => QuickActionsHeader(
            role: controller.role.value,
            onTap: controller.onQuickActionTap,
            onLongPressFilter: controller.onQuickActionLongPress,
          )),
          
          // Events list
          Expanded(
            child: Obx(() {
              final groupedEvents = controller.groupedEvents;
              
              if (groupedEvents.isEmpty) {
                return _buildEmptyState();
              }
              
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                itemCount: _getTotalItemCount(groupedEvents),
                itemBuilder: (context, index) {
                  return _buildListItem(context, controller, groupedEvents, index);
                },
              );
            }),
          ),
        ],
      ),
    );
  }



  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timeline,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            "No events yet",
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            "Start tracking your baby's activities",
            style: AppTextStyles.captionMedium,
          ),
        ],
      ),
    );
  }

  int _getTotalItemCount(Map<String, List<dynamic>> groupedEvents) {
    int count = 0;
    for (final entry in groupedEvents.entries) {
      count += 1; // separator
      count += entry.value.length; // events
    }
    return count;
  }

  Widget _buildListItem(
    BuildContext context,
    EventsController controller,
    Map<String, List<dynamic>> groupedEvents,
    int index,
  ) {
    int currentIndex = 0;
    
    for (final entry in groupedEvents.entries) {
      // Check if this is the separator
      if (currentIndex == index) {
        return TimelineSeparator(label: entry.key);
      }
      currentIndex++;
      
      // Check if this is one of the events in this group
      for (final event in entry.value) {
        if (currentIndex == index) {
          return _buildEventWidget(controller, event);
        }
        currentIndex++;
      }
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildEventWidget(EventsController controller, dynamic event) {
    if (event is SleepEvent) {
      return SleepTimelineEntry(
        event: event,
        onTap: () => controller.edit(event),
      );
    } else if (event is EventModel) {
      return SwipeActions(
        model: event,
        onEdit: () => controller.edit(event),
        onRemove: () => controller.remove(event.id),
        child: TimelineEntry(
          model: event,
          onTap: () => controller.edit(event),
          onPlusTap: event.showPlus
              ? () => _openCommentSheet(event.kind)
              : null,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  void _openCommentSheet(EventKind kind) {
    Get.bottomSheet(
      CommentSheet(kind: kind),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
