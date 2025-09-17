import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/event_record.dart';
import '../services/events_store.dart';
import '../../children/services/children_store.dart';

class DoctorController extends GetxController {
  final time = DateTime.now().obs;
  final reason = <String>{}.obs;
  final outcome = <String>{}.obs;
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

    // Load reason selection
    reason.clear();
    if (data['reason'] != null) {
      final reasonList = List<String>.from(data['reason']);
      reason.addAll(reasonList);
    }

    // Load outcome selection
    outcome.clear();
    if (data['outcome'] != null) {
      final outcomeList = List<String>.from(data['outcome']);
      outcome.addAll(outcomeList);
    }

    // Load comment if available
    comment.value = event.comment ?? '';
  }

  void toggleReason(String reasonOption) {
    if (reason.contains(reasonOption)) {
      reason.remove(reasonOption);
    } else {
      reason.add(reasonOption);
    }
  }

  void toggleOutcome(String outcomeOption) {
    if (outcome.contains(outcomeOption)) {
      outcome.remove(outcomeOption);
    } else {
      outcome.add(outcomeOption);
    }
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
      type: EventType.doctor,
      startAt: time.value,
      data: {
        'reason': reason.toList(),
        'outcome': outcome.toList(),
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
    reason.clear();
    outcome.clear();
    comment.value = '';
  }
}
