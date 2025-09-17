import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/event_record.dart';
import '../services/events_store.dart';
import '../../children/services/children_store.dart';

class HeadCircController extends GetxController {
  final time = DateTime.now().obs;
  final unit = 'cm'.obs;
  final cm = 41.0.obs;
  final inches = 16.1.obs;
  final comment = ''.obs;

  void setTime(DateTime newTime) {
    time.value = newTime;
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

  double toCm() => unit.value == 'cm' ? cm.value : inches.value * 2.54;

  String get displayText {
    if (unit.value == 'cm') {
      return '${cm.value.toStringAsFixed(1)} cm';
    } else {
      return '${inches.value.toStringAsFixed(1)} in';
    }
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

    // Add comment if not empty
    final commentText = comment.value.trim();

    await Get.find<EventsStore>().add(EventRecord(
      id: const Uuid().v4(),
      childId: activeChildId,
      type: EventType.headCircumference,
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
    ));

    Get.back();
  }

  void setComment(String newComment) {
    comment.value = newComment;
  }
}
