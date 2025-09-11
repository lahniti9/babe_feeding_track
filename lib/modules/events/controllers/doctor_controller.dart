import 'package:get/get.dart';
import '../models/event_record.dart';
import 'base/tag_event_controller.dart';

class DoctorController extends TagEventController {
  final reason = <String>{}.obs;
  final outcome = <String>{}.obs;

  @override
  EventType get eventType => EventType.doctor;

  @override
  Map<String, RxSet<String>> get chipGroups => {
    'reason': reason,
    'outcome': outcome,
  };

  @override
  Map<String, dynamic> get additionalData => {};
}
