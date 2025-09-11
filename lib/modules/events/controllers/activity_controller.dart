import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/event_record.dart';
import '../services/events_store.dart';
import '../../children/services/children_store.dart';

class ActivityController extends GetxController with WidgetsBindingObserver {
  final time = DateTime.now().obs;
  final running = false.obs;
  final elapsed = 0.obs;
  
  final type = 'tummy_time'.obs;
  final intensity = 'moderate'.obs;
  final note = ''.obs;

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

  void toggle() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      running.value = false;
    } else {
      _stopwatch.start();
      running.value = true;
    }
    elapsed.value = _stopwatch.elapsed.inSeconds;
  }

  void reset() {
    _stopwatch.reset();
    elapsed.value = 0;
    running.value = false;
  }

  void setTime(DateTime newTime) {
    time.value = newTime;
  }

  void setType(String newType) {
    type.value = newType.toLowerCase().replaceAll(' ', '_');
  }

  void setIntensity(String newIntensity) {
    intensity.value = newIntensity.toLowerCase();
  }

  void setNote(String newNote) {
    note.value = newNote;
  }

  String get timeText {
    final s = elapsed.value;
    return s >= 60 
      ? '${(s~/60).toString().padLeft(2,'0')}:${(s%60).toString().padLeft(2,'0')}'
      : '$s secs';
  }

  String get typeDisplayName {
    switch (type.value) {
      case 'tummy_time': return 'Tummy time';
      case 'play_mat': return 'Play mat';
      case 'baby_gym': return 'Baby gym';
      case 'outdoor_walk': return 'Outdoor walk';
      case 'free_play': return 'Free play';
      default: return _capitalizeString(type.value.replaceAll('_', ' '));
    }
  }

  String _capitalizeString(String text) {
    return text.isNotEmpty ? '${text[0].toUpperCase()}${text.substring(1)}' : text;
  }

  Future<void> save() async {
    // Stop timer if running
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      running.value = false;
    }

    final childrenStore = Get.find<ChildrenStore>();
    final activeChildId = childrenStore.activeId.value ?? 'default-child';
    
    final noteText = note.value.trim();

    await Get.find<EventsStore>().add(EventRecord(
      id: const Uuid().v4(),
      childId: activeChildId,
      type: EventType.activity,
      startAt: time.value,
      endAt: time.value.add(Duration(seconds: elapsed.value)),
      data: {
        'type': type.value,
        'intensity': intensity.value,
        'seconds': elapsed.value,
        'note': noteText,
      },
      comment: noteText.isEmpty ? null : noteText,
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
      elapsed.value = _stopwatch.elapsed.inSeconds;
    }
  }
}


