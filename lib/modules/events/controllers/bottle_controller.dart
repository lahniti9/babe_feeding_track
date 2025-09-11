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

  Future<void> save() async {
    final childrenStore = Get.find<ChildrenStore>();
    final activeChildId = childrenStore.activeId.value ?? 'default-child';
    
    await Get.find<EventsStore>().add(EventRecord(
      id: const Uuid().v4(),
      childId: activeChildId,
      type: EventType.feedingBottle,
      startAt: time.value,
      data: {
        'feedType': feedType.value,
        'volume': volume.value,
        'unit': unit.value,
      },
    ));
    Get.back();
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
}
