import 'package:get/get.dart';
import '../models/event_record.dart';
import 'base/tag_event_controller.dart';

class MedicineController extends TagEventController {
  final medicineName = ''.obs;
  final dose = 0.0.obs;
  final doseUnit = 'ml'.obs;
  final reason = <String>{}.obs;
  final reminderEnabled = false.obs;
  final reminderTime = DateTime.now().obs;

  @override
  EventType get eventType => EventType.medicine;

  @override
  Map<String, RxSet<String>> get chipGroups => {
    'reason': reason,
  };

  @override
  Map<String, dynamic> get additionalData => {
    'name': medicineName.value,
    'dose': dose.value,
    'unit': doseUnit.value,
    'reminderEnabled': reminderEnabled.value,
    if (reminderEnabled.value) 'reminderAt': reminderTime.value.toIso8601String(),
  };

  void setMedicineName(String name) {
    medicineName.value = name;
  }

  void setDose(double newDose) {
    dose.value = newDose;
  }

  void setDoseUnit(String unit) {
    doseUnit.value = unit;
  }

  void toggleReminder() {
    reminderEnabled.value = !reminderEnabled.value;
  }

  void setReminderTime(DateTime time) {
    reminderTime.value = time;
  }
}
