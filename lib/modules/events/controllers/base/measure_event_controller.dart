import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../models/event_record.dart';
import '../../services/events_store.dart';
import '../../../children/services/children_store.dart';

abstract class MeasureEventController extends GetxController {
  final time = DateTime.now().obs;
  final value = 0.0.obs;
  final unit = ''.obs;

  // Abstract properties to be implemented by subclasses
  EventType get eventType;
  List<String> get unitOptions;
  String get defaultUnit;
  Map<String, dynamic> get additionalData;
  double? get minValue;
  double? get maxValue;
  int get decimals;

  @override
  void onInit() {
    super.onInit();
    unit.value = defaultUnit;
  }

  void setValue(double newValue) {
    if (minValue != null && newValue < minValue!) return;
    if (maxValue != null && newValue > maxValue!) return;
    value.value = newValue;
  }

  void setUnit(String newUnit) {
    unit.value = newUnit;
  }

  void setTime(DateTime newTime) {
    time.value = newTime;
  }

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

    final data = {
      'value': value.value,
      'unit': unit.value,
      ...additionalData,
    };

    await Get.find<EventsStore>().add(EventRecord(
      id: const Uuid().v4(),
      childId: activeChildId,
      type: eventType,
      startAt: time.value,
      data: data,
    ));

    Get.back();
  }
}
