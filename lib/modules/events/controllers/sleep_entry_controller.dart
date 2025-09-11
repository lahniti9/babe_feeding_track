import 'package:get/get.dart';
import '../models/sleep_event.dart';
import 'events_controller.dart';

class SleepEntryController extends GetxController {
  SleepEntryController({SleepEvent? initial, required this.childId}) {
    if (initial != null) {
      editingId = initial.id;
      fellAsleep.value = initial.fellAsleep;
      wokeUp.value = initial.wokeUp;
      comment.value = initial.comment ?? '';
      startTag.value = initial.startTags.isNotEmpty ? initial.startTags.first : null;
      endTag.value = initial.endTags.isNotEmpty ? initial.endTags.first : null;
      howTag.value = initial.howTags.isNotEmpty ? initial.howTags.first : null;
      isEdit.value = true;
    }
  }

  final String childId;
  String? editingId;

  final isEdit = false.obs;
  final fellAsleep = DateTime.now().obs;
  final wokeUp = DateTime.now().obs;

  final comment = ''.obs;
  final RxnString startTag = RxnString(); // Single selection
  final RxnString endTag = RxnString();   // Single selection
  final RxnString howTag = RxnString();   // Single selection

  bool get valid => !wokeUp.value.isBefore(fellAsleep.value);

  SleepEvent toModel() => SleepEvent(
    id: editingId ?? 'sleep_${DateTime.now().millisecondsSinceEpoch}',
    childId: childId,
    fellAsleep: fellAsleep.value,
    wokeUp: wokeUp.value,
    comment: comment.value.isEmpty ? null : comment.value.trim(),
    startTags: startTag.value != null ? [startTag.value!] : [],
    endTags: endTag.value != null ? [endTag.value!] : [],
    howTags: howTag.value != null ? [howTag.value!] : [],
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

  // Tag selection methods (single selection)
  void toggleStartTag(String tag) {
    if (startTag.value == tag) {
      startTag.value = null; // Deselect if already selected
    } else {
      startTag.value = tag; // Select new tag
    }
  }

  void toggleEndTag(String tag) {
    if (endTag.value == tag) {
      endTag.value = null; // Deselect if already selected
    } else {
      endTag.value = tag; // Select new tag
    }
  }

  void toggleHowTag(String tag) {
    if (howTag.value == tag) {
      howTag.value = null; // Deselect if already selected
    } else {
      howTag.value = tag; // Select new tag
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
