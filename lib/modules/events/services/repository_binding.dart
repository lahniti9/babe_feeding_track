import 'package:get/get.dart';
import '../repositories/event_repository.dart';
import '../repositories/unified_event_repository.dart';
import '../repositories/legacy_event_adapter.dart';
import '../services/events_store.dart';

/// Binding service to initialize the repository pattern
/// Sets up the unified repository with both new and legacy adapters
class RepositoryBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize EventsStore (new system)
    Get.put<EventsStore>(EventsStore(), permanent: true);
    
    // Initialize LegacyEventAdapter
    Get.put<LegacyEventAdapter>(LegacyEventAdapter(), permanent: true);
    
    // Initialize UnifiedEventRepository
    Get.put<UnifiedEventRepository>(
      UnifiedEventRepository(
        Get.find<EventsStore>(),
        Get.find<LegacyEventAdapter>(),
      ),
      permanent: true,
    );
    
    // Bind the interface to the implementation
    Get.put<EventRepository>(
      Get.find<UnifiedEventRepository>(),
      permanent: true,
    );
  }
}

/// Service to manually initialize repositories if not using GetX bindings
class RepositoryInitializer {
  static bool _initialized = false;
  
  /// Initialize all repository services
  static void initialize() {
    if (_initialized) return;
    
    // Initialize EventsStore (new system)
    if (!Get.isRegistered<EventsStore>()) {
      Get.put<EventsStore>(EventsStore(), permanent: true);
    }
    
    // Initialize LegacyEventAdapter
    if (!Get.isRegistered<LegacyEventAdapter>()) {
      Get.put<LegacyEventAdapter>(LegacyEventAdapter(), permanent: true);
    }
    
    // Initialize UnifiedEventRepository
    if (!Get.isRegistered<UnifiedEventRepository>()) {
      Get.put<UnifiedEventRepository>(
        UnifiedEventRepository(
          Get.find<EventsStore>(),
          Get.find<LegacyEventAdapter>(),
        ),
        permanent: true,
      );
    }
    
    // Bind the interface to the implementation
    if (!Get.isRegistered<EventRepository>()) {
      Get.put<EventRepository>(
        Get.find<UnifiedEventRepository>(),
        permanent: true,
      );
    }
    
    _initialized = true;
  }
  
  /// Check if repositories are initialized
  static bool get isInitialized => _initialized;
  
  /// Reset initialization state (for testing)
  static void reset() {
    _initialized = false;
  }
}
