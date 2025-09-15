import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/event_record.dart';
import '../models/event.dart';
import '../models/sleep_event.dart';
import '../models/cry_event.dart';
import '../models/breast_feeding_event.dart';

/// Adapter that converts legacy event models to EventRecord
/// Provides a bridge during migration from old to new event system
class LegacyEventAdapter extends GetxService {
  final _storage = GetStorage();
  
  // Reactive lists for legacy events
  final _eventModels = <EventModel>[].obs;
  final _sleepEvents = <SleepEvent>[].obs;
  final _cryEvents = <CryEvent>[].obs;
  final _feedingEvents = <BreastFeedingEvent>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadLegacyEvents();
  }

  void _loadLegacyEvents() {
    // Load EventModel events
    final eventsData = _storage.read('events_v2');
    if (eventsData != null) {
      _eventModels.assignAll((eventsData as List)
          .map((event) => EventModel.fromJson(Map<String, dynamic>.from(event)))
          .toList());
    }

    // Load SleepEvent events
    final sleepEventsData = _storage.read('sleep_events');
    if (sleepEventsData != null) {
      _sleepEvents.assignAll((sleepEventsData as List)
          .map((event) => SleepEvent.fromJson(Map<String, dynamic>.from(event)))
          .toList());
    }

    // Load CryEvent events
    final cryEventsData = _storage.read('cry_events');
    if (cryEventsData != null) {
      _cryEvents.assignAll((cryEventsData as List)
          .map((event) => CryEvent.fromJson(Map<String, dynamic>.from(event)))
          .toList());
    }

    // Load BreastFeedingEvent events
    final feedingEventsData = _storage.read('feeding_events');
    if (feedingEventsData != null) {
      _feedingEvents.assignAll((feedingEventsData as List)
          .map((event) => BreastFeedingEvent.fromJson(Map<String, dynamic>.from(event)))
          .toList());
    }
  }

  /// Convert legacy events to EventRecord stream
  Stream<List<EventRecord>> watchAsRecords({
    required String childId,
    Set<EventType>? types,
    DateTime? from,
    DateTime? to,
  }) async* {
    // Create a simple stream that emits when any of the collections change
    final controller = StreamController<List<EventRecord>>.broadcast();

    void emitRecords() {
      final records = <EventRecord>[];

      // Convert EventModel to EventRecord
      for (final event in _eventModels) {
        if (event.childId == childId) {
          final record = _convertEventModelToRecord(event);
          if (_matchesFilters(record, types, from, to)) {
            records.add(record);
          }
        }
      }

      // Convert SleepEvent to EventRecord
      for (final event in _sleepEvents) {
        if (event.childId == childId) {
          final record = _convertSleepEventToRecord(event);
          if (_matchesFilters(record, types, from, to)) {
            records.add(record);
          }
        }
      }

      // Convert CryEvent to EventRecord
      for (final event in _cryEvents) {
        if (event.childId == childId) {
          final record = _convertCryEventToRecord(event);
          if (_matchesFilters(record, types, from, to)) {
            records.add(record);
          }
        }
      }

      // Convert BreastFeedingEvent to EventRecord
      for (final event in _feedingEvents) {
        if (event.childId == childId) {
          final record = _convertFeedingEventToRecord(event);
          if (_matchesFilters(record, types, from, to)) {
            records.add(record);
          }
        }
      }

      // Sort by start time
      records.sort((a, b) => a.startAt.compareTo(b.startAt));
      controller.add(records);
    }

    // Listen to all collections and emit when they change
    final subs = <StreamSubscription>[
      _eventModels.stream.listen((_) => emitRecords()),
      _sleepEvents.stream.listen((_) => emitRecords()),
      _cryEvents.stream.listen((_) => emitRecords()),
      _feedingEvents.stream.listen((_) => emitRecords()),
    ];

    // Emit initial data
    emitRecords();

    // Clean up when stream is cancelled
    controller.onCancel = () {
      for (final sub in subs) {
        sub.cancel();
      }
    };

    yield* controller.stream;
  }

  bool _matchesFilters(
    EventRecord record,
    Set<EventType>? types,
    DateTime? from,
    DateTime? to,
  ) {
    if (types != null && !types.contains(record.type)) return false;
    if (from != null && record.startAt.isBefore(from)) return false;
    if (to != null && !record.startAt.isBefore(to)) return false;
    return true;
  }

  EventRecord _convertEventModelToRecord(EventModel event) {
    // Map EventKind to EventType
    final EventType type;
    switch (event.kind) {
      case EventKind.sleeping:
        type = EventType.sleeping;
        break;
      case EventKind.bedtimeRoutine:
        type = EventType.bedtimeRoutine;
        break;
      case EventKind.bottle:
        type = EventType.feedingBottle;
        break;
      case EventKind.diaper:
        type = EventType.diaper;
        break;
      case EventKind.condition:
        type = EventType.condition;
        break;
      case EventKind.cry:
        type = EventType.cry;
        break;
      case EventKind.feeding:
        type = EventType.feedingBreast;
        break;
      case EventKind.expressing:
        type = EventType.expressing;
        break;
      case EventKind.spitUp:
        type = EventType.spitUp;
        break;
      case EventKind.food:
        type = EventType.food;
        break;
      case EventKind.weight:
        type = EventType.weight;
        break;
      case EventKind.height:
        type = EventType.height;
        break;
      case EventKind.headCircumference:
        type = EventType.headCircumference;
        break;
      case EventKind.medicine:
        type = EventType.medicine;
        break;
      case EventKind.temperature:
        type = EventType.temperature;
        break;
      case EventKind.doctor:
        type = EventType.doctor;
        break;
      case EventKind.bathing:
        type = EventType.bathing;
        break;
      case EventKind.walking:
        type = EventType.walking;
        break;
      case EventKind.activity:
        type = EventType.activity;
        break;
    }

    return EventRecord(
      id: event.id,
      childId: event.childId,
      type: type,
      startAt: event.time,
      endAt: event.endTime,
      data: {
        'title': event.title,
        'subtitle': event.subtitle,
        'tags': event.tags,
      },
      comment: event.comment,
    );
  }

  EventRecord _convertSleepEventToRecord(SleepEvent event) {
    return EventRecord(
      id: event.id,
      childId: event.childId,
      type: EventType.sleeping,
      startAt: event.fellAsleep,
      endAt: event.wokeUp,
      data: const {},
      comment: event.comment,
    );
  }

  EventRecord _convertCryEventToRecord(CryEvent event) {
    return EventRecord(
      id: event.id,
      childId: event.childId,
      type: EventType.cry,
      startAt: event.time,
      data: {
        'sounds': event.sounds.map((s) => s.name).toList(),
        'volume': event.volume.map((v) => v.name).toList(),
        'rhythm': event.rhythm.map((r) => r.name).toList(),
        'duration': event.duration.map((d) => d.name).toList(),
        'behaviour': event.behaviour.map((b) => b.name).toList(),
      },
    );
  }

  EventRecord _convertFeedingEventToRecord(BreastFeedingEvent event) {
    final leftMinutes = event.left.inMinutes;
    final rightMinutes = event.right.inMinutes;
    return EventRecord(
      id: event.id,
      childId: event.childId,
      type: EventType.feedingBreast,
      startAt: event.startAt,
      endAt: event.startAt.add(event.left + event.right),
      data: {
        'leftMinutes': leftMinutes,
        'rightMinutes': rightMinutes,
        'totalMinutes': leftMinutes + rightMinutes,
        'volumeOz': event.volumeOz,
      },
      comment: event.comment,
    );
  }

  /// Get event counts from legacy data
  Map<EventType, int> getEventCounts({
    required String childId,
    DateTime? since,
  }) {
    final counts = <EventType, int>{};
    
    // Count EventModel events
    for (final event in _eventModels) {
      if (event.childId == childId) {
        if (since == null || event.time.isAfter(since)) {
          final record = _convertEventModelToRecord(event);
          counts[record.type] = (counts[record.type] ?? 0) + 1;
        }
      }
    }
    
    // Count SleepEvent events
    for (final event in _sleepEvents) {
      if (event.childId == childId) {
        if (since == null || event.fellAsleep.isAfter(since)) {
          counts[EventType.sleeping] = (counts[EventType.sleeping] ?? 0) + 1;
        }
      }
    }
    
    // Count CryEvent events
    for (final event in _cryEvents) {
      if (event.childId == childId) {
        if (since == null || event.time.isAfter(since)) {
          counts[EventType.cry] = (counts[EventType.cry] ?? 0) + 1;
        }
      }
    }
    
    // Count BreastFeedingEvent events
    for (final event in _feedingEvents) {
      if (event.childId == childId) {
        if (since == null || event.startAt.isAfter(since)) {
          counts[EventType.feedingBreast] = (counts[EventType.feedingBreast] ?? 0) + 1;
        }
      }
    }
    
    return counts;
  }

  /// Remove event from legacy storage
  Future<void> remove(String id) async {
    // Remove from all legacy collections
    _eventModels.removeWhere((e) => e.id == id);
    _sleepEvents.removeWhere((e) => e.id == id);
    _cryEvents.removeWhere((e) => e.id == id);
    _feedingEvents.removeWhere((e) => e.id == id);
    
    // Save updated collections
    await _saveLegacyEvents();
  }

  Future<void> _saveLegacyEvents() async {
    await _storage.write('events_v2', _eventModels.map((e) => e.toJson()).toList());
    await _storage.write('sleep_events', _sleepEvents.map((e) => e.toJson()).toList());
    await _storage.write('cry_events', _cryEvents.map((e) => e.toJson()).toList());
    await _storage.write('feeding_events', _feedingEvents.map((e) => e.toJson()).toList());
  }

  /// Check if adapter has data for a child
  bool hasDataForChild(String childId) {
    return _eventModels.any((e) => e.childId == childId) ||
           _sleepEvents.any((e) => e.childId == childId) ||
           _cryEvents.any((e) => e.childId == childId) ||
           _feedingEvents.any((e) => e.childId == childId);
  }
}
