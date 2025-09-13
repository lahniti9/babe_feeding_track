import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/event_record.dart';
import '../services/events_store.dart';
import '../../children/services/children_store.dart';

class ConditionController extends GetxController {
  final time = DateTime.now().obs;
  final moods = <String>{}.obs;
  final severity = 'mild'.obs;
  final note = ''.obs;

  String? editingEventId;
  final isEditMode = false.obs;

  void setTime(DateTime newTime) {
    time.value = newTime;
  }

  // Edit existing event
  void editEvent(EventRecord event) {
    isEditMode.value = true;
    editingEventId = event.id;
    time.value = event.startAt;

    // Parse data from event
    final data = event.data;

    if (data['moods'] != null) {
      moods.clear();
      moods.addAll(List<String>.from(data['moods']));
    }

    severity.value = data['severity'] ?? 'mild';
    note.value = data['note'] ?? '';
  }

  void toggleMood(String mood) {
    if (moods.contains(mood.toLowerCase())) {
      moods.remove(mood.toLowerCase());
    } else {
      moods.add(mood.toLowerCase());
    }
  }

  void setSeverity(String newSeverity) {
    severity.value = newSeverity.toLowerCase();
  }

  void setNote(String newNote) {
    note.value = newNote;
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

    final noteText = note.value.trim();

    final eventRecord = EventRecord(
      id: editingEventId ?? const Uuid().v4(),
      childId: activeChildId,
      type: EventType.condition,
      startAt: time.value,
      data: {
        'moods': moods.toList(),
        'severity': severity.value,
        'note': noteText,
      },
      comment: noteText.isEmpty ? null : noteText,
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
    moods.clear();
    severity.value = 'mild';
    note.value = '';
  }
}
