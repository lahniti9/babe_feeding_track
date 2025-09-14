import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/stats_models.dart';
import '../../events/services/events_store.dart';
import '../../events/models/event_record.dart';

class DiapersController extends GetxController {
  final String childId;

  DiapersController({required this.childId});

  // Observable state
  final _isLoading = false.obs;
  final _diaperData = <Bar>[].obs;
  final _selectedPeriod = 'Week'.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<Bar> get diaperData => _diaperData;
  RxString get selectedPeriod => _selectedPeriod;

  @override
  void onInit() {
    super.onInit();
    _loadDiaperData();

    // Listen to events store changes
    try {
      final eventsStore = Get.find<EventsStore>();
      eventsStore.items.listen((_) => _loadDiaperData());
    } catch (e) {
      debugPrint('EventsStore not available: $e');
    }
  }

  void _loadDiaperData() {
    _isLoading.value = true;

    try {
      final range = _getRangeForPeriod(_selectedPeriod.value);

      // Get diaper events from EventsStore
      final eventsStore = Get.find<EventsStore>();
      final diaperEvents = eventsStore.getByChild(childId)
          .where((e) => e.type == EventType.diaper)
          .where((e) => e.startAt.isAfter(range.start) && e.startAt.isBefore(range.end))
          .toList();

      // Group by day and count events
      final countByDay = <String, double>{};
      for (final event in diaperEvents) {
        final dayKey = DateTimeUtils.bucketKey(event.startAt, range.bucket);
        countByDay[dayKey] = (countByDay[dayKey] ?? 0.0) + 1.0;
      }

      _diaperData.value = countByDay.entries
          .map((e) => Bar(e.key, e.value))
          .toList()
        ..sort((a, b) => a.x.toString().compareTo(b.x.toString()));

    } catch (e) {
      debugPrint('Error loading diaper data: $e');
      _diaperData.value = [];
    } finally {
      _isLoading.value = false;
    }
  }

  void changePeriod(String period) {
    _selectedPeriod.value = period;
    _loadDiaperData();
  }

  StatsRange _getRangeForPeriod(String period) {
    switch (period) {
      case 'Day':
        return StatsRange.lastWeek();
      case 'Week':
        return StatsRange.lastMonth();
      case 'Month':
        return StatsRange.last3Months();
      default:
        return StatsRange.lastMonth();
    }
  }
}
