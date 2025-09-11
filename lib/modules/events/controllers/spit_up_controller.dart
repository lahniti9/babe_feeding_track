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

  Future<void> save() async {
    final childrenStore = Get.find<ChildrenStore>();
    final activeChildId = childrenStore.activeId.value ?? 'default-child';
    
    final noteText = note.value.trim();

    await Get.find<EventsStore>().add(EventRecord(
      id: const Uuid().v4(),
      childId: activeChildId,
      type: EventType.spitUp,
      startAt: time.value,
      data: {
        'amount': amount.value,
        'type': kind.value,
        'note': noteText,
      },
      comment: noteText.isEmpty ? null : noteText,
    ));
    
    Get.back();
  }
}
