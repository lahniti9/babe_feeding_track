import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../events/models/event_record.dart';
import '../../events/services/events_store.dart';
import '../services/timezone_clock.dart';

/// Range selection for statistics
enum StatsRange { day, week, month, year }

/// Base controller for range-aware statistics with live updates
abstract class RangeStatsController extends GetxController {
  final EventsStore eventsStore;
  final String childId;
  final TimezoneClock clock;

  final range = StatsRange.week.obs;
  final isLoading = false.obs;
  final lastUpdate = DateTime.now().obs;

  StreamSubscription? _subscription;

  RangeStatsController({
    required this.eventsStore,
    required this.childId,
    required this.clock,
  });

  /// Get the current time window based on selected range
  DateTimeRange get window {
    final now = DateTime.now();
    switch (range.value) {
      case StatsRange.day:
        final start = clock.dayStart(now);
        final end = clock.dayEndExclusive(now);
        return DateTimeRange(start: start, end: end);
      case StatsRange.week:
        final weekStart = clock.weekStart(now);
        final start = clock.dayStart(weekStart);
        final end = clock.dayEndExclusive(weekStart.add(const Duration(days: 6)));
        return DateTimeRange(start: start, end: end);
      case StatsRange.month:
        final monthStart = clock.monthStart(now);
        final start = clock.dayStart(monthStart);
        final nextMonth = DateTime(monthStart.year, monthStart.month + 1, 1);
        final end = clock.dayStart(nextMonth);
        return DateTimeRange(start: start, end: end);
      case StatsRange.year:
        final yearStart = clock.yearStart(now);
        final start = clock.dayStart(yearStart);
        final nextYear = DateTime(yearStart.year + 1, 1, 1);
        final end = clock.dayStart(nextYear);
        return DateTimeRange(start: start, end: end);
    }
  }

  /// Get range label for UI display
  String get rangeLabel {
    switch (range.value) {
      case StatsRange.day:
        return 'Today';
      case StatsRange.week:
        return 'This Week';
      case StatsRange.month:
        return 'This Month';
      case StatsRange.year:
        return 'This Year';
    }
  }

  /// Event types to watch - override in subclasses
  Set<EventType> get eventTypes;

  @override
  void onInit() {
    super.onInit();
    // Resubscribe when range changes
    ever(range, (_) => _resubscribe());
    _resubscribe();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  /// Subscribe to live event updates with debouncing
  void _resubscribe() {
    _subscription?.cancel();

    // Watch all events and filter in memory for now
    // TODO: Implement proper filtering in EventsStore
    _subscription = eventsStore.items
        .listen((allEvents) {
          final w = window;
          final filteredEvents = allEvents
              .where((event) =>
                  event.childId == childId &&
                  eventTypes.contains(event.type) &&
                  event.startAt.isAfter(w.start) &&
                  event.startAt.isBefore(w.end))
              .toList();
          _onEventsUpdate(filteredEvents);
        });
  }

  /// Handle new events - override in subclasses
  void _onEventsUpdate(List<EventRecord> events) async {
    isLoading.value = true;
    try {
      await processEvents(events);
      lastUpdate.value = DateTime.now();
    } catch (error) {
      print('Error processing events: $error');
    } finally {
      isLoading.value = false;
    }
  }

  /// Process events and update reactive data - implement in subclasses
  Future<void> processEvents(List<EventRecord> events);

  /// Change the time range
  void setRange(StatsRange newRange) {
    if (range.value != newRange) {
      range.value = newRange;
    }
  }

  /// Refresh data manually
  @override
  void refresh() {
    _resubscribe();
  }
}

/// Data point for time series charts
class TimeSeriesPoint {
  final DateTime date;
  final double value;
  final String? label;
  final Map<String, dynamic>? metadata;

  TimeSeriesPoint({
    required this.date,
    required this.value,
    this.label,
    this.metadata,
  });
}

/// Daily aggregated data
class DailyData {
  final DateTime date;
  final Map<String, double> values;
  final int count;

  DailyData({
    required this.date,
    required this.values,
    this.count = 0,
  });

  double getValue(String key) => values[key] ?? 0.0;
}

/// Hourly aggregated data for heatmaps
class HourlyData {
  final DateTime date;
  final int hour; // 0-23
  final double value;
  final int count;

