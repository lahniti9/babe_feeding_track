import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/event.dart';
import '../../events/models/event.dart';
import '../models/stats_models.dart';
import '../services/stats_aggregator.dart';

class FeedingController extends GetxController {
  final String childId;
  final _storage = GetStorage();

  FeedingController({required this.childId});

  // Observable state
  final _isLoading = false.obs;
  final _volumeData = <Bar>[].obs;
  final _countData = <Bar>[].obs;
  final _breastFeedingData = <Bar>[].obs;
  final _volumePeriod = 'Week'.obs;
  final _countPeriod = 'Week'.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<Bar> get volumeData => _volumeData;
  List<Bar> get countData => _countData;
  List<Bar> get breastFeedingData => _breastFeedingData;
  RxString get volumePeriod => _volumePeriod;
  RxString get countPeriod => _countPeriod;

  @override
  void onInit() {
    super.onInit();
    _loadFeedingData();
  }

  void _loadFeedingData() {
    _isLoading.value = true;
    
    try {
      _loadVolumeData();
      _loadCountData();
      _loadBreastFeedingData();
    } catch (e) {
      print('Error loading feeding data: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void _loadVolumeData() {
    final range = _getRangeForPeriod(_volumePeriod.value);
    
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

    // Get volume data from old events
    final oldVolumeData = StatsAggregator.sumByBucket(
      EventType.bottle,
      childId,
      range,
      events,
      (e) => (e.detail['amount_oz'] as double? ?? 0.0),
    );

    // Get volume data from new events (extract from subtitle)
    final bottleEvents = eventModels
        .where((e) => e.kind == EventKind.bottle &&
                     e.time.isAfter(range.start) &&
                     e.time.isBefore(range.end))
        .toList();

    final newVolumeData = <String, double>{};
    for (final event in bottleEvents) {
      final bucketKey = DateTimeUtils.bucketKey(event.time, range.bucket);
      final volume = _extractVolumeFromSubtitle(event.subtitle ?? '');
      newVolumeData[bucketKey] = (newVolumeData[bucketKey] ?? 0.0) + volume;
    }

    // Combine data
    final combinedData = <String, double>{};
    for (final bar in oldVolumeData) {
      combinedData[bar.x.toString()] = (combinedData[bar.x.toString()] ?? 0.0) + bar.y;
    }
    for (final entry in newVolumeData.entries) {
      combinedData[entry.key] = (combinedData[entry.key] ?? 0.0) + entry.value;
    }

    _volumeData.value = combinedData.entries
        .map((e) => Bar(e.key, e.value))
        .toList()
      ..sort((a, b) => a.x.toString().compareTo(b.x.toString()));
  }

  void _loadCountData() {
    final range = _getRangeForPeriod(_countPeriod.value);
    
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

    // Get count data from old events
    final oldCountData = StatsAggregator.countByBucket(
      {EventType.bottle},
      childId,
      range,
      events,
    );

    // Get count data from new events
    final newCountData = StatsAggregator.countEventModelsByBucket(
      {EventKind.bottle},
      childId,
      range,
      eventModels,
    );

    // Combine data
    final combinedData = <String, double>{};
    for (final bar in oldCountData) {
      combinedData[bar.x.toString()] = (combinedData[bar.x.toString()] ?? 0.0) + bar.y;
    }
    for (final bar in newCountData) {
      combinedData[bar.x.toString()] = (combinedData[bar.x.toString()] ?? 0.0) + bar.y;
    }

    _countData.value = combinedData.entries
        .map((e) => Bar(e.key, e.value))
        .toList()
      ..sort((a, b) => a.x.toString().compareTo(b.x.toString()));
  }

  void _loadBreastFeedingData() {
    final range = StatsRange.currentMonth();
    
    // Load EventModel events from storage
    final eventModelsData = _storage.read('events_v2') ?? [];
    final eventModels = (eventModelsData as List)
        .map((e) => EventModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    // Filter breast feeding events and count by side
    final breastEvents = eventModels
        .where((e) => e.kind == EventKind.bottle &&
                     e.time.isAfter(range.start) &&
                     e.time.isBefore(range.end) &&
                     (e.tags.contains('Left') || e.tags.contains('Right')))
        .toList();

    final leftCount = breastEvents.where((e) => e.tags.contains('Left')).length;
    final rightCount = breastEvents.where((e) => e.tags.contains('Right')).length;

    if (leftCount > 0 || rightCount > 0) {
      _breastFeedingData.value = [
        Bar('Left', leftCount.toDouble()),
        Bar('Right', rightCount.toDouble()),
      ];
    } else {
      _breastFeedingData.value = [];
    }
  }

  void changeVolumePeriod(String period) {
    _volumePeriod.value = period;
    _loadVolumeData();
  }

  void changeCountPeriod(String period) {
    _countPeriod.value = period;
    _loadCountData();
  }

  void openFullReport() {
    Get.snackbar(
      'Premium Feature',
      'Full feeding report is available with premium subscription',
      backgroundColor: Colors.amber.withValues(alpha: 0.2),
      colorText: Colors.amber,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  StatsRange _getRangeForPeriod(String period) {
    switch (period) {
      case 'Week':
        return StatsRange.lastWeek();
      case 'Month':
        return StatsRange.lastMonth();
      default:
        return StatsRange.lastWeek();
    }
  }

  double _extractVolumeFromSubtitle(String subtitle) {
    if (subtitle.isEmpty) return 0.0;
    
    // Extract volume from subtitle like "120 ml" or "4 oz"
    final mlMatch = RegExp(r'(\d+\.?\d*)\s*ml').firstMatch(subtitle);
    if (mlMatch != null) {
      final ml = double.parse(mlMatch.group(1)!);
      return ml * 0.033814; // Convert ml to oz
    }
    
    final ozMatch = RegExp(r'(\d+\.?\d*)\s*oz').firstMatch(subtitle);
    if (ozMatch != null) {
      return double.parse(ozMatch.group(1)!);
    }
    
    return 0.0;
  }
}
