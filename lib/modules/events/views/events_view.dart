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
import '../widgets/cry_timeline_entry.dart';
import '../widgets/feeding_timeline_entry.dart';
import '../models/event.dart';
import '../models/sleep_event.dart';
import '../models/cry_event.dart';
import '../models/breast_feeding_event.dart';
import '../models/event_record.dart';

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
          // Enhanced header with stats
          _buildEnhancedHeader(controller),

          // Quick action chips
          Obx(() => QuickActionsHeader(
            role: controller.role.value,
            onTap: controller.onQuickActionTap,
            onLongPressFilter: controller.onQuickActionLongPress,
          )),

          // Events list with enhanced UI
          Expanded(
            child: Obx(() {
              final groupedEvents = controller.groupedEvents;

              if (groupedEvents.isEmpty) {
                return _buildEnhancedEmptyState();
              }

              return RefreshIndicator(
                onRefresh: () async {
                  // Force refresh by triggering reactive update
                  controller.events.refresh();
                },
                color: AppColors.coral,
                backgroundColor: AppColors.cardBackground,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    8,
                    AppSpacing.screenPadding,
                    AppSpacing.screenPadding,
                  ),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _getTotalItemCount(groupedEvents),
                  itemBuilder: (context, index) {
                    return _buildAnimatedListItem(context, controller, groupedEvents, index);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedHeader(EventsController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Obx(() {
        final todayCount = controller.getTodayEventCount();
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Timeline',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$todayCount events recorded',
                    style: AppTextStyles.captionMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.coral.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.coral.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timeline,
                    color: AppColors.coral,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Live',
                    style: TextStyle(
                      color: AppColors.coral,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEnhancedEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.coral.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.timeline,
                size: 48,
                color: AppColors.coral.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "No events yet",
              style: AppTextStyles.titleLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Start tracking your baby's activities using the quick actions above",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.coral.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.coral.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.touch_app,
                    color: AppColors.coral,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tap any icon above to start',
                    style: TextStyle(
                      color: AppColors.coral,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

  Widget _buildAnimatedListItem(
    BuildContext context,
    EventsController controller,
    Map<String, List<dynamic>> groupedEvents,
    int index,
  ) {
    final item = _buildListItem(context, controller, groupedEvents, index);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.3, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: ModalRoute.of(context)?.animation ?? kAlwaysCompleteAnimation,
          curve: Curves.easeOutCubic,
        )),
        child: FadeTransition(
          opacity: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: ModalRoute.of(context)?.animation ?? kAlwaysCompleteAnimation,
            curve: Curves.easeInOut,
          )),
          child: item,
        ),
      ),
    );
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
        onPlusTap: () => _openCommentSheet(EventKind.sleeping),
      );
    } else if (event is CryEvent) {
      return CryTimelineEntry(
        event: event,
        onTap: () => controller.edit(event),
        onPlusTap: () => _openCommentSheet(EventKind.cry),
      );
    } else if (event is BreastFeedingEvent) {
      return FeedingTimelineEntry(
        event: event,
        onTap: () => controller.edit(event),
        onPlusTap: () => _openCommentSheet(EventKind.feeding),
      );
    } else if (event is EventRecord) {
      final eventKind = controller.getEventKindFromRecord(event);
      return _buildEventRecordWidget(event, eventKind, controller);
    } else if (event is EventModel) {
      return SwipeActions(
        model: event,
        onEdit: () => controller.edit(event),
        onRemove: () => controller.remove(event.id),
        child: TimelineEntry(
          model: event,
          onTap: () => controller.edit(event),
          onPlusTap: () => _openCommentSheet(event.kind), // Always show plus button
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildEventRecordWidget(EventRecord event, EventKind eventKind, EventsController controller) {
    // Create a custom EventModel from EventRecord for display
    final eventModel = EventModel(
      id: event.id,
      childId: event.childId,
      kind: eventKind,
      time: event.startAt,
      endTime: event.endAt,
      title: _getEventRecordTitle(event),
      subtitle: _getEventRecordSubtitle(event),
      comment: event.comment,
      showPlus: true,
    );

    return SwipeActions(
      model: eventModel,
      onEdit: () => controller.edit(event),
      onRemove: () => controller.remove(event.id),
      child: TimelineEntry(
        model: eventModel,
        onTap: () => controller.edit(event),
        onPlusTap: () => _openCommentSheet(eventKind),
      ),
    );
  }

  String _getEventRecordTitle(EventRecord event) {
    switch (event.type) {
      case EventType.feedingBottle:
        final feedType = event.data['feedType'] as String? ?? 'formula';
        final volume = event.data['volume'] as num? ?? 0;
        final unit = event.data['unit'] as String? ?? 'oz';
        return '${feedType == 'formula' ? 'Formula' : 'Breast milk'} • $volume $unit';
      case EventType.diaper:
        final kind = event.data['kind'] as String? ?? 'pee';
        final colors = event.data['color'] as List? ?? [];
        final colorText = colors.isNotEmpty ? ' (${colors.join(', ').toLowerCase()})' : '';
        return '${kind.capitalizeFirst}$colorText';
      case EventType.temperature:
        final temp = event.data['temperature'] as num? ?? 0;
        final unit = event.data['unit'] as String? ?? '°F';
        return 'Temperature • $temp$unit';
      case EventType.weight:
        final weight = event.data['weight'] as num? ?? 0;
        final unit = event.data['unit'] as String? ?? 'lbs';
        return 'Weight • $weight $unit';
      case EventType.height:
        final height = event.data['height'] as num? ?? 0;
        final unit = event.data['unit'] as String? ?? 'in';
        return 'Height • $height $unit';
      default:
        return event.type.name.capitalizeFirst ?? 'Event';
    }
  }

  String _getEventRecordSubtitle(EventRecord event) {
    return 'Baby'; // TODO: Get actual child name
  }

  void _openCommentSheet(EventKind kind) {
    Get.bottomSheet(
      CommentSheet(kind: kind),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }


}
