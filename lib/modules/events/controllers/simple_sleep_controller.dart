import 'dart:async';
import 'package:get/get.dart';
import '../models/sleep_event.dart';
import 'events_controller.dart';
import '../../children/services/children_store.dart';

class SimpleSleepController extends GetxController {
  // Timer state
  final RxBool running = false.obs;
  final Rx<DateTime?> sessionStartTime = Rx<DateTime?>(null);
  final Rx<Duration> totalElapsed = Duration.zero.obs;
  final Rx<Duration> currentSessionElapsed = Duration.zero.obs;
  DateTime? currentSessionStart;
  Timer? ticker;

  @override
  void onClose() {
    ticker?.cancel();
    super.onClose();
  }

  // Start or continue timer
  void startTimer() {
    if (running.value) return;

    running.value = true;

    // If this is the first time starting, record the session start
    if (sessionStartTime.value == null) {
      sessionStartTime.value = DateTime.now();
    }

    // Record when this current session segment starts
    currentSessionStart = DateTime.now();
    currentSessionElapsed.value = Duration.zero;

    ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentSessionStart != null) {
        currentSessionElapsed.value = DateTime.now().difference(currentSessionStart!);
      }
    });
  }

  // Pause timer (but keep the accumulated time)
  void pauseTimer() {
    if (!running.value) return;

    running.value = false;
    ticker?.cancel();

    // Add current session time to total elapsed time
    if (currentSessionStart != null) {
      final sessionDuration = DateTime.now().difference(currentSessionStart!);
      totalElapsed.value = totalElapsed.value + sessionDuration;
    }

    currentSessionStart = null;
    currentSessionElapsed.value = Duration.zero;
  }

  // Stop timer and save as SleepEvent
  void stopTimerAndSave() {
    if (sessionStartTime.value == null) return;

    // If timer is currently running, pause it first to capture the final time
    if (running.value) {
      pauseTimer();
    }

    final wokeUpTime = DateTime.now();

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
      fellAsleep: sessionStartTime.value!,
      wokeUp: wokeUpTime,
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





  // Reset timer completely
  void resetTimer() {
    running.value = false;
    ticker?.cancel();
    sessionStartTime.value = null;
    totalElapsed.value = Duration.zero;
    currentSessionElapsed.value = Duration.zero;
    currentSessionStart = null;
  }

  // Reset all state
  void _reset() {
    running.value = false;
    ticker?.cancel();
    sessionStartTime.value = null;
    totalElapsed.value = Duration.zero;
    currentSessionElapsed.value = Duration.zero;
    currentSessionStart = null;
  }

  // Get total elapsed time (accumulated + current session)
  Duration get totalElapsedTime {
    if (running.value && currentSessionStart != null) {
      return totalElapsed.value + currentSessionElapsed.value;
    }
    return totalElapsed.value;
  }

  // Format timer display
  String get timerDisplay {
    final total = totalElapsedTime;
    final minutes = total.inMinutes;
    final seconds = total.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Check if timer can be stopped (has recorded some time)
  bool get canStopTimer {
    return sessionStartTime.value != null && totalElapsedTime.inSeconds > 0;
  }

  // Toggle timer (start if stopped, pause if running)
  void toggleTimer() {
    if (running.value) {
      pauseTimer();
    } else {
      startTimer();
    }
  }
}
