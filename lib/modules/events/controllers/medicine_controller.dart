import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/event_record.dart';
import '../services/events_store.dart';
import '../../children/services/children_store.dart';

class MedicineController extends GetxController {
  final time = DateTime.now().obs;
  final medicineName = ''.obs;
  final dose = 0.0.obs;
  final doseUnit = 'ml'.obs;
  final reason = <String>{}.obs;
  final reminderEnabled = false.obs;
  final reminderTime = DateTime.now().obs;
  final comment = ''.obs;

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

    // Load data from event
    final data = event.data;
    medicineName.value = data['name'] ?? '';
    dose.value = data['dose'] as double? ?? 0.0;
    doseUnit.value = data['unit'] ?? 'ml';
    reminderEnabled.value = data['reminderEnabled'] as bool? ?? false;

    if (data['reminderAt'] != null) {
      reminderTime.value = DateTime.parse(data['reminderAt']);
    }

    // Load reason selection
    reason.clear();
    if (data['reason'] != null) {
      final reasonList = List<String>.from(data['reason']);
      reason.addAll(reasonList);
    }

    // Load comment if available
    comment.value = event.comment ?? '';
  }

  void setMedicineName(String name) {
    medicineName.value = name;
  }

  void setDose(double newDose) {
    dose.value = newDose;
  }

  void setDoseUnit(String unit) {
    doseUnit.value = unit;
  }

  void toggleReason(String reasonOption) {
    if (reason.contains(reasonOption)) {
      reason.remove(reasonOption);
    } else {
      reason.add(reasonOption);
    }
  }

  void toggleReminder() {
    reminderEnabled.value = !reminderEnabled.value;
  }

  void setReminderTime(DateTime time) {
    reminderTime.value = time;
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

    final commentText = comment.value.trim();

    final eventRecord = EventRecord(
      id: editingEventId ?? const Uuid().v4(),
      childId: activeChildId,
      type: EventType.medicine,
      startAt: time.value,
      data: {
        'name': medicineName.value,
        'dose': dose.value,
        'unit': doseUnit.value,
        'reason': reason.toList(),
        'reminderEnabled': reminderEnabled.value,
        if (reminderEnabled.value) 'reminderAt': reminderTime.value.toIso8601String(),
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

  void reset() {
    isEditMode.value = false;
    editingEventId = null;
    time.value = DateTime.now();
    medicineName.value = '';
    dose.value = 0.0;
    doseUnit.value = 'ml';
    reason.clear();
    reminderEnabled.value = false;
    reminderTime.value = DateTime.now();
    comment.value = '';
  }
}
