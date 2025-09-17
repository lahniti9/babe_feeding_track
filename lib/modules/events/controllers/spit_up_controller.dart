import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/event_record.dart';
import '../services/events_store.dart';
import '../../children/services/children_store.dart';

class SpitUpController extends GetxController {
  final time = DateTime.now().obs;
  final amount = 'small'.obs;
  final kind = 'milk'.obs;
  final note = ''.obs;

  // Track if we're editing an existing event
  String? editingEventId;

  void setTime(DateTime newTime) {
    time.value = newTime;
  }

  void setAmount(String newAmount) {
    amount.value = newAmount.toLowerCase();
  }

  void setKind(String newKind) {
    kind.value = newKind.toLowerCase();
  }

  void setNote(String newNote) {
    note.value = newNote;
  }

  // Edit an existing spit up event
  void editEvent(EventRecord event) {
    print('SpitUpController.editEvent called');
    print('Event data: ${event.data}');
    print('Event comment: ${event.comment}');

    editingEventId = event.id;
    time.value = event.startAt;

    // Load data from event
    final data = event.data;
    amount.value = data['amount'] as String? ?? 'small';
    kind.value = data['type'] as String? ?? 'milk';

    // Load note from comment field (prefer comment field as it's the main storage)
    note.value = event.comment ?? data['note'] ?? '';

    print('Setting amount to: "${amount.value}"');
    print('Setting kind to: "${kind.value}"');
    print('Setting note to: "${note.value}"');
  }

  // Reset controller to default state
  void reset() {
    editingEventId = null;
    time.value = DateTime.now();
    amount.value = 'small';
    kind.value = 'milk';
    note.value = '';
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
      type: EventType.spitUp,
      startAt: time.value,
      data: {
        'amount': amount.value,
        'type': kind.value,
        'note': noteText,
      },
      comment: noteText.isEmpty ? null : noteText,
    );

    if (editingEventId != null) {
      // Update existing event
      await eventsStore.update(eventRecord);
    } else {
      // Create new event
      await eventsStore.add(eventRecord);
    }

    Get.back();
  }
}
