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
import '../widgets/event_record_timeline_entry.dart';
import '../models/event.dart';
import '../models/sleep_event.dart';
import '../models/cry_event.dart';
import '../models/breast_feeding_event.dart';
import '../models/event_record.dart';

import '../views/comment_sheet.dart';
import '../../children/services/children_store.dart';

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
    return const SizedBox.shrink(); // Remove the entire header
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
        onPlusTap: () => _openCommentSheet(EventKind.sleeping, existingComment: event.comment),
      );
    } else if (event is CryEvent) {
      return CryTimelineEntry(
        event: event,
        onTap: () => controller.edit(event),
        onPlusTap: () => _openCommentSheet(EventKind.cry), // CryEvent doesn't have comment field
      );
    } else if (event is BreastFeedingEvent) {
      return FeedingTimelineEntry(
        event: event,
        onTap: () => controller.edit(event),
        onPlusTap: () => _openCommentSheet(EventKind.feeding, existingComment: event.comment),
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
          onPlusTap: () => _openCommentSheet(event.kind, existingComment: event.comment), // Always show plus button
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildEventRecordWidget(EventRecord event, EventKind eventKind, EventsController controller) {
    return SwipeActions(
      model: EventModel(
        id: event.id,
        childId: event.childId,
        kind: eventKind,
        time: event.startAt,
        endTime: event.endAt,
        title: _getEventRecordTitle(event),
        subtitle: _getEventRecordSubtitle(event),
        comment: event.comment,
        showPlus: true,
      ),
      onEdit: () => controller.edit(event),
      onRemove: () => controller.remove(event.id),
      child: EventRecordTimelineEntry(
        event: event,
        onTap: () => controller.edit(event),
        onPlusTap: () => _openCommentSheet(eventKind, existingComment: event.comment),
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
        final consistency = event.data['consistency'] as List? ?? [];
        String details = '';
        if (colors.isNotEmpty) {
          details += ' (${colors.join(', ').toLowerCase()}';
          if (consistency.isNotEmpty) {
            details += ', ${consistency.join(', ').toLowerCase()}';
          }
          details += ')';
        } else if (consistency.isNotEmpty) {
          details += ' (${consistency.join(', ').toLowerCase()})';
        }
        return '${kind.capitalizeFirst}$details';
      case EventType.condition:
        final moods = event.data['moods'] as List? ?? [];
        final severity = event.data['severity'] as String? ?? 'mild';
        if (moods.isNotEmpty) {
          return '${moods.join(', ').toLowerCase().capitalizeFirst} • $severity';
        }
        return 'Condition • $severity';
      case EventType.temperature:
        final value = event.data['value'] as num? ?? 0;
        final unit = event.data['unit'] as String? ?? '°F';
        final method = event.data['method'] as List? ?? [];
        final condition = event.data['condition'] as List? ?? [];
        String title = 'Temperature • $value$unit';
        if (method.isNotEmpty) title += ' • ${method.join(', ').toLowerCase()}';
        if (condition.isNotEmpty) title += ' • ${condition.join(', ').toLowerCase()}';
        return title;
      case EventType.weight:
        final pounds = event.data['pounds'] as num? ?? 0;
        final ounces = event.data['ounces'] as num? ?? 0;
        final unit = event.data['unit'] as String? ?? 'lb/oz';
        if (pounds > 0 || ounces > 0) {
          return 'Weight • ${pounds}lb ${ounces}oz';
        }
        final value = event.data['value'] as num? ?? 0;
        return 'Weight • $value $unit';
      case EventType.height:
        final valueCm = event.data['valueCm'] as num? ?? 0;
        final unit = event.data['unit'] as String? ?? 'cm';
        return 'Height • $valueCm $unit';
      case EventType.headCircumference:
        final valueCm = event.data['valueCm'] as num? ?? 0;
        final unit = event.data['unit'] as String? ?? 'cm';
        return 'Head circumference • $valueCm $unit';
      case EventType.medicine:
        final name = event.data['name'] as String? ?? 'Medicine';
        final dose = event.data['dose'] as num? ?? 0;
        final unit = event.data['unit'] as String? ?? '';
        final reason = event.data['reason'] as List? ?? [];
        String title = name;
        if (dose > 0) title += ' • $dose $unit';
        if (reason.isNotEmpty) title += ' • ${reason.join(', ').toLowerCase()}';
        return title;
      case EventType.expressing:
        final volume = event.data['volume'] as num? ?? 0;
        final unit = event.data['unit'] as String? ?? 'ml';
        final method = event.data['method'] as String? ?? 'pump';
        final side = event.data['side'] as String? ?? '';
        final seconds = event.data['seconds'] as num? ?? 0;
        String title = 'Expressed $volume $unit';
        if (method.isNotEmpty) title += ' • $method';
        if (side.isNotEmpty) title += ' • $side side';
        if (seconds > 0) {
          final minutes = (seconds / 60).round();
          title += ' • ${minutes}min';
        }
        return title;
      case EventType.spitUp:
        final amount = event.data['amount'] as String? ?? 'small';
        final timing = event.data['timing'] as String? ?? '';
        return timing.isNotEmpty ? 'Spit up ($amount) • $timing' : 'Spit up ($amount)';
      case EventType.food:
        final food = event.data['food'] as String? ?? 'Food';
        final amount = event.data['amount'] as String? ?? '';
        final reaction = event.data['reaction'] as List? ?? [];
        String title = food;
        if (amount.isNotEmpty) title += ' • ${amount.replaceAll('_', ' ')}';
        if (reaction.isNotEmpty) title += ' • ${reaction.join(', ').toLowerCase()}';
        return title;
      case EventType.doctor:
        final reason = event.data['reason'] as List? ?? [];
        final outcome = event.data['outcome'] as List? ?? [];
        String title = 'Doctor visit';
        if (reason.isNotEmpty) title += ' • ${reason.join(', ').toLowerCase()}';
        if (outcome.isNotEmpty) title += ' • ${outcome.join(', ').toLowerCase()}';
        return title;
      case EventType.bathing:
        final seconds = event.data['seconds'] as num? ?? 0;
        final aids = event.data['aids'] as List? ?? [];
        final mood = event.data['mood'] as List? ?? [];
        String title = 'Bath';
        if (seconds > 0) {
          final minutes = (seconds / 60).round();
          title += ' • ${minutes}min';
        }
        if (aids.isNotEmpty) title += ' • ${aids.join(', ').toLowerCase()}';
        if (mood.isNotEmpty) title += ' • ${mood.join(', ').toLowerCase()}';
        return title;
      case EventType.walking:
        final seconds = event.data['seconds'] as num? ?? 0;
        final mode = event.data['mode'] as List? ?? [];
        final place = event.data['place'] as List? ?? [];
        String title = 'Walk';
        if (seconds > 0) {
          final minutes = (seconds / 60).round();
          title += ' • ${minutes}min';
        }
        if (mode.isNotEmpty) title += ' • ${mode.join(', ').toLowerCase()}';
        if (place.isNotEmpty) title += ' • ${place.join(', ').toLowerCase()}';
        return title;
      case EventType.activity:
        final activityType = event.data['type'] as String? ?? 'play';
        final seconds = event.data['seconds'] as num? ?? 0;
        final intensity = event.data['intensity'] as String? ?? '';
        String title = activityType.capitalizeFirst ?? activityType;
        if (seconds > 0) {
          final minutes = (seconds / 60).round();
          title += ' • ${minutes}min';
        }
        if (intensity.isNotEmpty) title += ' • $intensity intensity';
        return title;
      case EventType.cry:
        final sounds = event.data['sounds'] as List? ?? [];
        final volume = event.data['volume'] as List? ?? [];
        String title = 'Crying';
        if (sounds.isNotEmpty) title += ' • ${sounds.join(', ').toLowerCase()}';
        if (volume.isNotEmpty) title += ' • ${volume.join(', ').toLowerCase()}';
        return title;
      default:
        return event.type.name.capitalizeFirst ?? 'Event';
    }
  }

  String _getEventRecordSubtitle(EventRecord event) {
    try {
      final childrenStore = Get.find<ChildrenStore>();
      final child = childrenStore.getChildById(event.childId);
      final childName = child?.name ?? 'Baby';

      // Add additional details for some event types
      switch (event.type) {
        case EventType.medicine:
          final frequency = event.data['frequency'] as String? ?? '';
          return frequency.isNotEmpty ? '$childName • $frequency' : childName;
        case EventType.condition:
          final note = event.data['note'] as String? ?? '';
          return note.isNotEmpty ? '$childName • ${note.length > 20 ? '${note.substring(0, 20)}...' : note}' : childName;
        case EventType.doctor:
          final reason = event.data['reason'] as String? ?? '';
          return reason.isNotEmpty ? '$childName • $reason' : childName;
        default:
          return childName;
      }
    } catch (e) {
      return 'Baby';
    }
  }

  void _openCommentSheet(EventKind kind, {String? existingComment}) {
    Get.bottomSheet(
      CommentSheet(
        kind: kind,
        existingComment: existingComment,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }


}
