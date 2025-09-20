import 'dart:async';
import 'package:get/get.dart';
import '../../events/services/events_store.dart';
import '../../events/models/event_record.dart';
import '../../children/services/children_store.dart';
import '../services/enhanced_stats_service.dart';
import '../services/timezone_clock.dart';

/// Live summaries controller that powers the statistics tiles
/// Subscribes to events store with filters that change when active child changes
class StatsHomeController extends GetxController {
  final _eventsStore = Get.find<EventsStore>();
  final _children = Get.find<ChildrenStore>();

  // Reactive child + clock
  final currentChildId = RxnString();
  final clock = Rx<TimezoneClock>(TimezoneClock.fromName('UTC'));

  // ====== LIVE SUMMARY FIELDS FOR TILES ======
  // Measurements (last values):
  final lastHeightCm = RxnDouble();
  final lastWeightKg = RxnDouble();

  // Health diary latest counts (optional), feed totals today, sleep minutes today:
  final todayFeedVolumeMl = 0.0.obs;
  final todaySleepMinutes = 0.0.obs;

  // Diapers today:
  final todayWet = 0.obs;
  final todayPoop = 0.obs;
  final todayMixed = 0.obs;

  // Monthly overview: how many days this month have any of the tracked types
  final monthlyActiveDays = 0.obs;

  final hasChild = false.obs;

  // Internal subscriptions
  final _subs = <StreamSubscription>[];

  @override
  void onInit() {
    // Rebind whenever active child changes
    ever<String?>(_children.activeId, (_) => _rebind());
    // Initial bind
    _rebind();
    super.onInit();
  }

  void _rebind() {
    _cancel();
    final child = _children.active;
    hasChild.value = child != null;

    if (child == null) {
      currentChildId.value = null;
      return;
    }

    currentChildId.value = child.id;
    clock.value = TimezoneClock.fromName(child.timezone ?? 'UTC');

    final c = clock.value;
    final now = DateTime.now();
    final day0 = c.dayStart(now);
    final day1 = c.dayEndExclusive(now);
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 1);

    // ---- HEIGHT ----
    void loadHeightData() {
      final allEvents = _eventsStore.getByChild(child.id);
      final heightEvents = allEvents.where((e) => e.type == EventType.height).toList();
      final m = EnhancedStatsService.latestPerDayNumber(heightEvents, key: 'valueCm', clock: c);
      lastHeightCm.value = m.values.isEmpty ? null : m.values.last;
    }
    _subs.add(_eventsStore.items.listen((_) => loadHeightData()));
    loadHeightData(); // Load initial data

    // ---- WEIGHT ---- (store SI internally: kg)
    void loadWeightData() {
      final allEvents = _eventsStore.getByChild(child.id);
      final weightEvents = allEvents.where((e) => e.type == EventType.weight).toList();
      final m = EnhancedStatsService.latestPerDayNumber(weightEvents, key: 'valueKg', clock: c);
      lastWeightKg.value = m.values.isEmpty ? null : m.values.last;
    }
    _subs.add(_eventsStore.items.listen((_) => loadWeightData()));
    loadWeightData(); // Load initial data

    // ---- FEEDING TODAY (bottle + expressing volume) ----
    void loadFeedingData() {
      final allEvents = _eventsStore.getByChild(child.id);
      final feedingEvents = allEvents
          .where((e) => e.type == EventType.feedingBottle || e.type == EventType.expressing)
          .where((e) => e.startAt.isAfter(day0.subtract(const Duration(microseconds: 1))) &&
                       e.startAt.isBefore(day1.add(const Duration(microseconds: 1))))
          .toList();

      double sumMl = 0;
      for (final e in feedingEvents) {
        // Normalize: prefer ml if you store SI
        final ml = (e.data['volumeMl'] as num?)?.toDouble();
        final oz = (e.data['volumeOz'] as num?)?.toDouble();
        sumMl += ml ?? (oz != null ? (oz * 29.5735) : 0);
      }
      todayFeedVolumeMl.value = sumMl;
    }
    _subs.add(_eventsStore.items.listen((_) => loadFeedingData()));
    loadFeedingData(); // Load initial data

