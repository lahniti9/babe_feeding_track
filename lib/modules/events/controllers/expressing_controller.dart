import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/event_record.dart';
import '../services/events_store.dart';
import '../views/expressing_volume_sheet.dart';
import '../../children/services/children_store.dart';

class ExpressingController extends GetxController with WidgetsBindingObserver {
  final time = DateTime.now().obs;
  final elapsed = 0.obs;
  final running = false.obs;
  
  final side = 'both'.obs;
  final method = 'electric'.obs;
  
  // Volume step
  final volume = 0.obs;
  final unit = 'ml'.obs;

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _ticker;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_stopwatch.isRunning) {
        elapsed.value = _stopwatch.elapsed.inSeconds;
      }
    });
  }

  void toggleTimer() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      running.value = false;
    } else {
      _stopwatch.start();
      running.value = true;
    }
    elapsed.value = _stopwatch.elapsed.inSeconds;
  }

  void resetTimer() {
    _stopwatch.reset();
    elapsed.value = 0;
    running.value = false;
  }

  void setSide(String newSide) {
    side.value = newSide.toLowerCase();
  }

  void setMethod(String newMethod) {
    method.value = newMethod.toLowerCase();
  }

  void setTime(DateTime newTime) {
    time.value = newTime;
  }

  String get timeText {
    final s = elapsed.value;
    return s >= 60 
      ? '${(s~/60).toString().padLeft(2,'0')}:${(s%60).toString().padLeft(2,'0')}'
      : '$s secs';
  }

  Future<void> completeFlow() async {
    // Stop timer if running
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      running.value = false;
    }

    // Show volume sheet
    final vol = await Get.bottomSheet<int?>(
      ExpressingVolumeSheet(controller: this),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );

    // Save with or without volume
    await save(withVolume: vol != null);
  }

  Future<void> save({bool withVolume = true}) async {
    final childrenStore = Get.find<ChildrenStore>();
    final activeChildId = childrenStore.activeId.value ?? 'default-child';
    
    final data = {
      'seconds': elapsed.value,
      'side': side.value,
      'method': method.value,
      if (withVolume) 'volume': volume.value,
      if (withVolume) 'unit': unit.value,
    };

    await Get.find<EventsStore>().add(EventRecord(
      id: const Uuid().v4(),
      childId: activeChildId,
      type: EventType.expressing,
      startAt: time.value,
      endAt: time.value.add(Duration(seconds: elapsed.value)),
      data: data,
    ));
    
    Get.back(); // Close current sheet
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
      elapsed.value = _stopwatch.elapsed.inSeconds;
    }
  }
}
