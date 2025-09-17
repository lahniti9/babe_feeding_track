import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text.dart';
import '../models/event.dart';
import '../views/sleep_entry_view.dart';
import '../views/sleep_exact_view.dart';
import '../views/bedtime_routine_view.dart';
import '../views/bottle_entry_view.dart';

import '../views/cry_sheet.dart';
import '../models/sleep_event.dart';
import '../models/cry_event.dart';
import '../models/breast_feeding_event.dart';
import '../models/event_record.dart';
import '../services/events_store.dart';
import '../services/event_router.dart';
import 'bedtime_routine_controller.dart';
import 'bottle_entry_controller.dart';
import '../../children/services/children_store.dart';

class EventsController extends GetxController {
  final _storage = GetStorage();
  
  // Events list (mix of EventModel and SleepEvent)
  late final RxList<dynamic> events;
  
  // Active filter chips
  final RxSet<EventKind> filter = <EventKind>{}.obs;

  // User role for filtering quick actions
  final Rx<UserRole> role = UserRole.mom.obs; // set from profile/onboarding

  // Active filter for long-press functionality
  final Rxn<EventKind> activeFilter = Rxn<EventKind>();
  
  // Loading state
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // EventsStore reference
  late EventsStore _eventsStore;

  @override
  void onInit() {
    super.onInit();
    // Initialize events list with explicit dynamic typing
    events = <dynamic>[].obs;
    _eventsStore = Get.find<EventsStore>();
    _loadEvents();

    // Listen to EventsStore changes
    ever(_eventsStore.items, (_) => _loadEvents());

    // Clean up orphaned events and check data consistency on initialization
    _cleanupOrphanedEvents();
    _checkDataConsistency();
  }

  // Get filtered events for active child
  List<dynamic> get filtered {
    final childrenStore = Get.find<ChildrenStore>();
    final activeChildId = childrenStore.getValidActiveChildId();

    var filteredEvents = events.where((event) {
      // Filter by active child - handle all event types
      if (activeChildId != null) {
        String? eventChildId;

        if (event is EventModel) {
          eventChildId = event.childId;
        } else if (event is SleepEvent) {
          eventChildId = event.childId;
        } else if (event is CryEvent) {
          eventChildId = event.childId;
        } else if (event is BreastFeedingEvent) {
          eventChildId = event.childId;
        } else if (event is EventRecord) {
          eventChildId = event.childId;
        }

        // If we couldn't determine the child ID or it doesn't match, filter it out
        if (eventChildId == null || eventChildId != activeChildId) {
          return false;
        }
      }
      return true;
    }).toList();

    // Apply active filter from long-press
    if (activeFilter.value != null) {
      filteredEvents = filteredEvents.where((e) => _getEventKind(e) == activeFilter.value).toList();
    }

    // Apply multi-select filter
    if (filter.isNotEmpty) {
      filteredEvents = filteredEvents.where((e) => filter.contains(_getEventKind(e))).toList();
    }

    return filteredEvents..sort((a, b) => _getEventTime(b).compareTo(_getEventTime(a)));
  }

  // Helper to get event kind from mixed types
  EventKind _getEventKind(dynamic event) {
    if (event is EventModel) return event.kind;
    if (event is SleepEvent) return EventKind.sleeping;
    if (event is CryEvent) return EventKind.cry;
    if (event is BreastFeedingEvent) return EventKind.feeding;
    if (event is EventRecord) {
      // Map EventRecord types to EventKind
      switch (event.type) {
        case EventType.sleeping:
          return EventKind.sleeping;
        case EventType.bedtimeRoutine:
          return EventKind.bedtimeRoutine;
        case EventType.cry:
          return EventKind.cry;
        case EventType.feedingBreast:
          return EventKind.feeding;
        case EventType.feedingBottle:
          return EventKind.bottle;
        case EventType.food:
          return EventKind.food;
        case EventType.diaper:
          return EventKind.diaper;
        case EventType.condition:
          return EventKind.condition;
        case EventType.medicine:
          return EventKind.medicine;
        case EventType.temperature:
          return EventKind.temperature;
        case EventType.doctor:
          return EventKind.doctor;
        case EventType.bathing:
          return EventKind.bathing;
        case EventType.walking:
          return EventKind.walking;
        case EventType.activity:
          return EventKind.activity;
        case EventType.weight:
          return EventKind.weight;
        case EventType.height:
          return EventKind.height;
        case EventType.headCircumference:
          return EventKind.headCircumference;
        case EventType.expressing:
          return EventKind.expressing;
        case EventType.spitUp:
          return EventKind.spitUp;
      }
    }
    return EventKind.activity; // fallback
  }

