import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/sleep_event.dart';
import 'events_controller.dart';

class SleepEntryController extends GetxController {
  SleepEntryController({SleepEvent? initial, required this.childId}) {
    if (initial != null) {
      editingId = initial.id;
      fellAsleep.value = initial.fellAsleep;
      wokeUp.value = initial.wokeUp;
      comment.value = initial.comment ?? '';
      startTags.addAll(initial.startTags);
      endTags.addAll(initial.endTags);
      howTags.addAll(initial.howTags);
      isEdit.value = true;
    }
  }

  final String childId;
  String? editingId;

  final isEdit = false.obs;
  final fellAsleep = DateTime.now().obs;
  final wokeUp = DateTime.now().obs;

  final comment = ''.obs;
  final RxSet<String> startTags = <String>{}.obs;
  final RxSet<String> endTags = <String>{}.obs;
  final RxSet<String> howTags = <String>{}.obs;

  String get resumeLabel => 'from ${DateFormat.Hm().format(fellAsleep.value)}';

  bool get valid => !wokeUp.value.isBefore(fellAsleep.value);

  SleepEvent toModel() => SleepEvent(
    id: editingId ?? 'sleep_${DateTime.now().millisecondsSinceEpoch}',
    childId: childId,
    fellAsleep: fellAsleep.value,
    wokeUp: wokeUp.value,
    comment: comment.value.isEmpty ? null : comment.value.trim(),
    startTags: startTags.toList(),
    endTags: endTags.toList(),
    howTags: howTags.toList(),
  );

  void save() {
    if (!valid) {
      Get.snackbar('Invalid time', '"Woke up" must be after "Fell asleep".');
      return;
    }
    final model = toModel();
    Get.find<EventsController>().upsertSleep(model);
    Get.back(); // close sheet
  }

  void delete() {
    if (editingId != null) {
      Get.find<EventsController>().remove(editingId!);
      Get.back();
    }
  }

  // Tag toggle methods
  void toggleStartTag(String tag) {
    if (startTags.contains(tag)) {
      startTags.remove(tag);
    } else {
      startTags.add(tag);
    }
  }

  void toggleEndTag(String tag) {
    if (endTags.contains(tag)) {
      endTags.remove(tag);
    } else {
      endTags.add(tag);
    }
  }

  void toggleHowTag(String tag) {
    if (howTags.contains(tag)) {
      howTags.remove(tag);
    } else {
      howTags.add(tag);
    }
  }

  // Set times
  void setFellAsleepTime(DateTime time) {
    fellAsleep.value = time;
  }

  void setWokeUpTime(DateTime time) {
    wokeUp.value = time;
  }

  // Update comment
  void updateComment(String text) {
    if (text.length <= 300) {
      comment.value = text;
    }
  }

  // Get character count for comment
  int get commentCharacterCount => comment.value.length;
  int get commentRemainingCharacters => 300 - comment.value.length;
  bool get commentAtLimit => comment.value.length >= 300;
}
