import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/event.dart';
import '../views/sleep_entry_view.dart';
import '../views/sleep_exact_view.dart';
import '../views/bedtime_routine_view.dart';
import '../views/bottle_entry_view.dart';
import '../views/comment_sheet.dart';
import '../models/sleep_event.dart';
import 'bedtime_routine_controller.dart';
import 'bottle_entry_controller.dart';

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

  @override
  void onInit() {
    super.onInit();
    // Initialize events list with explicit dynamic typing
    events = <dynamic>[].obs;
    _loadEvents();
  }

  // Get filtered events
  List<dynamic> get filtered {
    var filteredEvents = events.toList();

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
    return EventKind.activity; // fallback
  }

  // Helper to get event time from mixed types
  DateTime _getEventTime(dynamic event) {
    if (event is EventModel) return event.time;
    if (event is SleepEvent) return event.wokeUp;
    return DateTime.now(); // fallback
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

  // Load events from storage
  void _loadEvents() {
    final eventsData = _storage.read('events_v2');
    final sleepEventsData = _storage.read('sleep_events');

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

    // Recreate the events list to ensure correct typing
    events.clear();
    events.addAll(allEvents);
  }

  // Save events to storage
  void _saveEvents() {
    final eventModels = events.whereType<EventModel>().toList();
    final sleepEvents = events.whereType<SleepEvent>().toList();

    // Save EventModel events to the main storage
    _storage.write('events_v2', eventModels.map((event) => event.toJson()).toList());

    // Save SleepEvent events to separate storage (if any)
    if (sleepEvents.isNotEmpty) {
      _storage.write('sleep_events', sleepEvents.map((event) => event.toJson()).toList());
    }
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

  // Remove event by id
  void remove(String id) {
    events.removeWhere((e) =>
      (e is EventModel && e.id == id) ||
      (e is SleepEvent && e.id == id)
    );
    _saveEvents();
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
        default:
          // For other types, just show a simple edit dialog
          break;
      }
    }
  }
  // Add comment to last event of specific kind
  void addCommentToLast(EventKind kind, String text) {
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
          tags: [...event.tags, text],
        );
        events[idx] = updatedEvent;
        _saveEvents();
        // Trigger UI update
        events.refresh();
      } else if (event is SleepEvent && kind == EventKind.sleeping) {
        final updatedEvent = event.copyWith(
          comment: event.comment != null
              ? '${event.comment}\n$text'
              : text,
        );
        events[idx] = updatedEvent;
        _saveEvents();
        // Trigger UI update
        events.refresh();
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
        Get.put(BottleEntryController());
        Get.bottomSheet(
          const BottleEntryView(),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
        break;
      case EventKind.diaper:
        _quickAddEvent(kind, 'Diaper change');
        break;
      case EventKind.condition:
        Get.bottomSheet(
          CommentSheet(kind: kind),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
        break;
      case EventKind.cry:
        _quickAddEvent(kind, 'Crying');
        break;
      case EventKind.expressing:
        _quickAddEvent(kind, 'Expressing');
        break;
      case EventKind.spitUp:
        _quickAddEvent(kind, 'Spit-up');
        break;
      case EventKind.food:
        _quickAddEvent(kind, 'Food');
        break;
      case EventKind.weight:
        _quickAddEvent(kind, 'Weight measurement');
        break;
      case EventKind.height:
        _quickAddEvent(kind, 'Height measurement');
        break;
      case EventKind.headCircumference:
        _quickAddEvent(kind, 'Head circumference');
        break;
      case EventKind.medicine:
        _quickAddEvent(kind, 'Medicine');
        break;
      case EventKind.temperature:
        _quickAddEvent(kind, 'Temperature');
        break;
      case EventKind.doctor:
        _quickAddEvent(kind, 'Doctor visit');
        break;
      case EventKind.bathing:
        _quickAddEvent(kind, 'Bath time');
        break;
      case EventKind.walking:
        _quickAddEvent(kind, 'Walking');
        break;
      case EventKind.activity:
        _quickAddEvent(kind, 'Activity');
        break;
    }
  }

  // Long-press on a chip filters the timeline to that kind
  void onQuickActionLongPress(EventKind kind) {
    activeFilter.value = activeFilter.value == kind ? null : kind;
  }

  // Generate unique ID for new events
  String _generateId() {
    return 'event_${DateTime.now().millisecondsSinceEpoch}';
  }

  // Quick add helper for simple events
  void _quickAddEvent(EventKind kind, String title) {
    final event = EventModel(
      id: _generateId(),
      kind: kind,
      time: DateTime.now(),
      title: title,
      subtitle: 'Quick added',
      showPlus: true,
    );
    addEvent(event);
  }


}