  // Helper to get event time from mixed types
  DateTime _getEventTime(dynamic event) {
    if (event is EventModel) return event.time;
    if (event is SleepEvent) return event.wokeUp;
    if (event is CryEvent) return event.time;
    if (event is BreastFeedingEvent) return event.startAt;
    if (event is EventRecord) return event.startAt;
    return DateTime.now(); // fallback
  }

  // Public method to get EventKind from EventRecord
  EventKind getEventKindFromRecord(EventRecord event) {
    return _getEventKind(event);
  }

  // Group events by date for display
  Map<String, List<dynamic>> get groupedEvents {
    final Map<String, List<dynamic>> grouped = {};
    final now = DateTime.now();

    for (final event in filtered) {
      final eventTime = _getEventTime(event);
      final eventDate = DateTime(eventTime.year, eventTime.month, eventTime.day);
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));

      String key;
      if (eventDate == today) {
        key = 'Today';
      } else if (eventDate == yesterday) {
        key = 'Yesterday';
      } else {
        key = '${eventTime.day}/${eventTime.month}/${eventTime.year}';
      }

      grouped[key] ??= [];
      grouped[key]!.add(event);
    }

    return grouped;
  }

  int getTodayEventCount() {
    final todayEvents = groupedEvents['Today'] ?? [];
    return todayEvents.length;
  }

  // Load events from storage
  void _loadEvents() {
    final eventsData = _storage.read('events_v2');
    final sleepEventsData = _storage.read('sleep_events');
    final cryEventsData = _storage.read('cry_events');
    final feedingEventsData = _storage.read('feeding_events');

    List<dynamic> allEvents = <dynamic>[];

    // Load legacy EventModel events
    if (eventsData != null) {
      allEvents.addAll((eventsData as List)
          .map((event) => EventModel.fromJson(Map<String, dynamic>.from(event)))
          .toList());
    }

    // Load SleepEvent events
    if (sleepEventsData != null) {
      allEvents.addAll((sleepEventsData as List)
          .map((event) => SleepEvent.fromJson(Map<String, dynamic>.from(event)))
          .toList());
    }

    // Load CryEvent events
    if (cryEventsData != null) {
      allEvents.addAll((cryEventsData as List)
          .map((event) => CryEvent.fromJson(Map<String, dynamic>.from(event)))
          .toList());
    }

    // Load BreastFeedingEvent events
    if (feedingEventsData != null) {
      allEvents.addAll((feedingEventsData as List)
          .map((event) => BreastFeedingEvent.fromJson(Map<String, dynamic>.from(event)))
          .toList());
    }

    // Load EventRecord events from EventsStore
    allEvents.addAll(_eventsStore.items);

    // Sort by timestamp (newest first)
    allEvents.sort((a, b) {
      DateTime aTime;
      DateTime bTime;

      if (a is EventModel) {
        aTime = a.time;
      } else if (a is SleepEvent) {
        aTime = a.wokeUp;
      } else if (a is CryEvent) {
        aTime = a.time;
      } else if (a is BreastFeedingEvent) {
        aTime = a.startAt;
      } else if (a is EventRecord) {
        aTime = a.startAt;
      } else {
        aTime = DateTime.now();
      }

      if (b is EventModel) {
        bTime = b.time;
      } else if (b is SleepEvent) {
        bTime = b.wokeUp;
      } else if (b is CryEvent) {
        bTime = b.time;
      } else if (b is BreastFeedingEvent) {
        bTime = b.startAt;
      } else if (b is EventRecord) {
        bTime = b.startAt;
      } else {
        bTime = DateTime.now();
      }

      return bTime.compareTo(aTime);
    });

    // Recreate the events list to ensure correct typing
    events.clear();
    events.addAll(allEvents);
  }

  // Save events to storage
  void _saveEvents() {
    final eventModels = events.whereType<EventModel>().toList();
    final sleepEvents = events.whereType<SleepEvent>().toList();
    final cryEvents = events.whereType<CryEvent>().toList();
    final feedingEvents = events.whereType<BreastFeedingEvent>().toList();

    // Save EventModel events to the main storage
    _storage.write('events_v2', eventModels.map((event) => event.toJson()).toList());

    // Save SleepEvent events to separate storage
    _storage.write('sleep_events', sleepEvents.map((event) => event.toJson()).toList());

    // Save CryEvent events to separate storage
    _storage.write('cry_events', cryEvents.map((event) => event.toJson()).toList());

    // Save BreastFeedingEvent events to separate storage
    _storage.write('feeding_events', feedingEvents.map((event) => event.toJson()).toList());
  }

  // Add new event
  void addEvent(EventModel event) {
    events.insert(0, event); // Add to beginning (newest first)
    _saveEvents();
  }

  // Upsert sleep event
  void upsertSleep(SleepEvent sleepEvent) {
    final index = events.indexWhere((e) => e is SleepEvent && e.id == sleepEvent.id);
    if (index >= 0) {
      events[index] = sleepEvent;
    } else {
      // Create a new list with the sleep event and existing events
      final newEvents = <dynamic>[sleepEvent, ...events];
      events.clear();
      events.addAll(newEvents);
    }
    _saveEvents();
  }

  // Add cry event
  void addCryEvent(CryEvent cryEvent) {
    final newEvents = <dynamic>[cryEvent, ...events];
    events.clear();
    events.addAll(newEvents);
    _saveEvents();
  }

  // Add feeding event
  void addFeedingEvent(BreastFeedingEvent feedingEvent) {
    final newEvents = <dynamic>[feedingEvent, ...events];
    events.clear();
    events.addAll(newEvents);
    _saveEvents();
  }

  // Remove event by id with confirmation
  void remove(String id, {bool skipConfirmation = false}) {
    if (skipConfirmation) {
      _performRemove(id, showSuccessMessage: false);
      return;
    }

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          'Delete Event',
          style: AppTextStyles.h3.copyWith(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete this event? This action cannot be undone.',
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              _performRemove(id);
            },
            child: Text(
              'Delete',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  // Perform the actual removal
  void _performRemove(String id, {bool showSuccessMessage = true}) {
    // Remove from legacy events list
    events.removeWhere((e) =>
      (e is EventModel && e.id == id) ||
      (e is SleepEvent && e.id == id) ||
      (e is CryEvent && e.id == id) ||
      (e is BreastFeedingEvent && e.id == id)
    );

    // Also remove from EventsStore if it's an EventRecord
    try {
      final eventsStore = Get.find<EventsStore>();
      final eventRecord = eventsStore.items.firstWhereOrNull((e) => e.id == id);
      if (eventRecord != null) {
        eventsStore.remove(id);
      }
    } catch (e) {
      // EventsStore might not be available in test environment
      debugPrint('EventsStore not available: $e');
    }

    _saveEvents();

    // Show success message only if requested and not in test mode
    if (showSuccessMessage && Get.context != null) {
      Get.snackbar(
        'Event Deleted',
        'The event has been successfully deleted.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Edit event (opens appropriate sheet)
  void edit(dynamic event) {
    if (event is SleepEvent) {
      // For sleep events, open the new sleep exact view
      Get.bottomSheet(
        SleepExactView(childId: event.childId, initial: event),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      );
      return;
    }

    if (event is CryEvent) {
      // For cry events, open the cry sheet
      EventRouter.openEventSheet(EventType.cry);
      return;
    }

    if (event is BreastFeedingEvent) {
      // For breast feeding events, open the feeding sheet
      EventRouter.openEventSheet(EventType.feedingBreast);
      return;
    }

    if (event is EventRecord) {
      // For EventRecord, use EventRouter to open the appropriate sheet with existing data
      EventRouter.openEventSheet(event.type, existingEvent: event);
      return;
    }

    if (event is EventModel) {
      switch (event.kind) {
        case EventKind.sleeping:
          // For legacy sleep events from timeline, open SleepExactView
          Get.bottomSheet(
            const SleepExactView(childId: 'child_1'), // Convert to new format
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          );
          break;
        case EventKind.bedtimeRoutine:
          Get.find<BedtimeRoutineController>().editEvent(event);
          Get.bottomSheet(
            const BedtimeRoutineView(),
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          );
          break;
        case EventKind.bottle:
          Get.find<BottleEntryController>().editEvent(event);
          Get.bottomSheet(
            const BottleEntryView(),
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          );
          break;
        case EventKind.cry:
          EventRouter.openEventSheet(EventType.cry);
          break;
        case EventKind.feeding:
          EventRouter.openEventSheet(EventType.feedingBreast);
          break;
        case EventKind.diaper:
          EventRouter.openEventSheet(EventType.diaper);
          break;
        case EventKind.condition:
          EventRouter.openEventSheet(EventType.condition);
          break;
        case EventKind.expressing:
          EventRouter.openEventSheet(EventType.expressing);
          break;
        case EventKind.spitUp:
          EventRouter.openEventSheet(EventType.spitUp);
          break;
        case EventKind.food:
          EventRouter.openEventSheet(EventType.food);
          break;
        case EventKind.weight:
          EventRouter.openEventSheet(EventType.weight);
          break;
        case EventKind.height:
          EventRouter.openEventSheet(EventType.height);
          break;
        case EventKind.headCircumference:
          EventRouter.openEventSheet(EventType.headCircumference);
          break;
        case EventKind.medicine:
          EventRouter.openEventSheet(EventType.medicine);
          break;
        case EventKind.temperature:
          EventRouter.openEventSheet(EventType.temperature);
          break;
        case EventKind.doctor:
          EventRouter.openEventSheet(EventType.doctor);
          break;
        case EventKind.bathing:
          EventRouter.openEventSheet(EventType.bathing);
          break;
        case EventKind.walking:
          EventRouter.openEventSheet(EventType.walking);
          break;
        case EventKind.activity:
          EventRouter.openEventSheet(EventType.activity);
          break;
      }
    }
  }
  // Add comment to last event of specific kind
  Future<void> addCommentToLast(EventKind kind, String text) async {

    // Find the most recent event of the specified kind
    // Since events are sorted newest first, we want the first match
    int idx = -1;
    for (int i = 0; i < events.length; i++) {
      final event = events[i];
      bool matches = false;

      if (event is EventModel && event.kind == kind) {
        matches = true;
      } else if (event is SleepEvent && kind == EventKind.sleeping) {
        matches = true;
      } else if (event is CryEvent && kind == EventKind.cry) {
        matches = true;
      } else if (event is BreastFeedingEvent && kind == EventKind.feeding) {
        matches = true;
      } else if (event is EventRecord && _getEventKind(event) == kind) {
        matches = true;
      }

      if (matches) {
        idx = i;

        break; // Found the most recent event of this kind
      }
    }

    if (idx != -1) {
      final event = events[idx];

      if (event is EventModel) {
        final updatedEvent = event.copyWith(
          comment: text.isEmpty ? null : text, // Set to null if empty (deletion)
        );
        events[idx] = updatedEvent;
        _saveEvents();
        // Trigger UI update
        events.refresh();
      } else if (event is SleepEvent && kind == EventKind.sleeping) {
        final updatedEvent = event.copyWith(
          comment: text.isEmpty ? null : text, // Set to null if empty (deletion)
        );
        events[idx] = updatedEvent;
        _saveEvents();
        // Trigger UI update
        events.refresh();
      } else if (event is CryEvent && kind == EventKind.cry) {
        final updatedEvent = event.copyWith(
          comment: text.isEmpty ? null : text, // Set to null if empty (deletion)
        );
        events[idx] = updatedEvent;
        _saveEvents();
        // Trigger UI update
        events.refresh();
      } else if (event is BreastFeedingEvent && kind == EventKind.feeding) {
        final updatedEvent = event.copyWith(
          comment: text.isEmpty ? null : text, // Set to null if empty (deletion)
        );
        events[idx] = updatedEvent;
        _saveEvents();
        // Trigger UI update
        events.refresh();
      } else if (event is EventRecord) {
        // Update EventRecord comment via EventsStore
        final updatedEvent = event.copyWith(
          comment: text.isEmpty ? null : text, // Set to null if empty (deletion)
        );
        await _eventsStore.update(updatedEvent);

        // Also update the event in the local events list to ensure immediate UI update
        events[idx] = updatedEvent;
        events.refresh();

        // Show success message
        Get.snackbar(
          text.isEmpty ? 'Comment Deleted' : 'Comment Added',
          text.isEmpty ? 'Comment has been removed from the event.' : 'Comment has been added to the event.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.coral.withValues(alpha: 0.9),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  // Toggle filter
  void toggleFilter(EventKind kind) {
    if (filter.contains(kind)) {
      filter.remove(kind);
    } else {
      filter.add(kind);
    }
  }

  // Clear all filters
  void clearFilters() {
    filter.clear();
  }

  // Quick action tap handler - routes to appropriate sheet
  void onQuickActionTap(EventKind kind) {
    switch (kind) {
      case EventKind.sleeping:
        // Open original sleep timer view for header chip
        Get.bottomSheet(
          const SleepEntryView(),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
        break;
      case EventKind.bedtimeRoutine:
        Get.put(BedtimeRoutineController());
        Get.bottomSheet(
          const BedtimeRoutineView(),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
        break;
      case EventKind.bottle:
        EventRouter.openEventSheet(EventType.feedingBottle);
        break;
      case EventKind.diaper:
        EventRouter.openEventSheet(EventType.diaper);
        break;
      case EventKind.condition:
        EventRouter.openEventSheet(EventType.condition);
        break;
      case EventKind.cry:
        Get.bottomSheet(
          const CrySheet(),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
        break;
      case EventKind.feeding:
        EventRouter.openEventSheet(EventType.feedingBreast);
        break;
      case EventKind.expressing:
        EventRouter.openEventSheet(EventType.expressing);
        break;
      case EventKind.spitUp:
        EventRouter.openEventSheet(EventType.spitUp);
        break;
      case EventKind.food:
        EventRouter.openEventSheet(EventType.food);
        break;
      case EventKind.weight:
        EventRouter.openEventSheet(EventType.weight);
        break;
      case EventKind.height:
        EventRouter.openEventSheet(EventType.height);
        break;
      case EventKind.headCircumference:
        EventRouter.openEventSheet(EventType.headCircumference);
        break;
      case EventKind.medicine:
        EventRouter.openEventSheet(EventType.medicine);
        break;
      case EventKind.temperature:
        EventRouter.openEventSheet(EventType.temperature);
        break;
      case EventKind.doctor:
        EventRouter.openEventSheet(EventType.doctor);
        break;
      case EventKind.bathing:
        EventRouter.openEventSheet(EventType.bathing);
        break;
      case EventKind.walking:
        EventRouter.openEventSheet(EventType.walking);
        break;
      case EventKind.activity:
        EventRouter.openEventSheet(EventType.activity);
        break;
    }
  }

  // Long-press on a chip filters the timeline to that kind
  void onQuickActionLongPress(EventKind kind) {
    activeFilter.value = activeFilter.value == kind ? null : kind;
  }

  // Clean up events that belong to deleted children
  void _cleanupOrphanedEvents() {
    final childrenStore = Get.find<ChildrenStore>();
    final validChildIds = childrenStore.children.map((c) => c.id).toSet();

    // Remove events from the main events list that belong to deleted children
    final eventsToRemove = <dynamic>[];

    for (final event in events) {
      String? eventChildId;

      if (event is EventModel) {
        eventChildId = event.childId;
      } else if (event is SleepEvent) {
        eventChildId = event.childId;
      } else if (event is CryEvent) {
        eventChildId = event.childId;
      } else if (event is BreastFeedingEvent) {
        eventChildId = event.childId;
      }

      if (eventChildId != null && !validChildIds.contains(eventChildId)) {
        eventsToRemove.add(event);
      }
    }

    // Remove orphaned events
    for (final event in eventsToRemove) {
      events.remove(event);
    }

    // Also clean up EventRecord events in the EventsStore
    final orphanedEventRecords = _eventsStore.items
        .where((event) => !validChildIds.contains(event.childId))
        .toList();

    for (final event in orphanedEventRecords) {
      _eventsStore.remove(event.id);
    }

    if (eventsToRemove.isNotEmpty || orphanedEventRecords.isNotEmpty) {
      _saveEvents();
      // Log cleanup for debugging
      debugPrint('Cleaned up ${eventsToRemove.length + orphanedEventRecords.length} orphaned events');
    }
  }

  // Check data consistency across different storage systems
  void _checkDataConsistency() {
    final childrenStore = Get.find<ChildrenStore>();

    // Check if active child still exists
    final activeChildId = childrenStore.activeId.value;
    if (activeChildId != null) {
      final activeChild = childrenStore.getChildById(activeChildId);
      if (activeChild == null && childrenStore.children.isNotEmpty) {
        // Active child was deleted, set to first available child
        childrenStore.setActive(childrenStore.children.first.id);
        debugPrint('Reset active child to first available child');
      }
    }

    // Check for duplicate event IDs across different storage systems
    final allEventIds = <String>{};
    final duplicateIds = <String>[];

    // Check events in main events list
    for (final event in events) {
      String? eventId;

      if (event is EventModel) {
        eventId = event.id;
      } else if (event is SleepEvent) {
        eventId = event.id;
      } else if (event is CryEvent) {
        eventId = event.id;
      } else if (event is BreastFeedingEvent) {
        eventId = event.id;
      }

      if (eventId != null) {
        if (allEventIds.contains(eventId)) {
          duplicateIds.add(eventId);
        } else {
          allEventIds.add(eventId);
        }
      }
    }

    // Check events in EventsStore
    for (final event in _eventsStore.items) {
      if (allEventIds.contains(event.id)) {
        duplicateIds.add(event.id);
      } else {
        allEventIds.add(event.id);
      }
    }

    if (duplicateIds.isNotEmpty) {
      debugPrint('Found ${duplicateIds.length} duplicate event IDs: $duplicateIds');
      // Could implement deduplication logic here if needed
    }

    // Validate event time consistency
    _validateEventTimes();
  }

  // Validate that event times are reasonable
  void _validateEventTimes() {
    final now = DateTime.now();
    final oneYearAgo = now.subtract(const Duration(days: 365));
    final oneHourFromNow = now.add(const Duration(hours: 1));

    var invalidTimeEvents = 0;

    // Check events in main list
    for (final event in events) {
      DateTime? eventTime;

      if (event is EventModel) {
        eventTime = event.time;
      } else if (event is SleepEvent) {
        eventTime = event.fellAsleep;
      } else if (event is CryEvent) {
        eventTime = event.time;
      } else if (event is BreastFeedingEvent) {
        eventTime = event.startAt;
      }

      if (eventTime != null) {
        if (eventTime.isBefore(oneYearAgo) || eventTime.isAfter(oneHourFromNow)) {
          invalidTimeEvents++;
        }
      }
    }

    // Check EventRecord events
    for (final event in _eventsStore.items) {
      if (event.startAt.isBefore(oneYearAgo) || event.startAt.isAfter(oneHourFromNow)) {
        invalidTimeEvents++;
      }
    }

    if (invalidTimeEvents > 0) {
      debugPrint('Found $invalidTimeEvents events with potentially invalid times');
    }
  }

}
