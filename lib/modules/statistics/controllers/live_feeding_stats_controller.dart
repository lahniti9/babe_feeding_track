import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../events/models/event_record.dart';
import 'range_stats_controller.dart';

/// Live feeding statistics controller with volume and session tracking
class LiveFeedingStatsController extends RangeStatsController {
  // Reactive data
  final volumeDaily = <TimeSeriesPoint>[].obs;
  final sessionCounts = <TimeSeriesPoint>[].obs;
  final leftRightRatio = <PieData>[].obs;
  final kpis = <KPIData>[].obs;

  LiveFeedingStatsController({
    required super.eventsStore,
    required super.childId,
    required super.clock,
  });

  @override
  Set<EventType> get eventTypes => {
    EventType.feedingBreast,
    EventType.feedingBottle,
    EventType.expressing
  };

  @override
  Future<void> processEvents(List<EventRecord> events) async {
    if (events.isEmpty) {
      volumeDaily.clear();
      sessionCounts.clear();
      leftRightRatio.clear();
      kpis.clear();
      return;
    }

    final result = _processEventsSync(events);
    volumeDaily.assignAll(result.volume);
    sessionCounts.assignAll(result.sessions);
    leftRightRatio.assignAll(result.leftRight);
    kpis.assignAll(result.kpis);
  }

  /// Synchronous event processing
  _FeedingProcessResult _processEventsSync(List<EventRecord> events) {
    // Split events across day boundaries
    final splitEvents = StatsUtils.splitAcrossDays(events, clock);
    
    // Calculate daily volume totals
    final dailyVolumes = <DateTime, double>{};
    final dailySessions = <DateTime, int>{};
    
    for (final event in splitEvents) {
      final day = clock.dateOnly(event.startAt);
      final volume = _extractVolume(event);

      dailyVolumes[day] = (dailyVolumes[day] ?? 0.0) + volume;
      dailySessions[day] = (dailySessions[day] ?? 0) + 1;
    }

    // Convert to time series points
    final volumePoints = dailyVolumes.entries
        .map((e) => TimeSeriesPoint(date: e.key, value: e.value))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final sessionPoints = dailySessions.entries
        .map((e) => TimeSeriesPoint(date: e.key, value: e.value.toDouble()))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    // Calculate left/right ratio for breast feeding
    final leftRightData = _calculateLeftRightRatio(splitEvents);

    // Calculate KPIs
    final kpiData = _calculateKPIs(splitEvents);

    return _FeedingProcessResult(
      volume: volumePoints,
      sessions: sessionPoints,
      leftRight: leftRightData,
      kpis: kpiData,
    );
  }

  /// Extract volume from feeding event
  double _extractVolume(EventRecord event) {
    final data = event.data;
    if (data.isEmpty) return 0.0;

    // Handle different feeding types based on EventType
    if (event.type == EventType.feedingBottle) {
      return (data['volume'] as num?)?.toDouble() ?? 0.0;
    } else if (event.type == EventType.expressing) {
      final leftVolume = (data['leftVolume'] as num?)?.toDouble() ?? 0.0;
      final rightVolume = (data['rightVolume'] as num?)?.toDouble() ?? 0.0;
      return leftVolume + rightVolume;
    }

    return 0.0;
  }

  /// Calculate left/right breast feeding ratio
  List<PieData> _calculateLeftRightRatio(List<EventRecord> events) {
    double leftMinutes = 0.0;
    double rightMinutes = 0.0;

    for (final event in events) {
      if (event.type != EventType.feedingBreast) continue;

      final duration = event.duration?.inMinutes.toDouble() ?? 0.0;
      final side = event.data['side'] as String?;

      if (side == 'left') {
        leftMinutes += duration;
      } else if (side == 'right') {
        rightMinutes += duration;
      } else if (side == 'both') {
        // Split duration equally for both sides
        leftMinutes += duration / 2;
        rightMinutes += duration / 2;
      }
    }

    if (leftMinutes == 0 && rightMinutes == 0) {
      return [];
    }

    return [
      PieData(label: 'Left', value: leftMinutes, color: const Color(0xFF059669)),
      PieData(label: 'Right', value: rightMinutes, color: const Color(0xFF10B981)),
    ];
  }

  /// Calculate key performance indicators
  List<KPIData> _calculateKPIs(List<EventRecord> events) {
    final kpis = <KPIData>[];

    if (events.isEmpty) return kpis;

    // Today's total volume
    final today = clock.dateOnly(DateTime.now());
    final todayEvents = events.where((e) => clock.isSameDay(e.startAt, today));
    final todayVolume = todayEvents.fold(0.0, (sum, e) => sum + _extractVolume(e));

    kpis.add(KPIData(
      label: 'Today Volume',
      value: StatsUtils.formatVolume(todayVolume),
    ));

    // Today's session count
    final todaySessionCount = todayEvents.length;
    kpis.add(KPIData(
      label: 'Today Sessions',
      value: '$todaySessionCount',
    ));

    // Left/Right ratio for breast feeding
    final breastEvents = events.where((e) =>
        e.type == EventType.feedingBreast).toList();

    if (breastEvents.isNotEmpty) {
      final leftRightData = _calculateLeftRightRatio(breastEvents);
      if (leftRightData.length == 2) {
        final total = leftRightData[0].value + leftRightData[1].value;
        final leftPercent = ((leftRightData[0].value / total) * 100).toInt();
        kpis.add(KPIData(
          label: 'Left/Right',
          value: '$leftPercent% / ${100 - leftPercent}%',
        ));
      }
    }

    // Average volume per session
    final totalVolume = events.fold(0.0, (sum, e) => sum + _extractVolume(e));
    final volumeEvents = events.where((e) => _extractVolume(e) > 0).length;

    if (volumeEvents > 0) {
      final avgVolume = totalVolume / volumeEvents;
      kpis.add(KPIData(
        label: 'Avg per Session',
        value: StatsUtils.formatVolume(avgVolume),
      ));
    }

    return kpis;
  }

