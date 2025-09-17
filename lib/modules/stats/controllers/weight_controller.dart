import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/stats_models.dart';
import '../../events/services/events_store.dart';
import '../../events/models/event_record.dart';

class WeightController extends GetxController {
  final String childId;

  WeightController({required this.childId});

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

      // Use EventsStore directly since it's working reliably
      _loadFromEventsStore(range);

    } catch (e) {
      debugPrint('Error setting up weight measurements: $e');
      _measurements.value = [];
      _isLoading.value = false;
    }
  }

  void _loadFromEventsStore(StatsRange range) {
    try {
      final eventsStore = Get.find<EventsStore>();

      final allEvents = eventsStore.getByChild(childId);
      final weightEvents = allEvents
          .where((e) => e.type == EventType.weight)
          .where((e) => e.startAt.isAfter(range.start.subtract(const Duration(microseconds: 1))) &&
                       e.startAt.isBefore(range.end.add(const Duration(microseconds: 1))))
          .toList();

      _processWeightEvents(weightEvents);
    } catch (e) {
      debugPrint('EventsStore failed: $e');
      _measurements.value = [];
      _isLoading.value = false;
    }
  }

  void _processWeightEvents(List<EventRecord> weightEvents) {
    // Convert to Point objects for chart display
    final measurements = <Point>[];
    for (final event in weightEvents) {
      // Try multiple possible keys for weight value
      final valueKg = (event.data['valueKg'] as num?) ??
                     (event.data['value'] as num?) ?? 0;

      if (valueKg > 0) {
        // Convert kg to grams for consistency with chart expectations
        measurements.add(Point(event.startAt, valueKg.toDouble() * 1000));
      }
    }

    // Sort by date
    measurements.sort((a, b) => a.x.compareTo(b.x));
    _measurements.value = measurements;
    _isLoading.value = false;
  }

  void changePeriod(String period) {
    _selectedPeriod.value = period;
    _loadMeasurements();
  }

  void toggleMetric() {
    _useMetric.value = !_useMetric.value;
  }

  void openFullReport() {
    // Navigate to full report - app is completely free
    Get.snackbar(
      'Full Report',
      'Detailed weight analysis and trends',
      backgroundColor: Colors.blue.withValues(alpha: 0.2),
      colorText: Colors.blue,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  StatsRange _getRangeForPeriod(String period) {
    switch (period) {
      case 'Week':
        return StatsRange.lastWeek();
      case 'Month':
        return StatsRange.lastMonth();
      default:
        return StatsRange.lastMonth();
    }
  }
}
