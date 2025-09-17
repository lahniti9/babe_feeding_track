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
  final comment = ''.obs;

  // Track if we're editing an existing event
  String? editingEventId;
  final isEditMode = false.obs;

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

    // Add comment if not empty
    final commentText = comment.value.trim();

    final eventRecord = EventRecord(
      id: editingEventId ?? const Uuid().v4(),
      childId: activeChildId,
      type: EventType.temperature,
      startAt: time.value,
      data: {
        'value': value.value,
        'unit': unit.value,
        'method': method.toList(),
        'condition': condition.toList(),
      },
      comment: commentText.isEmpty ? null : commentText,
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

  // Edit existing event
  void editEvent(EventRecord event) {
    isEditMode.value = true;
    editingEventId = event.id;
    time.value = event.startAt;

    // Load data from event
    final data = event.data;
    value.value = data['value'] as double? ?? 36.6;
    unit.value = data['unit'] as String? ?? '°C';

    // Load method selection
    method.clear();
    if (data['method'] != null) {
      final methodList = List<String>.from(data['method']);
      method.addAll(methodList);
    }

    // Load condition selection
    condition.clear();
    if (data['condition'] != null) {
      final conditionList = List<String>.from(data['condition']);
      condition.addAll(conditionList);
    }

    // Load comment if available
    comment.value = event.comment ?? '';
  }

  void reset() {
    isEditMode.value = false;
    editingEventId = null;
    time.value = DateTime.now();
    value.value = 36.6;
    unit.value = '°C';
    method.clear();
    condition.clear();
    comment.value = '';
  }

  void setValue(double newValue) {
    value.value = newValue;
  }

  void setTime(DateTime newTime) {
    time.value = newTime;
  }

  void setComment(String newComment) {
    comment.value = newComment;
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
