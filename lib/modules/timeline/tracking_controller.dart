import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/models/models.dart';

class TrackingController extends GetxController {
  final _storage = GetStorage();
  
  // Events list
  final _events = <Event>[].obs;
  List<Event> get events => _events;
  
  // Current event being created
  final _currentEventType = Rx<EventType?>(null);
  final _currentEventTime = DateTime.now().obs;
  final _currentEventDetail = <String, dynamic>{}.obs;
  final _currentEventNotes = ''.obs;
  
  EventType? get currentEventType => _currentEventType.value;
  DateTime get currentEventTime => _currentEventTime.value;
  Map<String, dynamic> get currentEventDetail => _currentEventDetail;
  String get currentEventNotes => _currentEventNotes.value;
  
  // Loading state
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  
  @override
  void onInit() {
    super.onInit();
    _loadEvents();
  }
  
  // Load events from storage
  void _loadEvents() {
    final eventsData = _storage.read('events');
    if (eventsData != null) {
      _events.value = (eventsData as List)
          .map((event) => Event.fromJson(Map<String, dynamic>.from(event)))
          .toList();
      
      // Sort events by time (newest first)
      _events.sort((a, b) => b.time.compareTo(a.time));
    }
  }
  
  // Save events to storage
  void _saveEvents() {
    _storage.write('events', _events.map((event) => event.toJson()).toList());
  }
  
  // Start creating new event
  void startNewEvent(EventType type) {
    _currentEventType.value = type;
    _currentEventTime.value = DateTime.now();
    _currentEventDetail.clear();
    _currentEventNotes.value = '';
  }
  
  // Set event time
  void setEventTime(DateTime time) {
    _currentEventTime.value = time;
  }
  
  // Set event time from TimeOfDay
  void setEventTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    _currentEventTime.value = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }
  
  // Set event detail
  void setEventDetail(String key, dynamic value) {
    _currentEventDetail[key] = value;
  }
  
  // Set event notes
  void setEventNotes(String notes) {
    _currentEventNotes.value = notes;
  }
  
  // Add event
  Future<void> addEvent({
    required String childId,
    EventType? type,
    DateTime? time,
    Map<String, dynamic>? detail,
    String? notes,
  }) async {
    _isLoading.value = true;
    
    try {
      final now = DateTime.now();
      final event = Event(
        id: 'event_${now.millisecondsSinceEpoch}',
        childId: childId,
        type: type ?? _currentEventType.value!,
        time: time ?? _currentEventTime.value,
        detail: detail ?? Map<String, dynamic>.from(_currentEventDetail),
        notes: notes ?? (_currentEventNotes.value.isNotEmpty ? _currentEventNotes.value : null),
        createdAt: now,
        updatedAt: now,
      );
      
      _events.insert(0, event); // Add to beginning (newest first)
      _saveEvents();
      
      // Clear current event data
      _clearCurrentEvent();
      
    } finally {
      _isLoading.value = false;
    }
  }
  
  // Update event
  Future<void> updateEvent(Event updatedEvent) async {
    _isLoading.value = true;
    
    try {
      final index = _events.indexWhere((event) => event.id == updatedEvent.id);
      if (index != -1) {
        _events[index] = updatedEvent.copyWith(updatedAt: DateTime.now());
        
        // Re-sort events
        _events.sort((a, b) => b.time.compareTo(a.time));
        _saveEvents();
      }
    } finally {
      _isLoading.value = false;
    }
  }
  
  // Delete event
  Future<void> deleteEvent(String eventId) async {
    _isLoading.value = true;
    
    try {
      _events.removeWhere((event) => event.id == eventId);
      _saveEvents();
    } finally {
      _isLoading.value = false;
    }
  }
  
  // Clear current event data
  void _clearCurrentEvent() {
    _currentEventType.value = null;
    _currentEventTime.value = DateTime.now();
    _currentEventDetail.clear();
    _currentEventNotes.value = '';
  }
  
  // Get events for a specific child
  List<Event> getEventsForChild(String childId) {
    return _events.where((event) => event.childId == childId).toList();
  }
  
  // Get events for a specific date
  List<Event> getEventsForDate(DateTime date) {
    return _events.where((event) {
      return event.time.year == date.year &&
             event.time.month == date.month &&
             event.time.day == date.day;
    }).toList();
  }
  
  // Get events for a specific type
  List<Event> getEventsByType(EventType type) {
    return _events.where((event) => event.type == type).toList();
  }
  
  // Get recent events (last 24 hours)
  List<Event> getRecentEvents() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return _events.where((event) => event.time.isAfter(yesterday)).toList();
  }
  
  // Get events count for today
  int getTodayEventsCount() {
    final today = DateTime.now();
    return getEventsForDate(today).length;
  }
  
  // Get last event of specific type
  Event? getLastEventOfType(EventType type) {
    final typeEvents = getEventsByType(type);
    return typeEvents.isNotEmpty ? typeEvents.first : null;
  }
  
  // Quick add methods for common events
  Future<void> quickAddSleep(String childId, {DateTime? startTime, DateTime? endTime}) async {
    final detail = <String, dynamic>{};
    if (startTime != null) detail['startTime'] = startTime.toIso8601String();
    if (endTime != null) detail['endTime'] = endTime.toIso8601String();
    
    await addEvent(
      childId: childId,
      type: EventType.sleeping,
      detail: detail,
    );
  }
  
  Future<void> quickAddFeeding(String childId, {int? duration, String? type}) async {
    final detail = <String, dynamic>{};
    if (duration != null) detail['duration'] = duration;
    if (type != null) detail['type'] = type;
    
    await addEvent(
      childId: childId,
      type: EventType.feeding,
      detail: detail,
    );
  }
  
  Future<void> quickAddBottle(String childId, {num? amount, String? unit}) async {
    final detail = <String, dynamic>{};
    if (amount != null) detail['amount'] = amount;
    if (unit != null) detail['unit'] = unit;
    
    await addEvent(
      childId: childId,
      type: EventType.bottle,
      detail: detail,
    );
  }
  
  Future<void> quickAddDiaper(String childId, {String? type, bool? wet, bool? dirty}) async {
    final detail = <String, dynamic>{};
    if (type != null) detail['type'] = type;
    if (wet != null) detail['wet'] = wet;
    if (dirty != null) detail['dirty'] = dirty;
    
    await addEvent(
      childId: childId,
      type: EventType.diaper,
      detail: detail,
    );
  }
  
  Future<void> quickAddWeight(String childId, Weight weight) async {
    await addEvent(
      childId: childId,
      type: EventType.weight,
      detail: weight.toJson(),
    );
  }
  
  // Validate current event
  bool get isCurrentEventValid {
    return _currentEventType.value != null;
  }
}
