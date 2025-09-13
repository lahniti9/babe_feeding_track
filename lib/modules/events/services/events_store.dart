import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/event_record.dart';
import '../../children/services/children_store.dart';

class EventsStore extends GetxService {
  final _storage = GetStorage();
  final items = <EventRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadEvents();
  }

  Future<void> add(EventRecord event) async {
    // Validate event before adding
    if (!_validateEvent(event)) {
      return;
    }

    items.insert(0, event);
    await _saveEvents();
  }

  Future<void> update(EventRecord event) async {
    // Validate event before updating
    if (!_validateEvent(event)) {
      return;
    }

    final index = items.indexWhere((e) => e.id == event.id);
    if (index >= 0) {
      items[index] = event;
      await _saveEvents();
    }
  }

  Future<void> remove(String id) async {
    items.removeWhere((e) => e.id == id);
    await _saveEvents();
  }

  List<EventRecord> getByType(EventType type) {
    return items.where((e) => e.type == type).toList();
  }

  List<EventRecord> getByChild(String childId) {
    return items.where((e) => e.childId == childId).toList();
  }

  List<EventRecord> getByDateRange(DateTime start, DateTime end) {
    return items.where((e) =>
      e.startAt.isAfter(start.subtract(const Duration(days: 1))) &&
      e.startAt.isBefore(end.add(const Duration(days: 1)))
    ).toList();
  }

  // Watch events with filtering for statistics
  Stream<List<EventRecord>> watch({
    required String childId,
    Set<EventType>? types,
    DateTime? from,
    DateTime? to,
  }) async* {
    yield* items.stream.map((all) {
      Iterable<EventRecord> it = all;
      it = it.where((e) => e.childId == childId);
      if (types != null) it = it.where((e) => types.contains(e.type));
      if (from != null) it = it.where((e) => !e.startAt.isBefore(from));
      if (to != null) it = it.where((e) => e.startAt.isBefore(to));
      final list = it.toList()..sort((a, b) => a.startAt.compareTo(b.startAt));
      return list;
    });
  }

  void _loadEvents() {
    final eventsData = _storage.read('event_records');
    if (eventsData != null) {
      final eventsList = List<Map<String, dynamic>>.from(eventsData);
      final events = eventsList.map((json) => EventRecord.fromJson(json)).toList();
      
      // Sort by startAt (newest first)
      events.sort((a, b) => b.startAt.compareTo(a.startAt));
      
      items.clear();
      items.addAll(events);
    }
  }

  Future<void> _saveEvents() async {
    final eventsJson = items.map((event) => event.toJson()).toList();
    await _storage.write('event_records', eventsJson);
  }

  // Statistics helpers
  Map<EventType, int> getEventCounts({DateTime? since}) {
    final filteredEvents = since != null 
      ? items.where((e) => e.startAt.isAfter(since))
      : items;
    
    final counts = <EventType, int>{};
    for (final event in filteredEvents) {
      counts[event.type] = (counts[event.type] ?? 0) + 1;
    }
    return counts;
  }

  List<EventRecord> getTodaysEvents() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return items.where((e) => 
      e.startAt.isAfter(startOfDay) && e.startAt.isBefore(endOfDay)
    ).toList();
  }

  // Get latest event of a specific type
  EventRecord? getLatest(EventType type) {
    final typeEvents = getByType(type);
    return typeEvents.isNotEmpty ? typeEvents.first : null;
  }

  // Validate event data before saving
  bool _validateEvent(EventRecord event) {
    // Check if child ID is valid
    final childrenStore = Get.find<ChildrenStore>();
    final child = childrenStore.getChildById(event.childId);

    if (child == null) {
      Get.snackbar(
        'Invalid Child',
        'The selected child no longer exists. Please select a valid child.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // Check if event has required fields
    if (event.id.isEmpty) {
      Get.snackbar(
        'Invalid Event',
        'Event ID is required.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // Check for duplicate event IDs (except during updates)
    final existingEvent = items.firstWhereOrNull((e) => e.id == event.id);
    if (existingEvent != null) {
      // This is an update, which is allowed
      return true;
    }

    // Validate event time is not in the future (with some tolerance)
    final now = DateTime.now();
    final maxFutureTime = now.add(const Duration(minutes: 5)); // Allow 5 minutes tolerance

    if (event.startAt.isAfter(maxFutureTime)) {
      Get.snackbar(
        'Invalid Time',
        'Event time cannot be in the future.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // Validate end time if present
    if (event.endAt != null && event.endAt!.isBefore(event.startAt)) {
      Get.snackbar(
        'Invalid Time Range',
        'End time must be after start time.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }
}
