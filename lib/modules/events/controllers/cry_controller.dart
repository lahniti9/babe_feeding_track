import 'package:get/get.dart';
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

  Future<void> save() async {
    final childrenStore = Get.find<ChildrenStore>();
    final activeChildId = childrenStore.activeId.value ?? 'default-child';
    
    final event = CryEvent(
      id: 'cry_${DateTime.now().millisecondsSinceEpoch}',
      childId: activeChildId,
      time: time.value,
      sounds: sounds.toSet(),
      volume: volumes.toSet(),
      rhythm: rhythms.toSet(),
      duration: durations.toSet(),
      behaviour: behaviours.toSet(),
    );
    
    Get.find<EventsController>().addCryEvent(event);
    Get.back();
  }
}
