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

  Future<void> save() async {
    final childrenStore = Get.find<ChildrenStore>();
    final activeChildId = childrenStore.activeId.value ?? 'default-child';
    
    await Get.find<EventsStore>().add(EventRecord(
      id: const Uuid().v4(),
      childId: activeChildId,
      type: EventType.diaper,
      startAt: time.value,
      data: {
        'kind': kind.value,
        'color': color.toList(),
        'consistency': consistency.toList(),
      },
    ));
    Get.back();
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
