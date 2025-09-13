import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/event_record.dart';
import '../services/events_store.dart';
import '../../children/services/children_store.dart';

class DiaperController extends GetxController {
  final time = DateTime.now().obs;
  final kind = 'pee'.obs; // 'pee' | 'poop' | 'mixed'
  final color = <String>{}.obs; // yellow/green/brown
  final consistency = <String>{}.obs; // loose/normal/firm

  String? editingEventId;
  final isEditMode = false.obs;

  // Edit existing event
  void editEvent(EventRecord event) {
    isEditMode.value = true;
    editingEventId = event.id;
    time.value = event.startAt;

    // Parse data from event
    final data = event.data;
    kind.value = data['kind'] ?? 'pee';

    if (data['color'] != null) {
      color.clear();
      color.addAll(List<String>.from(data['color']));
    }

    if (data['consistency'] != null) {
      consistency.clear();
      consistency.addAll(List<String>.from(data['consistency']));
    }
  }

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
      type: EventType.diaper,
      startAt: time.value,
      data: {
        'kind': kind.value,
        'color': color.toList(),
        'consistency': consistency.toList(),
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

  void _reset() {
    isEditMode.value = false;
    editingEventId = null;
    time.value = DateTime.now();
    kind.value = 'pee';
    color.clear();
    consistency.clear();
  }

  void setKind(String newKind) {
    kind.value = newKind.toLowerCase();
  }

  void toggleColor(String colorOption) {
    if (color.contains(colorOption)) {
      color.remove(colorOption);
    } else {
      color.add(colorOption);
    }
  }

  void toggleConsistency(String consistencyOption) {
    if (consistency.contains(consistencyOption)) {
      consistency.remove(consistencyOption);
    } else {
      consistency.add(consistencyOption);
    }
  }
}