  /// Get formatted KPI string for display
  String get kpiString {
    if (kpis.isEmpty) return '';
    return kpis.map((k) => '${k.label}: ${k.displayValue}').join(' • ');
  }

  /// Get today's total volume
  double get todayVolume {
    final today = clock.dateOnly(DateTime.now());
    final point = volumeDaily.firstWhereOrNull((p) =>
        clock.isSameDay(p.date, today));
    return point?.value ?? 0.0;
  }

  /// Get today's session count
  int get todaySessionCount {
    final today = clock.dateOnly(DateTime.now());
    final point = sessionCounts.firstWhereOrNull((p) =>
        clock.isSameDay(p.date, today));
    return point?.value.toInt() ?? 0;
  }

  /// Get left breast percentage
  int get leftPercentage {
    if (leftRightRatio.isEmpty) return 50;
    
    final leftData = leftRightRatio.firstWhereOrNull((d) => d.label == 'Left');
    if (leftData == null) return 50;
    
    final total = leftRightRatio.fold(0.0, (sum, d) => sum + d.value);
    if (total == 0) return 50;
    
    return ((leftData.value / total) * 100).toInt();
  }
}

/// Data for pie charts
class PieData {
  final String label;
  final double value;
  final Color color;

  PieData({
    required this.label,
    required this.value,
    required this.color,
  });
}

/// Result from feeding event processing
class _FeedingProcessResult {
  final List<TimeSeriesPoint> volume;
  final List<TimeSeriesPoint> sessions;
  final List<PieData> leftRight;
  final List<KPIData> kpis;

  _FeedingProcessResult({
    required this.volume,
    required this.sessions,
    required this.leftRight,
    required this.kpis,
  });
}

/// Feeding type enumeration
enum FeedingType {
  bottle,
  breast,
  expressing,
}

/// Feeding session data
class FeedingSession {
  final DateTime startTime;
  final DateTime? endTime;
  final FeedingType type;
  final double? volume;
  final String? side; // for breast feeding
  final Map<String, dynamic>? metadata;

  FeedingSession({
    required this.startTime,
    this.endTime,
    required this.type,
    this.volume,
    this.side,
    this.metadata,
  });

  Duration? get duration {
    if (endTime == null) return null;
    return endTime!.difference(startTime);
  }

  double get durationMinutes {
    final dur = duration;
    if (dur == null) return 0.0;
    return dur.inMilliseconds / 60000.0;
  }
}

/// Feeding statistics utilities
class FeedingStatsUtils {
  /// Calculate feeding efficiency (volume per minute)
  static double calculateEfficiency(List<EventRecord> events) {
    double totalVolume = 0.0;
    double totalMinutes = 0.0;

    for (final event in events) {
      final volume = _extractVolume(event);
      final minutes = event.duration?.inMinutes.toDouble() ?? 0.0;

      if (volume > 0 && minutes > 0) {
        totalVolume += volume;
        totalMinutes += minutes;
      }
    }

    if (totalMinutes == 0) return 0.0;
    return totalVolume / totalMinutes;
  }

  /// Extract volume from event
  static double _extractVolume(EventRecord event) {
    final data = event.data;
    if (data.isEmpty) return 0.0;

    if (event.type == EventType.feedingBottle) {
      return (data['volume'] as num?)?.toDouble() ?? 0.0;
    } else if (event.type == EventType.expressing) {
      final leftVolume = (data['leftVolume'] as num?)?.toDouble() ?? 0.0;
      final rightVolume = (data['rightVolume'] as num?)?.toDouble() ?? 0.0;
      return leftVolume + rightVolume;
    }

    return 0.0;
  }

  /// Get feeding type from event
  static FeedingType? getFeedingType(EventRecord event) {
    switch (event.type) {
      case EventType.feedingBottle:
        return FeedingType.bottle;
      case EventType.feedingBreast:
        return FeedingType.breast;
      case EventType.expressing:
        return FeedingType.expressing;
      default:
        return null;
    }
  }

  /// Format feeding summary
  static String formatFeedingSummary(List<EventRecord> events) {
    if (events.isEmpty) return 'No feeding data';
    
    final totalVolume = events.fold(0.0, (sum, e) => sum + _extractVolume(e));
    final sessionCount = events.length;
    
    return '$sessionCount sessions • ${StatsUtils.formatVolume(totalVolume)}';
  }
}
