import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/event_record.dart';
import '../services/events_store.dart';
import '../../children/services/children_store.dart';

class TemperatureController extends GetxController {
  final time = DateTime.now().obs;
  final value = 36.6.obs;
  final unit = '°C'.obs;
  final method = <String>{}.obs; // axillary, rectal, oral, ear
  final condition = <String>{}.obs; // fever, normal, low

  Future<void> save() async {
    final childrenStore = Get.find<ChildrenStore>();
    final activeChildId = childrenStore.getValidActiveChildId();

    if (activeChildId == null) {
      Get.snackbar(
        'No Child Selected',
        'Please add a child profile before creating events.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await Get.find<EventsStore>().add(EventRecord(
      id: const Uuid().v4(),
      childId: activeChildId,
      type: EventType.temperature,
      startAt: time.value,
      data: {
        'value': value.value,
        'unit': unit.value,
        'method': method.toList(),
        'condition': condition.toList(),
      },
    ));
    Get.back();
  }

  void setValue(double newValue) {
    value.value = newValue;
  }

  void setUnit(String newUnit) {
    unit.value = newUnit;
    // Convert temperature when unit changes
    if (newUnit == '°F' && unit.value == '°C') {
      value.value = (value.value * 9/5) + 32;
    } else if (newUnit == '°C' && unit.value == '°F') {
      value.value = (value.value - 32) * 5/9;
    }
  }

  void toggleMethod(String methodOption) {
    method.clear(); // Only one method at a time
    method.add(methodOption);
  }

  void toggleCondition(String conditionOption) {
    condition.clear(); // Only one condition at a time
    condition.add(conditionOption);
  }
}
