import 'package:get/get.dart';
import '../models/event_record.dart';
import 'base/timer_event_controller.dart';

class WalkingController extends TimerEventController {
  final mode = <String>{}.obs;
  final place = <String>{}.obs;

  @override
  EventType get eventType => EventType.walking;

  @override
  Map<String, dynamic> get additionalData => {
    'mode': mode.toList(),
    'place': place.toList(),
  };

  void toggleMode(String modeOption) {
    mode.clear(); // Only one mode at a time
    mode.add(modeOption);
  }

  void togglePlace(String placeOption) {
    place.clear(); // Only one place at a time
    place.add(placeOption);
  }
}
