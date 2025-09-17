import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/cry_event.dart';
import 'events_controller.dart';
import '../../children/services/children_store.dart';

class CryController extends GetxController {
  final time = DateTime.now().obs;
  final sounds = <CrySound>{}.obs;
  final volumes = <CryVolume>{}.obs;
  final rhythms = <CryRhythm>{}.obs;
  final durations = <CryDuration>{}.obs;
  final behaviours = <CryBehaviour>{}.obs;
  final comment = ''.obs;

  void toggle<T>(RxSet<T> set, T value) {
    if (set.contains(value)) {
      set.remove(value);
    } else {
      set.add(value);
    }
  }

  void toggleSound(CrySound sound) => toggle(sounds, sound);
  void toggleVolume(CryVolume volume) => toggle(volumes, volume);
  void toggleRhythm(CryRhythm rhythm) => toggle(rhythms, rhythm);
  void toggleDuration(CryDuration duration) => toggle(durations, duration);
  void toggleBehaviour(CryBehaviour behaviour) => toggle(behaviours, behaviour);

  void setTime(DateTime newTime) {
    time.value = newTime;
  }

  void setComment(String newComment) {
    comment.value = newComment;
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

    final event = CryEvent(
      id: const Uuid().v4(),
      childId: activeChildId,
      time: time.value,
      sounds: sounds.toSet(),
      volume: volumes.toSet(),
      rhythm: rhythms.toSet(),
      duration: durations.toSet(),
      behaviour: behaviours.toSet(),
      comment: commentText.isEmpty ? null : commentText,
    );

    Get.find<EventsController>().addCryEvent(event);
    Get.back();
  }
}
