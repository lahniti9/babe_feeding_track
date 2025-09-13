import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../models/event_record.dart';
import '../../services/events_store.dart';
import '../../../children/services/children_store.dart';

abstract class TimerEventController extends GetxController with WidgetsBindingObserver {
  final startAt = DateTime.now().obs;
  final seconds = 0.obs;
  final isRunning = false.obs;

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _ticker;

  // Abstract properties to be implemented by subclasses
  EventType get eventType;
  Map<String, dynamic> get additionalData;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_stopwatch.isRunning) {
        seconds.value = _stopwatch.elapsed.inSeconds;
      }
    });
  }

  void toggle() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      isRunning.value = false;
    } else {
      _stopwatch.start();
      isRunning.value = true;
    }
    seconds.value = _stopwatch.elapsed.inSeconds;
  }

  void reset() {
    _stopwatch.reset();
    seconds.value = 0;
    isRunning.value = false;
  }

  void setStartTime(DateTime time) {
    startAt.value = time;
  }

  String get timeText {
    final s = seconds.value;
    return s >= 60 
      ? '${(s~/60).toString().padLeft(2,'0')}:${(s%60).toString().padLeft(2,'0')}'
      : '$s secs';
  }

  Future<void> save() async {
    // Stop timer if running
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      isRunning.value = false;
    }

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

    final data = {
      'seconds': seconds.value,
      ...additionalData,
    };

    await Get.find<EventsStore>().add(EventRecord(
      id: const Uuid().v4(),
      childId: activeChildId,
      type: eventType,
      startAt: startAt.value,
      endAt: startAt.value.add(Duration(seconds: seconds.value)),
      data: data,
    ));

    Get.back();
  }

  @override
  void onClose() {
    _ticker?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _stopwatch.isRunning) {
      seconds.value = _stopwatch.elapsed.inSeconds;
    }
  }
}
