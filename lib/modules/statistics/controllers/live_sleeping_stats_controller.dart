import 'dart:async';
import 'package:get/get.dart';
import '../../events/models/event_record.dart';
import 'range_stats_controller.dart';

/// Live sleeping statistics controller with timezone-aware aggregation
class LiveSleepingStatsController extends RangeStatsController {
  // Reactive data
  final sleepDuration = <TimeSeriesPoint>[].obs;
  final hourlyHeatmap = <HourlyData>[].obs;
  final kpis = <KPIData>[].obs;

  LiveSleepingStatsController({
    required super.eventsStore,
    required super.childId,
    required super.clock,
  });

  @override
  Set<EventType> get eventTypes => {EventType.sleeping};

  @override
  Future<void> processEvents(List<EventRecord> events) async {
    if (events.isEmpty) {
      sleepDuration.clear();
      hourlyHeatmap.clear();
      kpis.clear();
      return;
    }

    final result = _processEventsSync(events);
    sleepDuration.assignAll(result.duration);
    hourlyHeatmap.assignAll(result.heatmap);
    kpis.assignAll(result.kpis);
  }

  /// Synchronous event processing
  _ProcessResult _processEventsSync(List<EventRecord> events) {
    // Split events across day boundaries
    final splitEvents = StatsUtils.splitAcrossDays(events, clock);

    // Calculate daily sleep duration
    final dailyTotals = StatsUtils.dailyTotals(splitEvents, clock);
    final durationPoints = dailyTotals.entries
        .map((e) => TimeSeriesPoint(date: e.key, value: e.value / 60.0)) // Convert to hours
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    // Calculate hourly heatmap
    final hourlyDistribution = StatsUtils.hourlyDistribution(splitEvents, clock);
    final heatmapData = <HourlyData>[];

    for (int hour = 0; hour < 24; hour++) {
      final minutes = hourlyDistribution[hour] ?? 0.0;
      heatmapData.add(HourlyData(
        date: window.start,
        hour: hour,
        value: minutes,
        count: splitEvents.where((e) => clock.hourOfDay(e.startAt) == hour).length,
      ));
    }

    // Calculate KPIs
    final kpiData = _calculateKPIs(splitEvents);

    return _ProcessResult(
      duration: durationPoints,
      heatmap: heatmapData,
      kpis: kpiData,
    );
  }

  /// Calculate key performance indicators
  List<KPIData> _calculateKPIs(List<EventRecord> events) {
    final kpis = <KPIData>[];

    if (events.isEmpty) return kpis;

    // Today's total sleep
    final today = clock.dateOnly(DateTime.now());
    final todayEvents = events.where((e) => clock.isSameDay(e.startAt, today));
    final todayMinutes = todayEvents.fold(0.0, (sum, e) => sum + (e.duration?.inMinutes ?? 0));

    kpis.add(KPIData(
      label: 'Today Total',
      value: StatsUtils.formatDuration(todayMinutes),
    ));

    // Night vs Day split
    final nightMinutes = events
        .where((e) => _isNightTime(clock.hourOfDay(e.startAt)))
        .fold(0.0, (sum, e) => sum + (e.duration?.inMinutes ?? 0));
    final dayMinutes = events
        .where((e) => !_isNightTime(clock.hourOfDay(e.startAt)))
        .fold(0.0, (sum, e) => sum + (e.duration?.inMinutes ?? 0));

    if (nightMinutes + dayMinutes > 0) {
      final nightPercent = ((nightMinutes / (nightMinutes + dayMinutes)) * 100).toInt();
      kpis.add(KPIData(
        label: 'Night/Day',
        value: '$nightPercent% / ${100 - nightPercent}%',
      ));
    }

    // Longest stretch
    if (events.isNotEmpty) {
      final longestEvent = events.reduce((a, b) =>
          (a.duration?.inMinutes ?? 0) > (b.duration?.inMinutes ?? 0) ? a : b);

      kpis.add(KPIData(
        label: 'Longest Stretch',
        value: StatsUtils.formatDuration(longestEvent.duration?.inMinutes.toDouble() ?? 0),
      ));
    }

    // Average per day
    final dailyTotals = StatsUtils.dailyTotals(events, clock);
    if (dailyTotals.isNotEmpty) {
      final avgMinutes = dailyTotals.values.reduce((a, b) => a + b) / dailyTotals.length;
      kpis.add(KPIData(
        label: 'Daily Average',
        value: StatsUtils.formatDuration(avgMinutes),
      ));
    }

    return kpis;
  }

  /// Check if hour is considered night time (21:00 - 09:00)
  bool _isNightTime(int hour) {
    return hour >= 21 || hour <= 9;
  }

  /// Get formatted KPI string for display
  String get kpiString {
    if (kpis.isEmpty) return '';
    return kpis.map((k) => '${k.label}: ${k.displayValue}').join(' • ');
  }

  /// Get today's sleep total in hours
  double get todayHours {
    final today = clock.dateOnly(DateTime.now());
    final point = sleepDuration.firstWhereOrNull((p) =>
        clock.isSameDay(p.date, today));
    return point?.value ?? 0.0;
  }

  /// Get night sleep percentage
  int get nightPercentage {
    final nightKpi = kpis.firstWhereOrNull((k) => k.label == 'Night/Day');
    if (nightKpi == null) return 0;

    final parts = nightKpi.value.split(' / ');
    if (parts.isEmpty) return 0;

    return int.tryParse(parts[0].replaceAll('%', '')) ?? 0;
  }
}

/// Result from event processing
class _ProcessResult {
  final List<TimeSeriesPoint> duration;
  final List<HourlyData> heatmap;
  final List<KPIData> kpis;

  _ProcessResult({
    required this.duration,
    required this.heatmap,
    required this.kpis,
  });
}
