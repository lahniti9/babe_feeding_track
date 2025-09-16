import 'package:get/get.dart';
import '../../children/services/children_store.dart';
import '../../events/services/events_store.dart';
import '../services/timezone_clock.dart';
import '../controllers/live_sleeping_stats_controller.dart';
import '../controllers/live_feeding_stats_controller.dart';

/// Dependency injection for live statistics controllers
class LiveStatsBinding extends Bindings {
  @override
  void dependencies() {
    // Get required services
    final childrenStore = Get.find<ChildrenStore>();
    final eventsStore = Get.find<EventsStore>();
    final timezoneClock = Get.find<TimezoneClock>();
    
    // Get active child ID
    final activeChildId = childrenStore.activeId.value;
    
    if (activeChildId != null) {
      // Initialize live statistics controllers
      Get.lazyPut<LiveSleepingStatsController>(
        () => LiveSleepingStatsController(
          eventsStore: eventsStore,
          childId: activeChildId,
          clock: timezoneClock,
        ),
        fenix: true,
      );
      
      Get.lazyPut<LiveFeedingStatsController>(
        () => LiveFeedingStatsController(
          eventsStore: eventsStore,
          childId: activeChildId,
          clock: timezoneClock,
        ),
        fenix: true,
      );
    }
  }
}

/// Initialize live stats controllers for a specific child
class ChildSpecificStatsBinding extends Bindings {
  final String childId;
  
  ChildSpecificStatsBinding(this.childId);
  
  @override
  void dependencies() {
    // Get required services
    final eventsStore = Get.find<EventsStore>();
    final timezoneClock = Get.find<TimezoneClock>();
    
    // Initialize controllers for specific child
    Get.lazyPut<LiveSleepingStatsController>(
      () => LiveSleepingStatsController(
        eventsStore: eventsStore,
        childId: childId,
        clock: timezoneClock,
      ),
      tag: childId,
      fenix: true,
    );
    
    Get.lazyPut<LiveFeedingStatsController>(
      () => LiveFeedingStatsController(
        eventsStore: eventsStore,
        childId: childId,
        clock: timezoneClock,
      ),
      tag: childId,
      fenix: true,
    );
  }
}

/// Utility class for managing live stats controllers
class LiveStatsManager {
  /// Initialize controllers for active child
  static void initializeForActiveChild() {
    final childrenStore = Get.find<ChildrenStore>();
    final activeChildId = childrenStore.activeId.value;
    
    if (activeChildId != null) {
      ChildSpecificStatsBinding(activeChildId).dependencies();
    }
  }
  
  /// Get sleeping stats controller for active child
  static LiveSleepingStatsController? getSleepingController() {
    final childrenStore = Get.find<ChildrenStore>();
    final activeChildId = childrenStore.activeId.value;
    
    if (activeChildId != null) {
      try {
        return Get.find<LiveSleepingStatsController>(tag: activeChildId);
      } catch (e) {
        // Controller not initialized, create it
        ChildSpecificStatsBinding(activeChildId).dependencies();
        return Get.find<LiveSleepingStatsController>(tag: activeChildId);
      }
    }
    
    return null;
  }
  
  /// Get feeding stats controller for active child
  static LiveFeedingStatsController? getFeedingController() {
    final childrenStore = Get.find<ChildrenStore>();
    final activeChildId = childrenStore.activeId.value;
    
    if (activeChildId != null) {
      try {
        return Get.find<LiveFeedingStatsController>(tag: activeChildId);
      } catch (e) {
        // Controller not initialized, create it
        ChildSpecificStatsBinding(activeChildId).dependencies();
        return Get.find<LiveFeedingStatsController>(tag: activeChildId);
      }
    }
    
    return null;
  }
  
  /// Clean up controllers for a specific child
  static void cleanupForChild(String childId) {
    try {
      Get.delete<LiveSleepingStatsController>(tag: childId);
    } catch (e) {
      // Controller not found, ignore
    }
    
    try {
      Get.delete<LiveFeedingStatsController>(tag: childId);
    } catch (e) {
      // Controller not found, ignore
    }
  }
  
  /// Clean up all controllers
  static void cleanupAll() {
    try {
      Get.delete<LiveSleepingStatsController>();
    } catch (e) {
      // Controller not found, ignore
    }
    
    try {
      Get.delete<LiveFeedingStatsController>();
    } catch (e) {
      // Controller not found, ignore
    }
  }
}

/// Extension for easy controller access
extension LiveStatsControllerExtension on GetInterface {
  /// Get sleeping stats controller for active child
  LiveSleepingStatsController? get sleepingStats {
    return LiveStatsManager.getSleepingController();
  }
  
  /// Get feeding stats controller for active child
  LiveFeedingStatsController? get feedingStats {
    return LiveStatsManager.getFeedingController();
  }
}
