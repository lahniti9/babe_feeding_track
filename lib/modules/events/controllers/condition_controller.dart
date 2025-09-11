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

  void setTime(DateTime newTime) {
    time.value = newTime;
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
    final activeChildId = childrenStore.activeId.value ?? 'default-child';
    
    final noteText = note.value.trim();

    await Get.find<EventsStore>().add(EventRecord(
      id: const Uuid().v4(),
      childId: activeChildId,
      type: EventType.condition,
      startAt: time.value,
      data: {
        'moods': moods.toList(),
        'severity': severity.value,
        'note': noteText,
      },
      comment: noteText.isEmpty ? null : noteText,
    ));
    
    Get.back();
  }
}
