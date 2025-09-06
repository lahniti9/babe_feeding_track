import 'dart:async';
import 'package:get/get.dart';
import '../models/event.dart';
import 'events_controller.dart';

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

  // Stop timer and save as EventModel (for now)
  void stopTimerAndSave() {
    if (fellAsleep.value == null) return;

    running.value = false;
    ticker?.cancel();
    wokeUp.value = DateTime.now();

    final duration = wokeUp.value!.difference(fellAsleep.value!);
    final durationText = _formatDuration(duration);

    // Create EventModel for compatibility
    final event = EventModel(
      id: 'sleep_${DateTime.now().millisecondsSinceEpoch}',
      kind: EventKind.sleeping,
      time: fellAsleep.value!,
      endTime: wokeUp.value,
      title: 'Naji slept $durationText',
      subtitle: 'Start of sleep: content\nEnd of sleep: woke up naturally\nHow: nursing',
      showPlus: true,
    );

    final eventsController = Get.find<EventsController>();
    eventsController.addEvent(event);

    Get.back();
    _reset();
  }

  // Format duration for display
  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours} hr${duration.inHours > 1 ? 's' : ''}, ${duration.inMinutes % 60} min';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} min';
    } else {
      return '${duration.inSeconds} sec${duration.inSeconds != 1 ? 's' : ''}';
    }
  }

  // Open exact time view
  void openExactTimeView() {
    Get.toNamed('/sleep-exact');
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
