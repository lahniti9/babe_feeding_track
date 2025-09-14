import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/stats_models.dart';
import '../../events/services/events_store.dart';
import '../../events/models/event_record.dart';

class HeadCircController extends GetxController {
  final String childId;

  HeadCircController({required this.childId});

  // Observable state
  final _isLoading = false.obs;
  final _measurements = <Point>[].obs;
  final _selectedPeriod = 'Month'.obs;
  final _useMetric = true.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<Point> get measurements => _measurements;
  RxString get selectedPeriod => _selectedPeriod;
  RxBool get useMetric => _useMetric;

  @override
  void onInit() {
    super.onInit();
    _loadMeasurements();

    // Listen to events store changes
    try {
      final eventsStore = Get.find<EventsStore>();
      eventsStore.items.listen((_) => _loadMeasurements());
    } catch (e) {
      debugPrint('EventsStore not available: $e');
    }
  }

  void _loadMeasurements() {
    _isLoading.value = true;

    try {
      // Get range based on selected period
      final range = _getRangeForPeriod(_selectedPeriod.value);

      // Get head circumference events from EventsStore
      final eventsStore = Get.find<EventsStore>();
      final headCircEvents = eventsStore.getByChild(childId)
          .where((e) => e.type == EventType.headCircumference)
          .where((e) => e.startAt.isAfter(range.start) && e.startAt.isBefore(range.end))
          .toList();

      // Convert to Point objects for chart display
      final measurements = headCircEvents.map((e) {
        final valueCm = e.data['valueCm'] as num? ?? 0;
        return Point(e.startAt, valueCm.toDouble());
      }).toList();

      // Sort by date
      measurements.sort((a, b) => a.x.compareTo(b.x));
      _measurements.value = measurements;

    } catch (e) {
      debugPrint('Error loading head circumference measurements: $e');
      _measurements.value = [];
    } finally {
      _isLoading.value = false;
    }
  }

  void changePeriod(String period) {
    _selectedPeriod.value = period;
    _loadMeasurements();
  }

  void toggleMetric() {
    _useMetric.value = !_useMetric.value;
  }

  StatsRange _getRangeForPeriod(String period) {
    switch (period) {
      case 'Week':
        return StatsRange.lastWeek();
      case 'Month':
        return StatsRange.last3Months();
      case 'Year':
        return StatsRange.lastYear();
      default:
        return StatsRange.last3Months();
    }
  }
}
