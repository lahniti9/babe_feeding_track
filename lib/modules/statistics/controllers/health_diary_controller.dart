import 'package:get/get.dart';
import '../../events/models/event_record.dart';
import '../../events/services/events_store.dart';

class HealthDiaryController extends GetxController {
  HealthDiaryController({required this.childId});
  final String childId;
  
  final entries = <EventRecord>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    Get.find<EventsStore>().watch(
      childId: childId,
      types: {EventType.temperature, EventType.medicine, EventType.doctor},
    ).listen((evts) {
      entries.assignAll(evts.reversed); // latest first
      isLoading.value = false;
    });
  }

  bool get hasData => entries.isNotEmpty;

  List<EventRecord> get temperatureEntries => 
      entries.where((e) => e.type == EventType.temperature).toList();

  List<EventRecord> get medicineEntries => 
      entries.where((e) => e.type == EventType.medicine).toList();

  List<EventRecord> get doctorEntries => 
      entries.where((e) => e.type == EventType.doctor).toList();

  EventRecord? get latestTemperature => temperatureEntries.isNotEmpty 
      ? temperatureEntries.first 
      : null;

  EventRecord? get latestMedicine => medicineEntries.isNotEmpty 
      ? medicineEntries.first 
      : null;

  EventRecord? get latestDoctor => doctorEntries.isNotEmpty 
      ? doctorEntries.first 
      : null;

  String formatTemperature(EventRecord event) {
    final celsius = event.data['celsius'] as num? ?? 0;
    final fahrenheit = (celsius * 9/5) + 32;
    return '${celsius.toStringAsFixed(1)}°C (${fahrenheit.toStringAsFixed(1)}°F)';
  }

  String formatMedicine(EventRecord event) {
    final name = event.data['name'] as String? ?? 'Medicine';
    final dose = event.data['dose'] as num? ?? 0;
    final unit = event.data['unit'] as String? ?? 'ml';
    return '$name $dose$unit';
  }

  String formatDoctor(EventRecord event) {
    final reason = event.data['reason'] as String? ?? 'Visit';
    final outcome = event.data['outcome'] as String? ?? '';
    return outcome.isNotEmpty ? '$reason - $outcome' : reason;
  }

  String getEventTitle(EventRecord event) {
    switch (event.type) {
      case EventType.temperature:
        return 'Temperature';
      case EventType.medicine:
        return 'Medicine';
      case EventType.doctor:
        return 'Doctor Visit';
      default:
        return 'Health Event';
    }
  }

  String getEventSubtitle(EventRecord event) {
    switch (event.type) {
      case EventType.temperature:
        return formatTemperature(event);
      case EventType.medicine:
        return formatMedicine(event);
      case EventType.doctor:
        return formatDoctor(event);
      default:
        return '';
    }
  }
}
