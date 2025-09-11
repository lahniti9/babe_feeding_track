import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/event.dart';
import '../../events/models/event.dart';
import '../models/stats_models.dart';
import '../services/stats_aggregator.dart';
import '../../profile/profile_controller.dart';
import '../../events/services/events_store.dart';
import '../../events/models/event_record.dart' as er;

class WeightController extends GetxController {
  final String childId;
  final _storage = GetStorage();

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
    _loadMetricPreference();
    _loadMeasurements();
  }

  void _loadMetricPreference() {
    try {
      final profileController = Get.find<ProfileController>();
      _useMetric.value = profileController.metricSystem.name == 'metric';
    } catch (e) {
      // Default to metric if profile controller not found
      _useMetric.value = true;
    }
  }

  void _loadMeasurements() {
    _isLoading.value = true;

    try {
      // Get range based on selected period
      final range = _getRangeForPeriod(_selectedPeriod.value);

      // Load events from storage
      final eventsData = _storage.read('events') ?? [];
      final events = (eventsData as List)
          .map((e) => Event.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      // Load EventModel events from storage
      final eventModelsData = _storage.read('events_v2') ?? [];
      final eventModels = (eventModelsData as List)
          .map((e) => EventModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      // Get measurements from both event systems
      final oldMeasurements = StatsAggregator.measurements(
        EventType.weight,
        childId,
        range,
        events,
      );

      final newMeasurements = StatsAggregator.measurementsFromEventModel(
        EventKind.weight,
        childId,
        range,
        eventModels,
      );

      // Also get from new EventsStore
      try {
        final eventsStore = Get.find<EventsStore>();
        final weightEvents = eventsStore.getByChild(childId)
            .where((e) => e.type == er.EventType.weight)
            .where((e) => e.startAt.isAfter(range.start) && e.startAt.isBefore(range.end))
            .toList();

        final newSystemMeasurements = weightEvents.map((e) {
          final valueKg = e.data['valueKg'] as num? ?? 0;
          return Point(e.startAt, valueKg.toDouble() * 1000); // Convert to grams for consistency
        }).toList();

        // Combine all measurements
        final allMeasurements = [...oldMeasurements, ...newMeasurements, ...newSystemMeasurements];
        allMeasurements.sort((a, b) => a.x.compareTo(b.x));

        _measurements.value = allMeasurements;
      } catch (e) {
        // EventsStore not available, use old system only
        final allMeasurements = [...oldMeasurements, ...newMeasurements];
        allMeasurements.sort((a, b) => a.x.compareTo(b.x));
        _measurements.value = allMeasurements;
      }
    } catch (e) {
      print('Error loading weight measurements: $e');
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

  void openFullReport() {
    // Show paywall or navigate to full report
    Get.snackbar(
      'Premium Feature',
      'Full weight report is available with premium subscription',
      backgroundColor: Colors.orange.withValues(alpha: 0.2),
      colorText: Colors.orange,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
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
