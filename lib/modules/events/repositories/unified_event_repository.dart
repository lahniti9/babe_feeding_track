import 'dart:async';
import 'dart:collection';
import 'package:get/get.dart';
import '../models/event_record.dart';
import '../services/events_store.dart';
import 'event_repository.dart';
import 'legacy_event_adapter.dart';

/// Unified repository that reads from both new and legacy systems
/// Provides a single interface while supporting gradual migration
class UnifiedEventRepository extends GetxService implements EventRepository {
  final EventsStore _newStore;
  final LegacyEventAdapter _legacyAdapter;
  
  // In-memory indices for performance
  final _byChild = <String, SplayTreeSet<EventRecord>>{};
  final _byChildType = <String, Map<EventType, SplayTreeSet<EventRecord>>>{};
  
  // Cache for merged streams
  final _streamCache = <String, Stream<List<EventRecord>>>{};
  
  UnifiedEventRepository(this._newStore, this._legacyAdapter);

  @override
  void onInit() {
    super.onInit();
    _initializeIndices();
    
    // Listen to new store changes and update indices
    ever(_newStore.items, (_) => _rebuildIndices());
  }

  void _initializeIndices() {
    _rebuildIndices();
  }

  void _rebuildIndices() {
    _byChild.clear();
    _byChildType.clear();
    
    // Index new store events
    for (final event in _newStore.items) {
      _indexEvent(event);
    }
    
    // Clear stream cache to force recomputation
    _streamCache.clear();
  }

  void _indexEvent(EventRecord event) {
    // Comparator for time-based sorting
    int timeComparator(EventRecord a, EventRecord b) => 
        a.startAt.compareTo(b.startAt);
    
    // Index by child
    _byChild
        .putIfAbsent(event.childId, () => SplayTreeSet(timeComparator))
        .add(event);
    
    // Index by child and type
    _byChildType
        .putIfAbsent(event.childId, () => <EventType, SplayTreeSet<EventRecord>>{})
        .putIfAbsent(event.type, () => SplayTreeSet(timeComparator))
        .add(event);
  }

  @override
  Stream<List<EventRecord>> watch({
    required String childId,
    Set<EventType>? types,
    DateTime? from,
    DateTime? to,
  }) {
    // Create cache key
    final key = _createCacheKey(childId, types, from, to);
    
    // Return cached stream if available
    if (_streamCache.containsKey(key)) {
      return _streamCache[key]!;
    }
    
    // Create new merged stream
    final newStream = _newStore.watch(
      childId: childId,
      types: types,
      from: from,
      to: to,
    );
    
    final legacyStream = _legacyAdapter.watchAsRecords(
      childId: childId,
      types: types,
      from: from,
      to: to,
    );
    
    // Create a simple merged stream
    final controller = StreamController<List<EventRecord>>.broadcast();

    // Listen to both streams and merge results
    StreamSubscription? newSub;
    StreamSubscription? legacySub;

    List<EventRecord> lastNewEvents = [];
    List<EventRecord> lastLegacyEvents = [];

    void emitMerged() {
      final merged = _mergeEventLists(lastNewEvents, lastLegacyEvents);
      controller.add(merged);
    }

    newSub = newStream.listen((events) {
      lastNewEvents = events;
      emitMerged();
    });

    legacySub = legacyStream.listen((events) {
      lastLegacyEvents = events;
      emitMerged();
    });

    // Clean up subscriptions when stream is cancelled
    controller.onCancel = () {
      newSub?.cancel();
      legacySub?.cancel();
    };

    final mergedStream = controller.stream.distinct();
    
    // Cache the stream
    _streamCache[key] = mergedStream;
    
    return mergedStream;
  }

  List<EventRecord> _mergeEventLists(
    List<EventRecord> newEvents,
    List<EventRecord> legacyEvents,
  ) {
    // Merge and deduplicate by ID
    final eventMap = <String, EventRecord>{};

    // Add legacy events first (lower priority)
    for (final event in legacyEvents) {
      eventMap[event.id] = event;
    }

    // Add new events (higher priority, will overwrite legacy if same ID)
    for (final event in newEvents) {
      eventMap[event.id] = event;
    }

    // Sort by start time
    final result = eventMap.values.toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));

    return result;
  }

  String _createCacheKey(
    String childId,
    Set<EventType>? types,
    DateTime? from,
    DateTime? to,
  ) {
    final typeStr = types?.map((t) => t.name).join(',') ?? 'all';
    final fromStr = from?.millisecondsSinceEpoch.toString() ?? 'null';
    final toStr = to?.millisecondsSinceEpoch.toString() ?? 'null';
    return '$childId|$typeStr|$fromStr|$toStr';
  }

  @override
  Future<void> upsert(EventRecord event) async {
    // All new writes go to the new system only
    await _newStore.add(event);
    _indexEvent(event);
  }

  @override
  Future<void> remove(String id) async {
    // Remove from new store
    await _newStore.remove(id);
    
    // Remove from legacy adapter if it exists there
    await _legacyAdapter.remove(id);
    
    // Rebuild indices
    _rebuildIndices();
  }

  @override
  Map<EventType, int> getEventCounts({
    required String childId,
    DateTime? since,
  }) {
    final counts = <EventType, int>{};
    
    // Count from new store
    final newCounts = _newStore.getEventCounts(since: since);
    for (final entry in newCounts.entries) {
      counts[entry.key] = (counts[entry.key] ?? 0) + entry.value;
    }
    
    // Count from legacy adapter
    final legacyCounts = _legacyAdapter.getEventCounts(
      childId: childId,
      since: since,
    );
    for (final entry in legacyCounts.entries) {
      counts[entry.key] = (counts[entry.key] ?? 0) + entry.value;
    }
    
    return counts;
  }

  @override
  List<EventRecord> getTodaysEvents(String childId) {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    // Get from indexed data for performance
    final childEvents = _byChild[childId] ?? <EventRecord>{};
    
    return childEvents
        .where((e) => 
            e.startAt.isAfter(startOfDay) && 
            e.startAt.isBefore(endOfDay))
        .toList();
  }

  @override
  bool hasDataForChild(String childId) {
    return (_byChild[childId]?.isNotEmpty ?? false) ||
           _legacyAdapter.hasDataForChild(childId);
  }

  @override
  void onClose() {
    _streamCache.clear();
    super.onClose();
  }
}
