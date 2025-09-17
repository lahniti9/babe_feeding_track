import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../models/event_record.dart';
import '../../services/events_store.dart';
import '../../../children/services/children_store.dart';

abstract class MeasureEventController extends GetxController {
  final time = DateTime.now().obs;
  final value = 0.0.obs;
  final unit = ''.obs;
  final comment = ''.obs;

  // Track if we're editing an existing event
  String? editingEventId;

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

  void setComment(String newComment) {
    comment.value = newComment;
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

    final data = {
      'value': value.value,
      'unit': unit.value,
      ...additionalData,
    };

    // Add comment if not empty
    final commentText = comment.value.trim();

    final eventRecord = EventRecord(
      id: editingEventId ?? const Uuid().v4(),
      childId: activeChildId,
      type: eventType,
      startAt: time.value,
      data: data,
      comment: commentText.isEmpty ? null : commentText,
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
