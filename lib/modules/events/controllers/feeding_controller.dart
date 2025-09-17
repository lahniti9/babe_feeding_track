import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/breast_feeding_event.dart';
import 'events_controller.dart';
import '../../children/services/children_store.dart';
import '../views/add_volume_sheet.dart';
import '../views/feeding_edit_view.dart';

class FeedingController extends GetxController with WidgetsBindingObserver {
  final startAt = DateTime.now().obs;
  final leftSec = 0.obs;
  final rightSec = 0.obs;
  final lastSide = 'Left'.obs;

  final Stopwatch _left = Stopwatch();
  final Stopwatch _right = Stopwatch();
  Timer? _ticker;

  bool get leftRunning => _left.isRunning;
  bool get rightRunning => _right.isRunning;
  bool get anyRunning => leftRunning || rightRunning;

  int get totalSec => leftSec.value + rightSec.value;
  String get totalTime => prettySecs(totalSec);

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_left.isRunning) leftSec.value = _left.elapsed.inSeconds;
      if (_right.isRunning) rightSec.value = _right.elapsed.inSeconds;
    });
  }

  void toggleLeft() {
    if (_left.isRunning) {
      _left.stop();
    } else {
      _left.start();
      _right.stop();
      lastSide.value = 'Left';
    }
    leftSec.value = _left.elapsed.inSeconds;
  }

  void toggleRight() {
    if (_right.isRunning) {
      _right.stop();
    } else {
      _right.start();
      _left.stop();
      lastSide.value = 'Right';
    }
    rightSec.value = _right.elapsed.inSeconds;
  }

  void reset() {
    _left.reset();
    _right.reset();
    leftSec.value = 0;
    rightSec.value = 0;
  }

  void setStartTime(DateTime time) {
    startAt.value = time;
  }

  Future<void> completeFlow() async {
    // Stop any running timers
    _left.stop();
    _right.stop();

    // Step 1: Optional volume sheet
    final vol = await Get.bottomSheet<int?>(
      AddVolumeSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );

    // Step 2: Save event
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
    
    final event = BreastFeedingEvent(
      id: const Uuid().v4(),
      childId: activeChildId,
      startAt: startAt.value,
      left: Duration(seconds: leftSec.value),
      right: Duration(seconds: rightSec.value),
      volumeOz: vol,
    );

    Get.find<EventsController>().addFeedingEvent(event);

    // Step 3: Close current sheet and open edit summary
    Get.back(); // Close feeding timer sheet
    
    Get.bottomSheet(
      FeedingEditView(event: event),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  void onClose() {
    _ticker?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app going to background/foreground
    // The Stopwatch continues running, so we just need to update the display
    if (state == AppLifecycleState.resumed) {
      if (_left.isRunning) leftSec.value = _left.elapsed.inSeconds;
      if (_right.isRunning) rightSec.value = _right.elapsed.inSeconds;
    }
  }
}
