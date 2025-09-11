import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../models/event_record.dart';
import '../../services/events_store.dart';
import '../../../children/services/children_store.dart';

abstract class TagEventController extends GetxController {
  final time = DateTime.now().obs;
  final comment = ''.obs;

  // Abstract properties to be implemented by subclasses
  EventType get eventType;
  Map<String, RxSet<String>> get chipGroups;
  Map<String, dynamic> get additionalData;

  void setTime(DateTime newTime) {
    time.value = newTime;
  }

  void setComment(String newComment) {
    comment.value = newComment;
  }

  void toggleChip(String groupKey, String option) {
    final group = chipGroups[groupKey];
    if (group != null) {
      if (group.contains(option)) {
        group.remove(option);
      } else {
        group.add(option);
      }
    }
  }

  void selectSingleChip(String groupKey, String option) {
    final group = chipGroups[groupKey];
    if (group != null) {
      group.clear();
      group.add(option);
    }
  }

  Future<void> save() async {
    final childrenStore = Get.find<ChildrenStore>();
    final activeChildId = childrenStore.activeId.value ?? 'default-child';
    
    final data = <String, dynamic>{};
    
    // Add chip group data
    for (final entry in chipGroups.entries) {
      data[entry.key] = entry.value.toList();
    }
    
    // Add additional data
    data.addAll(additionalData);
    
    // Add comment if not empty
    final commentText = comment.value.trim();

    await Get.find<EventsStore>().add(EventRecord(
      id: const Uuid().v4(),
      childId: activeChildId,
      type: eventType,
      startAt: time.value,
      data: data,
      comment: commentText.isEmpty ? null : commentText,
    ));
    
    Get.back();
  }
}
