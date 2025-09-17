import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/event_record.dart';
import '../services/events_store.dart';
import '../../children/services/children_store.dart';

class ConditionController extends GetxController {
  final time = DateTime.now().obs;
  final mood = 'happy'.obs; // Changed from moods set to single mood
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

    // Handle both old format (moods array) and new format (single mood)
    if (data['mood'] != null) {
      mood.value = data['mood'];
    } else if (data['moods'] != null && data['moods'].isNotEmpty) {
      // For backward compatibility, take the first mood from the old format
      mood.value = List<String>.from(data['moods']).first;
    }

    severity.value = data['severity'] ?? 'mild';

    // Load note from data or comment field (prefer comment field as it's the main storage)
    note.value = event.comment ?? data['note'] ?? '';
  }

  void setMood(String newMood) {
    mood.value = newMood.toLowerCase();
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
        'mood': mood.value,
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
    reset();
  }

  void reset() {
    isEditMode.value = false;
    editingEventId = null;
    time.value = DateTime.now();
    mood.value = 'happy';
    severity.value = 'mild';
    note.value = '';
  }
}
