import '../models/event_record.dart';
import 'base/measure_event_controller.dart';

class WeightController extends MeasureEventController {
  @override
  EventType get eventType => EventType.weight;

  @override
  List<String> get unitOptions => ['kg'];

  @override
  String get defaultUnit => 'kg';

  @override
  double? get minValue => 0.0;

  @override
  double? get maxValue => 50.0;

  @override
  int get decimals => 2;

  @override
  Map<String, dynamic> get additionalData {
    return {
      'valueKg': value.value,
      'displayUnit': 'kg',
    };
  }

  // Edit an existing weight event
  void editEvent(EventRecord event) {
    print('WeightController.editEvent called');
    print('Event data: ${event.data}');

    editingEventId = event.id;
    time.value = event.startAt;

    // Load data from event
    final data = event.data;
    value.value = data['value'] as double? ?? 0.0;
    unit.value = data['unit'] as String? ?? 'kg';

    // Load comment if available
    comment.value = event.comment ?? '';

    print('Setting value to: ${value.value} kg');
    print('Setting comment to: "${comment.value}"');
  }

  // Reset controller to default state
  void reset() {
    editingEventId = null;
    time.value = DateTime.now();
    value.value = 0.0;
    unit.value = 'kg';
    comment.value = '';
  }

  String get displayText {
    return '${value.value.toStringAsFixed(2)} kg';
  }
}
