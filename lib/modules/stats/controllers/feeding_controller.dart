import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/stats_models.dart';
import '../../events/services/events_store.dart';
import '../../events/models/event_record.dart';
import '../../events/controllers/events_controller.dart';
import '../../events/models/breast_feeding_event.dart';

class FeedingController extends GetxController {
  final String childId;

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

    // Listen to events store changes
    try {
      final eventsStore = Get.find<EventsStore>();
      eventsStore.items.listen((_) => _loadFeedingData());
    } catch (e) {
      debugPrint('EventsStore not available: $e');
    }

    // Listen to events controller changes for breast feeding
    try {
      final eventsController = Get.find<EventsController>();
      eventsController.events.listen((_) => _loadBreastFeedingData());
    } catch (e) {
      debugPrint('EventsController not available: $e');
    }
  }

  Future<void> _loadFeedingData() async {
    _isLoading.value = true;

    try {
      await _loadVolumeData();
      await _loadCountData();
      await _loadBreastFeedingData();
    } catch (e) {
      debugPrint('Error loading feeding data: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadVolumeData() async {
    final range = _getRangeForPeriod(_volumePeriod.value);

    try {
      // Get bottle feeding events from EventsStore
      final eventsStore = Get.find<EventsStore>();
      final allEvents = eventsStore.getByChild(childId);
      final bottleEvents = allEvents
          .where((e) => e.type == EventType.feedingBottle)
          .where((e) => e.startAt.isAfter(range.start.subtract(const Duration(microseconds: 1))) &&
                       e.startAt.isBefore(range.end.add(const Duration(microseconds: 1))))
          .toList();

      // Group by day and sum volumes
      final volumeByDay = <String, double>{};
      for (final event in bottleEvents) {
        final dayKey = _getDayKey(event.startAt, range);
        final volume = event.data['volume'] as num? ?? 0;
        volumeByDay[dayKey] = (volumeByDay[dayKey] ?? 0.0) + volume.toDouble();
      }

      _volumeData.value = volumeByDay.entries
          .map((e) => Bar(e.key, e.value))
          .toList()
        ..sort((a, b) => a.x.toString().compareTo(b.x.toString()));
    } catch (e) {
      debugPrint('Error loading volume data: $e');
      _volumeData.value = [];
    }
  }

  Future<void> _loadCountData() async {
    final range = _getRangeForPeriod(_countPeriod.value);

    try {
      // Get bottle feeding events from EventsStore
      final eventsStore = Get.find<EventsStore>();
      final allEvents = eventsStore.getByChild(childId);
      final bottleEvents = allEvents
          .where((e) => e.type == EventType.feedingBottle)
          .where((e) => e.startAt.isAfter(range.start.subtract(const Duration(microseconds: 1))) &&
                       e.startAt.isBefore(range.end.add(const Duration(microseconds: 1))))
          .toList();

      // Group by day and count events
      final countByDay = <String, double>{};
      for (final event in bottleEvents) {
        final dayKey = _getDayKey(event.startAt, range);
        countByDay[dayKey] = (countByDay[dayKey] ?? 0.0) + 1.0;
      }

      _countData.value = countByDay.entries
          .map((e) => Bar(e.key, e.value))
          .toList()
        ..sort((a, b) => a.x.toString().compareTo(b.x.toString()));
    } catch (e) {
      debugPrint('Error loading count data: $e');
      _countData.value = [];
    }
  }

  Future<void> _loadBreastFeedingData() async {
    final range = StatsRange.currentMonth();

    try {
      // Get breast feeding events from EventsStore
      final eventsStore = Get.find<EventsStore>();
      final allEvents = eventsStore.getByChild(childId);
      final breastEvents = allEvents
          .where((e) => e.type == EventType.feedingBreast)
          .where((e) => e.startAt.isAfter(range.start.subtract(const Duration(microseconds: 1))) &&
                       e.startAt.isBefore(range.end.add(const Duration(microseconds: 1))))
          .toList();

      // Also get from EventsController for BreastFeedingEvent objects
      final eventsController = Get.find<EventsController>();
      final breastFeedingEvents = eventsController.events
          .whereType<BreastFeedingEvent>()
          .where((e) => e.childId == childId)
          .where((e) => e.startAt.isAfter(range.start.subtract(const Duration(microseconds: 1))) &&
                       e.startAt.isBefore(range.end.add(const Duration(microseconds: 1))))
          .toList();

      // Count by side from EventRecord data
      int leftCount = 0;
      int rightCount = 0;

      for (final event in breastEvents) {
        final side = event.data['side'] as String?;
        if (side == 'left') leftCount++;
        if (side == 'right') rightCount++;
      }

      // Count from BreastFeedingEvent objects (count sessions with left/right duration)
      for (final event in breastFeedingEvents) {
        if (event.left.inSeconds > 0) leftCount++;
        if (event.right.inSeconds > 0) rightCount++;
      }

      if (leftCount > 0 || rightCount > 0) {
        _breastFeedingData.value = [
          Bar('Left', leftCount.toDouble()),
          Bar('Right', rightCount.toDouble()),
        ];
      } else {
        _breastFeedingData.value = [];
      }
    } catch (e) {
      debugPrint('Error loading breast feeding data: $e');
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
      'Full Report',
      'Detailed feeding analysis and patterns',
      backgroundColor: Colors.green.withValues(alpha: 0.2),
      colorText: Colors.green,
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
        return StatsRange.lastWeek();
    }
  }

  String _getDayKey(DateTime date, StatsRange range) {
    return DateTimeUtils.bucketKey(date, range.bucket);
  }
}
