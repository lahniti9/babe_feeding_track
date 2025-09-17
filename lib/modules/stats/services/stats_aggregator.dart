import 'package:collection/collection.dart';
import '../../../data/models/event.dart';
import '../../events/models/event.dart';
import '../../events/models/sleep_event.dart';
import '../models/stats_models.dart';

class StatsAggregator {
  // Get measurements (weight, height, head circumference) as points
  static List<Point> measurements(
    EventType eventType,
    String childId,
    StatsRange range,
    List<Event> events,
  ) {
    final filteredEvents = events
        .where((e) =>
            e.childId == childId &&
            e.type == eventType &&
            e.time.isAfter(range.start) &&
            e.time.isBefore(range.end))
        .toList();

    return filteredEvents.map((e) {
      double value = 0.0;
      switch (eventType) {
        case EventType.weight:
          value = (e.detail['grams'] as int? ?? 0).toDouble();
          break;
        case EventType.height:
          value = e.detail['cm'] as double? ?? 0.0;
          break;
        default:
          value = 0.0;
      }
      return Point(e.time, value);
    }).toList()
      ..sort((a, b) => a.x.compareTo(b.x));
  }

  // Get measurements from EventModel (new event system)
  static List<Point> measurementsFromEventModel(
    EventKind eventKind,
    String childId,
    StatsRange range,
    List<EventModel> events,
  ) {
    final filteredEvents = events
        .where((e) =>
            e.kind == eventKind &&
            e.time.isAfter(range.start) &&
            e.time.isBefore(range.end))
        .toList();

    return filteredEvents.map((e) {
      // Extract value from subtitle (e.g., "5 lb 2 oz", "45.2 cm")
      double value = _extractValueFromSubtitle(e.subtitle ?? '', eventKind);
      return Point(e.time, value);
    }).toList()
      ..sort((a, b) => a.x.compareTo(b.x));
  }

  // Sum values by bucket (for feeding volume, etc.)
  static List<Bar> sumByBucket(
    EventType eventType,
    String childId,
    StatsRange range,
    List<Event> events,
    double Function(Event) valueOf,
  ) {
    final filteredEvents = events
        .where((e) =>
            e.childId == childId &&
            e.type == eventType &&
            e.time.isAfter(range.start) &&
            e.time.isBefore(range.end))
        .toList();

    final groups = groupBy(
      filteredEvents,
      (e) => DateTimeUtils.bucketKey(e.time, range.bucket),
    );

    return groups.entries
        .map((entry) => Bar(
              entry.key,
              entry.value.fold<double>(0.0, (sum, e) => sum + valueOf(e)),
            ))
        .toList()
      ..sort((a, b) => a.x.toString().compareTo(b.x.toString()));
  }

  // Count events by bucket
  static List<Bar> countByBucket(
    Set<EventType> eventTypes,
    String childId,
    StatsRange range,
    List<Event> events,
  ) {
    final filteredEvents = events
        .where((e) =>
            e.childId == childId &&
            eventTypes.contains(e.type) &&
            e.time.isAfter(range.start) &&
            e.time.isBefore(range.end))
        .toList();

    final groups = groupBy(
      filteredEvents,
      (e) => DateTimeUtils.bucketKey(e.time, range.bucket),
    );

    return groups.entries
        .map((entry) => Bar(entry.key, entry.value.length.toDouble()))
        .toList()
      ..sort((a, b) => a.x.toString().compareTo(b.x.toString()));
  }

  // Count EventModel events by bucket
  static List<Bar> countEventModelsByBucket(
    Set<EventKind> eventKinds,
    String childId,
    StatsRange range,
    List<EventModel> events,
  ) {
    final filteredEvents = events
        .where((e) =>
            eventKinds.contains(e.kind) &&
            e.time.isAfter(range.start) &&
            e.time.isBefore(range.end))
        .toList();

    final groups = groupBy(
      filteredEvents,
      (e) => DateTimeUtils.bucketKey(e.time, range.bucket),
    );

    return groups.entries
        .map((entry) => Bar(entry.key, entry.value.length.toDouble()))
        .toList()
      ..sort((a, b) => a.x.toString().compareTo(b.x.toString()));
  }

  // Sleep duration by bucket (using wokeUp date for night sleep rule)
  static List<Bar> sleepDurationByBucket(
    String childId,
    StatsRange range,
    List<SleepEvent> sleepEvents,
  ) {
    final filteredSleeps = sleepEvents
        .where((s) =>
            s.childId == childId &&
            s.wokeUp.isAfter(range.start) &&
            s.wokeUp.isBefore(range.end))
        .toList();

    final groups = groupBy(
      filteredSleeps,
      (s) => DateTimeUtils.bucketKey(s.wokeUp, range.bucket), // Use wokeUp for bucketing
    );

    return groups.entries
        .map((entry) => Bar(
              entry.key,
              entry.value
                  .fold<Duration>(Duration.zero, (sum, s) => sum + s.duration)
                  .inMinutes /
                  60.0, // Convert to hours
            ))
        .toList()
      ..sort((a, b) => a.x.toString().compareTo(b.x.toString()));
  }

