import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../events/models/sleep_event.dart';
import '../models/stats_models.dart';
import '../services/stats_aggregator.dart';

class SleepingController extends GetxController {
  final String childId;
  final _storage = GetStorage();

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
  }

  void _loadSleepingData() {
    _isLoading.value = true;
    
    try {
      _loadDurationData();
      _loadHourlyData();
    } catch (e) {
      print('Error loading sleeping data: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void _loadDurationData() {
    final range = _getRangeForPeriod(_durationPeriod.value);
    
    // Load sleep events from storage
    final sleepEventsData = _storage.read('sleep_events') ?? [];
    final sleepEvents = (sleepEventsData as List)
        .map((e) => SleepEvent.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    // Get duration data using the aggregator
    final durationData = StatsAggregator.sleepDurationByBucket(
      childId,
      range,
      sleepEvents,
    );

    _durationData.value = durationData;
  }

  void _loadHourlyData() {
    final range = _getRangeForPeriod(_hourlyPeriod.value);
    
    // Load sleep events from storage
    final sleepEventsData = _storage.read('sleep_events') ?? [];
    final sleepEvents = (sleepEventsData as List)
        .map((e) => SleepEvent.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    // Get hourly histogram data
    final hourlyData = StatsAggregator.sleepHistogramByHour(
      childId,
      range.start,
      range.end,
      sleepEvents,
    );

    _hourlyData.value = hourlyData;
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
