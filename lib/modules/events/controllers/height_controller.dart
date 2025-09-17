import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/event_record.dart';
import '../services/events_store.dart';
import '../../children/services/children_store.dart';

class HeightController extends GetxController {
  final time = DateTime.now().obs;
  final unit = 'cm'.obs;
  final cm = 61.0.obs;
  final inches = 24.0.obs;
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
    final valueCm = data['valueCm'] as double? ?? 61.0;
    final eventUnit = data['unit'] as String? ?? 'cm';

    // Set the unit first
    unit.value = eventUnit;

    // Load display values if available
    final display = data['display'] as Map<String, dynamic>?;
    if (display != null) {
      cm.value = display['cm'] as double? ?? valueCm;
      inches.value = display['in'] as double? ?? (valueCm / 2.54);
    } else {
      // Fallback to calculated values
      cm.value = valueCm;
      inches.value = valueCm / 2.54;
    }

    // Load comment if available
    comment.value = event.comment ?? '';
  }

  void setUnit(String newUnit) {
    if (unit.value != newUnit) {
      if (newUnit == 'in') {
        // Convert cm to inches
        inches.value = cm.value / 2.54;
      } else {
        // Convert inches to cm
        cm.value = inches.value * 2.54;
      }
      unit.value = newUnit;
    }
  }

  void setCm(double newCm) {
    cm.value = newCm;
    inches.value = newCm / 2.54;
  }

  void setInches(double newInches) {
    inches.value = newInches;
    cm.value = newInches * 2.54;
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
      type: EventType.height,
      startAt: time.value,
      data: {
        'valueCm': toCm(),
        'unit': unit.value,
        'display': {
          'cm': cm.value,
          'in': inches.value,
        },
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
    unit.value = 'cm';
    cm.value = 61.0;
    inches.value = 24.0;
    comment.value = '';
  }

  double toCm() => unit.value == 'cm' ? cm.value : inches.value * 2.54;

  String get displayText {
    if (unit.value == 'cm') {
      return '${cm.value.toStringAsFixed(1)} cm';
    } else {
      return '${inches.value.toStringAsFixed(1)} in';
    }
  }
}