    // ---- SLEEP TODAY (minutes) ----
    void loadSleepData() {
      final allEvents = _eventsStore.getByChild(child.id);
      final sleepEvents = allEvents
          .where((e) => e.type == EventType.sleeping)
          .where((e) => e.startAt.isAfter(day0.subtract(const Duration(microseconds: 1))) &&
                       e.startAt.isBefore(day1.add(const Duration(microseconds: 1))))
          .toList();

      final perDay = EnhancedStatsService.sumMinutesPerDay(sleepEvents, clock: c);
      final key = DateTime(day0.year, day0.month, day0.day);
      todaySleepMinutes.value = perDay[key] ?? 0.0;
    }
    _subs.add(_eventsStore.items.listen((_) => loadSleepData()));
    loadSleepData(); // Load initial data

    // ---- DIAPERS TODAY ----
    void loadDiaperData() {
      final allEvents = _eventsStore.getByChild(child.id);
      final diaperEvents = allEvents
          .where((e) => e.type == EventType.diaper)
          .where((e) => e.startAt.isAfter(day0.subtract(const Duration(microseconds: 1))) &&
                       e.startAt.isBefore(day1.add(const Duration(microseconds: 1))))
          .toList();

      final per = EnhancedStatsService.diaperCounts(diaperEvents, clock: c);
      final key = DateTime(day0.year, day0.month, day0.day);
      final map = per[key] ?? const <String, int>{};
      todayWet.value = map['pee'] ?? map['wet'] ?? 0;
      todayPoop.value = map['poop'] ?? map['dirty'] ?? 0;
      todayMixed.value = map['mixed'] ?? 0;
    }
    _subs.add(_eventsStore.items.listen((_) => loadDiaperData()));
    loadDiaperData(); // Load initial data

    // ---- MONTHLY OVERVIEW (days with any tracked type) ----
    void loadMonthlyData() {
      final allEvents = _eventsStore.getByChild(child.id);
      final monthlyEvents = allEvents
          .where((e) => {
                EventType.feedingBreast,
                EventType.feedingBottle,
                EventType.sleeping,
                EventType.diaper,
                EventType.medicine,
                EventType.temperature,
                EventType.doctor,
                EventType.activity,
              }.contains(e.type))
          .where((e) => e.startAt.isAfter(monthStart.subtract(const Duration(microseconds: 1))) &&
                       e.startAt.isBefore(monthEnd.add(const Duration(microseconds: 1))))
          .toList();

      final tagDays = EnhancedStatsService.tagsByDay(
        monthlyEvents,
        includedTypes: {
          EventType.feedingBreast,
          EventType.feedingBottle,
          EventType.sleeping,
          EventType.diaper,
          EventType.medicine,
          EventType.temperature,
          EventType.doctor,
          EventType.activity,
        },
        clock: c,
      );
      monthlyActiveDays.value = tagDays.length;
    }
    _subs.add(_eventsStore.items.listen((_) => loadMonthlyData()));
    loadMonthlyData(); // Load initial data
  }

  void _cancel() {
    for (final s in _subs) {
      s.cancel();
    }
    _subs.clear();
  }

  // Computed getters for UI display
  String get lastHeightCmDisplay {
    final value = lastHeightCm.value;
    return value != null ? '${value.toStringAsFixed(1)} cm' : '—';
  }

  String get lastWeightKgDisplay {
    final value = lastWeightKg.value;
    return value != null ? '${value.toStringAsFixed(2)} kg' : '—';
  }

  String get todayFeedVolumeDisplay {
    final ml = todayFeedVolumeMl.value;
    if (ml <= 0) return '—';
    // Display in oz if your UI uses oz:
    final oz = ml / 29.5735;
    return '${oz.toStringAsFixed(1)} oz';
  }

  String get todaySleepDisplay {
    final minutes = todaySleepMinutes.value;
    if (minutes <= 0) return '—';
    final m = minutes.round();
    final h = m ~/ 60;
    final r = m % 60;
    return h > 0 ? '${h}h ${r}m' : '${r}m';
  }

  String get todayDiaperDisplay {
    final wet = todayWet.value;
    final poop = todayPoop.value;
    final mixed = todayMixed.value;
    if (wet == 0 && poop == 0 && mixed == 0) return '—';
    return 'W:$wet  P:$poop  M:$mixed';
  }

  String get monthlyActiveDaysDisplay {
    return '${monthlyActiveDays.value}';
  }

  @override
  void onClose() {
    _cancel();
    super.onClose();
  }
}
