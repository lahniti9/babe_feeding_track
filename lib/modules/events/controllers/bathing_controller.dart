import 'package:get/get.dart';
import '../models/event_record.dart';
import 'base/timer_event_controller.dart';

class BathingController extends TimerEventController {
  final aids = <String>{}.obs;
  final mood = <String>{}.obs;

  @override
  EventType get eventType => EventType.bathing;

  @override
  Map<String, dynamic> get additionalData => {
    'aids': aids.toList(),
    'mood': mood.toList(),
  };

  void toggleAid(String aid) {
    if (aids.contains(aid)) {
      aids.remove(aid);
    } else {
      aids.add(aid);
    }
  }

  void toggleMood(String moodOption) {
    if (mood.contains(moodOption)) {
      mood.remove(moodOption);
    } else {
      mood.add(moodOption);
    }
  }
}
