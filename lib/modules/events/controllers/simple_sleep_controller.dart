import 'dart:async';
import 'package:get/get.dart';
import '../models/sleep_event.dart';
import 'events_controller.dart';
import '../../children/services/children_store.dart';

class SimpleSleepController extends GetxController {
  // Timer state
  final RxBool running = false.obs;
  final Rx<DateTime?> fellAsleep = Rx<DateTime?>(null);
  final Rx<DateTime?> wokeUp = Rx<DateTime?>(null);
  final Rx<Duration> elapsed = Duration.zero.obs;
  Timer? ticker;

  @override
  void onClose() {
    ticker?.cancel();
    super.onClose();
  }

  // Start timer
  void startTimer() {
    if (running.value) return;
    
    running.value = true;
    fellAsleep.value = DateTime.now();
    elapsed.value = Duration.zero;
    
    ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (fellAsleep.value != null) {
        elapsed.value = DateTime.now().difference(fellAsleep.value!);
      }
    });
  }

  // Pause timer
  void pauseTimer() {
    running.value = false;
    ticker?.cancel();
  }

  // Stop timer and save as SleepEvent
  void stopTimerAndSave() {
    if (fellAsleep.value == null) return;

    running.value = false;
    ticker?.cancel();
    wokeUp.value = DateTime.now();

    // Create a clean SleepEvent with no tags initially
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

    final sleepEvent = SleepEvent(
      id: 'sleep_${DateTime.now().millisecondsSinceEpoch}',
      childId: activeChildId,
      fellAsleep: fellAsleep.value!,
      wokeUp: wokeUp.value!,
      comment: null, // No comment initially
      startTags: [], // No start tags initially
      endTags: [], // No end tags initially
      howTags: [], // No how tags initially
    );

    final eventsController = Get.find<EventsController>();
    eventsController.upsertSleep(sleepEvent);

    Get.back();
    _reset();
  }





  // Reset timer
  void resetTimer() {
    running.value = false;
    ticker?.cancel();
    fellAsleep.value = null;
    wokeUp.value = null;
    elapsed.value = Duration.zero;
  }

  // Reset all state
  void _reset() {
    running.value = false;
    ticker?.cancel();
    fellAsleep.value = null;
    wokeUp.value = null;
    elapsed.value = Duration.zero;
  }



  // Format timer display
  String get timerDisplay {
    final minutes = elapsed.value.inMinutes;
    final seconds = elapsed.value.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Check if timer can be stopped
  bool get canStopTimer {
    return running.value && fellAsleep.value != null;
  }
}
