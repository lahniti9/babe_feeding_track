import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/event_record.dart';
import '../services/events_store.dart';
import '../../children/services/children_store.dart';

class BottleController extends GetxController {
  final time = DateTime.now().obs;
  final feedType = 'formula'.obs; // 'formula' | 'breast'
  final volume = 0.0.obs; // in oz or ml
  final unit = 'oz'.obs;

  // Edit mode
  final isEditMode = false.obs;
  String? editingEventId;

  Future<void> save() async {
    final childrenStore = Get.find<ChildrenStore>();
    final activeChildId = childrenStore.getValidActiveChildId();
    final eventsStore = Get.find<EventsStore>();

    if (activeChildId == null) {
      Get.snackbar(
        'No Child Selected',
        'Please add a child profile before creating events.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final eventRecord = EventRecord(
      id: editingEventId ?? const Uuid().v4(),
      childId: activeChildId,
      type: EventType.feedingBottle,
      startAt: time.value,
      data: {
        'feedType': feedType.value,
        'volume': volume.value,
        'unit': unit.value,
      },
    );

    if (isEditMode.value && editingEventId != null) {
      // Update existing event
      await eventsStore.update(eventRecord);
    } else {
      // Create new event
      await eventsStore.add(eventRecord);
    }

    Get.back();
    _reset();
  }

  void setFeedType(String type) {
    feedType.value = type.startsWith('F') ? 'formula' : 'breast';
  }

  void setVolume(double newVolume) {
    volume.value = newVolume;
  }

  void setUnit(String newUnit) {
    unit.value = newUnit;
  }

  // Edit existing event
  void editEvent(EventRecord event) {
    isEditMode.value = true;
    editingEventId = event.id;
    time.value = event.startAt;

    // Parse data from event
    final data = event.data;
    feedType.value = data['feedType'] ?? 'formula';
    volume.value = (data['volume'] ?? 0.0).toDouble();
    unit.value = data['unit'] ?? 'oz';
  }

  // Reset state
  void _reset() {
    isEditMode.value = false;
    editingEventId = null;
    time.value = DateTime.now();
    feedType.value = 'formula';
    volume.value = 0.0;
    unit.value = 'oz';
  }
}