  HourlyData({
    required this.date,
    required this.hour,
    required this.value,
    this.count = 0,
  });
}

/// KPI (Key Performance Indicator) data
class KPIData {
  final String label;
  final String value;
  final String? unit;
  final String? trend; // 'up', 'down', 'stable'
  final double? trendValue;

  KPIData({
    required this.label,
    required this.value,
    this.unit,
    this.trend,
    this.trendValue,
  });

  String get displayValue {
    if (unit != null) {
      return '$value $unit';
    }
    return value;
  }
}

/// Extension for debouncing streams
extension StreamDebounce<T> on Stream<T> {
  Stream<T> debounceTime(Duration duration) {
    StreamController<T>? controller;
    Timer? timer;
    
    controller = StreamController<T>(
      onListen: () {
        listen(
          (data) {
            timer?.cancel();
            timer = Timer(duration, () {
              controller?.add(data);
            });
          },
          onError: (error) => controller?.addError(error),
          onDone: () => controller?.close(),
        );
      },
      onCancel: () {
        timer?.cancel();
      },
    );
    
    return controller.stream;
  }
}

/// Utility class for common statistics calculations
class StatsUtils {
  /// Split events across day boundaries using timezone
  static List<EventRecord> splitAcrossDays(
    List<EventRecord> events,
    TimezoneClock clock,
  ) {
    final result = <EventRecord>[];

    for (final event in events) {
      if (event.endAt == null) {
        result.add(event);
        continue;
      }

      final startDay = clock.dateOnly(event.startAt);
      final endDay = clock.dateOnly(event.endAt!);

      if (clock.isSameDay(event.startAt, event.endAt!)) {
        // Event within single day
        result.add(event);
      } else {
        // Event spans multiple days - split it
        var currentStart = event.startAt;
        var currentDay = startDay;

        while (currentDay.isBefore(endDay) || currentDay.isAtSameMomentAs(endDay)) {
          final dayEnd = clock.dayEnd(currentDay);
          final segmentEnd = event.endAt!.isBefore(dayEnd) ? event.endAt! : dayEnd;

          if (currentStart.isBefore(segmentEnd)) {
            result.add(event.copyWith(
              startAt: currentStart,
              endAt: segmentEnd,
            ));
          }

          currentDay = currentDay.add(const Duration(days: 1));
          currentStart = clock.dayStart(currentDay);
        }
      }
    }

    return result;
  }

  /// Calculate daily totals from events
  static Map<DateTime, double> dailyTotals(
    List<EventRecord> events,
    TimezoneClock clock, {
    double Function(EventRecord)? valueExtractor,
  }) {
    final totals = <DateTime, double>{};
    valueExtractor ??= (event) => event.duration?.inMinutes.toDouble() ?? 0.0;

    for (final event in events) {
      final day = clock.dateOnly(event.startAt);
      totals[day] = (totals[day] ?? 0.0) + valueExtractor(event);
    }

    return totals;
  }

  /// Calculate hourly distribution
  static Map<int, double> hourlyDistribution(
    List<EventRecord> events,
    TimezoneClock clock, {
    double Function(EventRecord)? valueExtractor,
  }) {
    final distribution = <int, double>{};
    valueExtractor ??= (event) => event.duration?.inMinutes.toDouble() ?? 0.0;

    for (final event in events) {
      final hour = clock.hourOfDay(event.startAt);
      distribution[hour] = (distribution[hour] ?? 0.0) + valueExtractor(event);
    }

    return distribution;
  }

  /// Format duration in minutes to human readable
  static String formatDuration(double minutes) {
    if (minutes < 60) {
      return '${minutes.toInt()}m';
    }
    
    final hours = minutes / 60;
    if (hours < 24) {
      return '${hours.toStringAsFixed(1)}h';
    }
    
    final days = hours / 24;
    return '${days.toStringAsFixed(1)}d';
  }

  /// Format volume
  static String formatVolume(double ml) {
    if (ml < 1000) {
      return '${ml.toInt()} ml';
    }
    return '${(ml / 1000).toStringAsFixed(1)} L';
  }
}
