import '../../../modules/events/models/event_record.dart';

/// Utility functions for date handling
DateTime dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

/// Extension for formatting numbers as time
extension NumX on num {
  String asHMS() {
    final s = toInt();
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final r = (s % 60).toString().padLeft(2, '0');
    return '$m:$r';
  }
}

/// Service class that converts event streams into chart-ready data
class StatsService {
  /// Latest value per day – used by Weight / Height / Head circumference
  static Map<DateTime, double> latestNumericPerDay(List<EventRecord> evts, String key) {
    final map = <DateTime, double>{};
    for (final e in evts) {
      final d = dateOnly(e.startAt);
      final v = (e.data[key] as num?)?.toDouble();
      if (v == null) continue;
      // keep the last measurement of the day
      map[d] = v;
    }
    return map;
  }

  /// Sum minutes per day from duration events (sleep, activity, feeding side timers)
  static Map<DateTime, double> sumMinutesPerDay(List<EventRecord> evts) {
    final sum = <DateTime, double>{};
    for (final e in evts) {
      final end = e.endAt ?? e.startAt; // guard
      final minutes = end.difference(e.startAt).inSeconds / 60.0;
      final d = dateOnly(e.startAt);
      sum[d] = (sum[d] ?? 0) + minutes;
    }
    return sum;
  }

  /// Bottle/food volumes per day (in oz or ml – you decide upstream)
  static Map<DateTime, double> sumVolumePerDay(List<EventRecord> evts, {String key = 'volumeOz'}) {
    final sum = <DateTime, double>{};
    for (final e in evts) {
      final v = (e.data[key] as num?)?.toDouble() ?? 0;
      final d = dateOnly(e.startAt);
      sum[d] = (sum[d] ?? 0) + v;
    }
    return sum;
  }

  /// Diaper counts per kind per day
  static Map<DateTime, Map<String, int>> diaperCounts(List<EventRecord> evts) {
    final out = <DateTime, Map<String,int>>{};
    for (final e in evts) {
      final kind = (e.data['kind'] as String?) ?? 'unknown'; // wet|dirty|mixed
      final d = dateOnly(e.startAt);
      out.putIfAbsent(d, () => {});
      out[d]![kind] = (out[d]![kind] ?? 0) + 1;
    }
    return out;
  }

  /// Hour-of-day histogram (e.g., Sleeping "when my baby sleeps most")
  static List<int> minutesPerHour(List<EventRecord> evts) {
    final buckets = List<int>.filled(24, 0);
    for (final e in evts) {
      final end = e.endAt ?? e.startAt;
      var t = e.startAt;
      while (t.isBefore(end)) {
        final hourEnd = DateTime(t.year, t.month, t.day, t.hour + 1);
        final segEnd = end.isBefore(hourEnd) ? end : hourEnd;
        final mins = segEnd.difference(t).inMinutes;
        buckets[t.hour] += mins;
        t = segEnd;
      }
    }
    return buckets;
  }

  /// Monthly overview markers: what days have which event tags
  static Map<DateTime, Set<EventType>> tagsByDay(List<EventRecord> evts, Set<EventType> tags) {
    final out = <DateTime, Set<EventType>>{};
    for (final e in evts.where((x) => tags.contains(x.type))) {
      final d = dateOnly(e.startAt);
      out.putIfAbsent(d, ()=> <EventType>{}).add(e.type);
    }
    return out;
  }

  /// Count events per day
  static Map<DateTime, int> countPerDay(List<EventRecord> evts) {
    final map = <DateTime, int>{};
    for (final e in evts) {
      final d = dateOnly(e.startAt);
      map[d] = (map[d] ?? 0) + 1;
    }
    return map;
  }

  /// Temperature readings per day (latest value)
  static Map<DateTime, double> temperaturePerDay(List<EventRecord> evts) {
    return latestNumericPerDay(evts, 'celsius');
  }

  /// Medicine doses per day (sum)
  static Map<DateTime, double> medicineDosesPerDay(List<EventRecord> evts) {
    final sum = <DateTime, double>{};
    for (final e in evts) {
      final dose = (e.data['doseMg'] as num?)?.toDouble() ?? 0;
      final d = dateOnly(e.startAt);
      sum[d] = (sum[d] ?? 0) + dose;
    }
    return sum;
  }

  /// Activity minutes by type per day
  static Map<DateTime, Map<String, double>> activityMinutesByType(List<EventRecord> evts) {
    final out = <DateTime, Map<String, double>>{};
    for (final e in evts) {
      final type = e.data['type'] as String? ?? 'unknown';
      final end = e.endAt ?? e.startAt;
      final minutes = end.difference(e.startAt).inSeconds / 60.0;
      final d = dateOnly(e.startAt);
      out.putIfAbsent(d, () => {});
      out[d]![type] = (out[d]![type] ?? 0) + minutes;
    }
    return out;
  }

  /// Condition mood counts per day
  static Map<DateTime, Map<String, int>> conditionMoodsPerDay(List<EventRecord> evts) {
    final out = <DateTime, Map<String, int>>{};
    for (final e in evts) {
      final moods = e.data['moods'] as List? ?? [];
      final d = dateOnly(e.startAt);
      out.putIfAbsent(d, () => {});
      for (final mood in moods) {
        final moodStr = mood.toString();
        out[d]![moodStr] = (out[d]![moodStr] ?? 0) + 1;
      }
    }
    return out;
  }
}