  // Sleep histogram by hour (when baby sleeps the most)
  static List<Bar> sleepHistogramByHour(
    String childId,
    DateTime from,
    DateTime to,
    List<SleepEvent> sleepEvents,
  ) {
    final filteredSleeps = sleepEvents
        .where((s) =>
            s.childId == childId &&
            s.fellAsleep.isAfter(from) &&
            s.wokeUp.isBefore(to))
        .toList();

    // Initialize 24-hour buckets
    final minutesByHour = List<int>.filled(24, 0);

    for (final sleep in filteredSleeps) {
      _allocateSleepToHours(sleep.fellAsleep, sleep.wokeUp, minutesByHour);
    }

    return List.generate(
      24,
      (hour) => Bar(hour.toDouble(), minutesByHour[hour] / 60.0), // Convert to hours
    );
  }

  // Daily ring (24h view) with bottle and daytime sleep arcs
  static List<RadialArc> dayRing(
    String childId,
    DateTime day,
    List<Event> events,
    List<SleepEvent> sleepEvents,
  ) {
    final dayStart = DateTimeUtils.startOfDay(day);
    final dayEnd = DateTimeUtils.endOfDay(day);

    // Get bottle events for the day
    final bottles = events
        .where((e) =>
            e.childId == childId &&
            e.type == EventType.bottle &&
            e.time.isAfter(dayStart) &&
            e.time.isBefore(dayEnd))
        .toList();

    // Get daytime sleep events for the day
    final daytimeSleeps = sleepEvents
        .where((s) =>
            s.childId == childId &&
            DateTimeUtils.isDaytimeSleep(s.fellAsleep, s.wokeUp) &&
            s.fellAsleep.isAfter(dayStart) &&
            s.wokeUp.isBefore(dayEnd))
        .toList();

    final arcs = <RadialArc>[];

    // Add bottle arcs (small blips)
    for (final bottle in bottles) {
      final angle = DateTimeUtils.angleFromTime(bottle.time);
      arcs.add(RadialArc(angle, 2.0, label: 'Bottle', color: 'orange'));
    }

    // Add daytime sleep arcs
    for (final sleep in daytimeSleeps) {
      final startAngle = DateTimeUtils.angleFromTime(sleep.fellAsleep);
      final sweepAngle = DateTimeUtils.angleSpanFromDuration(sleep.duration);
      arcs.add(RadialArc(startAngle, sweepAngle, label: 'Daytime sleep', color: 'purple'));
    }

    return arcs;
  }

  // Helper method to allocate sleep duration across hour buckets
  static void _allocateSleepToHours(
    DateTime fellAsleep,
    DateTime wokeUp,
    List<int> minutesByHour,
  ) {
    var current = fellAsleep;
    final end = wokeUp;

    while (current.isBefore(end)) {
      final hour = current.hour;
      final nextHour = DateTime(current.year, current.month, current.day, hour + 1);
      final segmentEnd = nextHour.isBefore(end) ? nextHour : end;
      
      final minutesInThisHour = segmentEnd.difference(current).inMinutes;
      minutesByHour[hour] += minutesInThisHour;
      
      current = segmentEnd;
    }
  }

  // Helper method to extract numeric values from subtitle strings
  static double _extractValueFromSubtitle(String subtitle, EventKind kind) {
    if (subtitle.isEmpty) return 0.0;

    switch (kind) {
      case EventKind.weight:
        // Extract grams from "5 lb 2 oz" or "3500g"
        if (subtitle.contains('g')) {
          final match = RegExp(r'(\d+)g').firstMatch(subtitle);
          return match != null ? double.parse(match.group(1)!) : 0.0;
        } else if (subtitle.contains('lb')) {
          // Convert lb/oz to grams
          final lbMatch = RegExp(r'(\d+)\s*lb').firstMatch(subtitle);
          final ozMatch = RegExp(r'(\d+)\s*oz').firstMatch(subtitle);
          final lbs = lbMatch != null ? int.parse(lbMatch.group(1)!) : 0;
          final oz = ozMatch != null ? int.parse(ozMatch.group(1)!) : 0;
          return (UnitConverter.lbsToGrams(lbs.toDouble()) + UnitConverter.ozToGrams(oz.toDouble())).toDouble();
        }
        break;
      case EventKind.height:
        // Extract cm from "45.2 cm" or inches from "18 in"
        if (subtitle.contains('cm')) {
          final match = RegExp(r'(\d+\.?\d*)\s*cm').firstMatch(subtitle);
          return match != null ? double.parse(match.group(1)!) : 0.0;
        } else if (subtitle.contains('in')) {
          final match = RegExp(r'(\d+\.?\d*)\s*in').firstMatch(subtitle);
          if (match != null) {
            return UnitConverter.inchesToCm(double.parse(match.group(1)!));
          }
        }
        break;
      default:
        break;
    }

    return 0.0;
  }
}
