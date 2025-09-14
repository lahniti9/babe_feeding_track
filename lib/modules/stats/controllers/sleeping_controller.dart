import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../events/models/sleep_event.dart';
import '../models/stats_models.dart';
import '../../events/services/events_store.dart';
import '../../events/models/event_record.dart';
import '../../events/controllers/events_controller.dart';

class SleepingController extends GetxController {
  final String childId;

  SleepingController({required this.childId});

  // Observable state
  final _isLoading = false.obs;
  final _durationData = <Bar>[].obs;
  final _hourlyData = <Bar>[].obs;
  final _durationPeriod = 'Month'.obs;
  final _hourlyPeriod = 'Month'.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<Bar> get durationData => _durationData;
  List<Bar> get hourlyData => _hourlyData;
  RxString get durationPeriod => _durationPeriod;
  RxString get hourlyPeriod => _hourlyPeriod;

  @override
  void onInit() {
    super.onInit();
    _loadSleepingData();

    // Listen to events store changes
    try {
      final eventsStore = Get.find<EventsStore>();
      eventsStore.items.listen((_) => _loadSleepingData());
    } catch (e) {
      debugPrint('EventsStore not available: $e');
    }

    // Listen to events controller changes for sleep events
    try {
      final eventsController = Get.find<EventsController>();
      eventsController.events.listen((_) => _loadSleepingData());
    } catch (e) {
      debugPrint('EventsController not available: $e');
    }
  }

  void _loadSleepingData() {
    _isLoading.value = true;

    try {
      _loadDurationData();
      _loadHourlyData();
    } catch (e) {
      debugPrint('Error loading sleeping data: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void _loadDurationData() {
    final range = _getRangeForPeriod(_durationPeriod.value);

    // Get sleep events from EventsStore
    final eventsStore = Get.find<EventsStore>();
    final sleepEventRecords = eventsStore.getByChild(childId)
        .where((e) => e.type == EventType.sleeping)
        .where((e) => e.startAt.isAfter(range.start) && e.startAt.isBefore(range.end))
        .toList();

    // Get sleep events from EventsController
    final eventsController = Get.find<EventsController>();
    final sleepEvents = eventsController.events
        .whereType<SleepEvent>()
        .where((e) => e.childId == childId)
        .where((e) => e.fellAsleep.isAfter(range.start) && e.fellAsleep.isBefore(range.end))
        .toList();

    // Group by day and sum durations
    final durationByDay = <String, double>{};

    // Process EventRecord sleep events
    for (final event in sleepEventRecords) {
      final dayKey = DateTimeUtils.bucketKey(event.startAt, range.bucket);
      final duration = event.endAt != null
          ? event.endAt!.difference(event.startAt).inMinutes.toDouble()
          : 0.0;
      durationByDay[dayKey] = (durationByDay[dayKey] ?? 0.0) + duration;
    }

    // Process SleepEvent objects
    for (final event in sleepEvents) {
      final dayKey = DateTimeUtils.bucketKey(event.fellAsleep, range.bucket);
      final duration = event.duration.inMinutes.toDouble();
      durationByDay[dayKey] = (durationByDay[dayKey] ?? 0.0) + duration;
    }

    _durationData.value = durationByDay.entries
        .map((e) => Bar(e.key, e.value))
        .toList()
      ..sort((a, b) => a.x.toString().compareTo(b.x.toString()));
  }

  void _loadHourlyData() {
    final range = _getRangeForPeriod(_hourlyPeriod.value);

    // Get sleep events from EventsStore
    final eventsStore = Get.find<EventsStore>();
    final sleepEventRecords = eventsStore.getByChild(childId)
        .where((e) => e.type == EventType.sleeping)
        .where((e) => e.startAt.isAfter(range.start) && e.startAt.isBefore(range.end))
        .toList();

    // Get sleep events from EventsController
    final eventsController = Get.find<EventsController>();
    final sleepEvents = eventsController.events
        .whereType<SleepEvent>()
        .where((e) => e.childId == childId)
        .where((e) => e.fellAsleep.isAfter(range.start) && e.fellAsleep.isBefore(range.end))
        .toList();

    // Create hourly histogram (24 hours)
    final hourlyMinutes = List<double>.filled(24, 0.0);

    // Process EventRecord sleep events
    for (final event in sleepEventRecords) {
      if (event.endAt != null) {
        _addSleepToHourlyData(event.startAt, event.endAt!, hourlyMinutes);
      }
    }

    // Process SleepEvent objects
    for (final event in sleepEvents) {
      _addSleepToHourlyData(event.fellAsleep, event.wokeUp, hourlyMinutes);
    }

    _hourlyData.value = hourlyMinutes
        .asMap()
        .entries
        .map((e) => Bar(e.key.toDouble(), e.value))
        .toList();
  }

  void _addSleepToHourlyData(DateTime start, DateTime end, List<double> hourlyMinutes) {
    // Add sleep duration to each hour it spans
    var current = start;
    while (current.isBefore(end)) {
      final hour = current.hour;
      final nextHour = DateTime(current.year, current.month, current.day, hour + 1);
      final endOfThisHour = nextHour.isBefore(end) ? nextHour : end;
      final minutesInThisHour = endOfThisHour.difference(current).inMinutes.toDouble();

      hourlyMinutes[hour] += minutesInThisHour;
      current = nextHour;
    }
  }

  void changeDurationPeriod(String period) {
    _durationPeriod.value = period;
    _loadDurationData();
  }

  void changeHourlyPeriod(String period) {
    _hourlyPeriod.value = period;
    _loadHourlyData();
  }

  void openFullReport() {
    Get.snackbar(
      'Premium Feature',
      'Full sleep report is available with premium subscription',
      backgroundColor: Colors.purple.withValues(alpha: 0.2),
      colorText: Colors.purple,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  StatsRange _getRangeForPeriod(String period) {
    switch (period) {
      case 'Day':
        return StatsRange.lastWeek();
      case 'Month':
        return StatsRange.lastMonth();
      case 'Year':
        return StatsRange.lastYear();
      default:
        return StatsRange.lastMonth();
    }
  }
}
