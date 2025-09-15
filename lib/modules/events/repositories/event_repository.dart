import 'package:get/get.dart';
import '../models/event_record.dart';

/// Repository interface for event data access
/// Provides a clean boundary between controllers and storage implementations
abstract class EventRepository {
  /// Watch events with filtering support
  /// Returns a reactive stream of events matching the criteria
  Stream<List<EventRecord>> watch({
    required String childId,
    Set<EventType>? types,
    DateTime? from,
    DateTime? to,
  });

  /// Add or update an event
  Future<void> upsert(EventRecord event);

  /// Remove an event by ID
  Future<void> remove(String id);

  /// Get event counts for statistics
  Map<EventType, int> getEventCounts({
    required String childId,
    DateTime? since,
  });

  /// Get today's events for quick access
  List<EventRecord> getTodaysEvents(String childId);

  /// Check if repository has data for a child
  bool hasDataForChild(String childId);
}

/// Service locator for event repository
class EventRepositoryProvider {
  static EventRepository get instance => Get.find<EventRepository>();
}
