import 'package:get/get.dart';
import '../models/event_record.dart';
import 'base/measure_event_controller.dart';

class WeightController extends MeasureEventController {
  final pounds = 0.obs;
  final ounces = 0.obs;
  final isMetric = false.obs;

  @override
  EventType get eventType => EventType.weight;

  @override
  List<String> get unitOptions => ['lb/oz', 'kg'];

  @override
  String get defaultUnit => 'lb/oz';

  @override
  double? get minValue => 0.0;

  @override
  double? get maxValue => isMetric.value ? 50.0 : 110.0;

  @override
  int get decimals => isMetric.value ? 2 : 0;

  @override
  Map<String, dynamic> get additionalData {
    if (isMetric.value) {
      return {
        'valueKg': value.value,
        'displayUnit': 'kg',
      };
    } else {
      return {
        'valueKg': _poundsOuncesToKg(pounds.value, ounces.value),
        'displayUnit': 'lb/oz',
        'pounds': pounds.value,
        'ounces': ounces.value,
      };
    }
  }

  @override
  void setUnit(String newUnit) {
    super.setUnit(newUnit);
    isMetric.value = newUnit == 'kg';
    if (isMetric.value) {
      // Convert from lb/oz to kg
      value.value = _poundsOuncesToKg(pounds.value, ounces.value);
    } else {
      // Convert from kg to lb/oz
      final totalOunces = (value.value * 35.274).round();
      pounds.value = totalOunces ~/ 16;
      ounces.value = totalOunces % 16;
    }
  }

  void setPounds(int newPounds) {
    pounds.value = newPounds;
    value.value = _poundsOuncesToKg(pounds.value, ounces.value);
  }

  void setOunces(int newOunces) {
    ounces.value = newOunces;
    value.value = _poundsOuncesToKg(pounds.value, ounces.value);
  }

  double _poundsOuncesToKg(int lbs, int oz) {
    return (lbs * 16 + oz) * 0.0283495;
  }

  String get displayText {
    if (isMetric.value) {
      return '${value.value.toStringAsFixed(2)} kg';
    } else {
      return '${pounds.value} lb ${ounces.value} oz';
    }
  }
}
