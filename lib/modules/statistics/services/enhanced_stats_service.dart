import 'dart:math' as math;
import '../../events/models/event_record.dart';
import 'timezone_clock.dart';

/// Enhanced statistics service with timezone awareness and data validation
/// Provides safe, performant aggregations for event data
class EnhancedStatsService {
  /// Sum minutes per day with timezone awareness
  static Map<DateTime, double> sumMinutesPerDay(
    List<EventRecord> events, {
    required TimezoneClock clock,
  }) {
    final result = <DateTime, double>{};
    
    for (final event in events) {
      if (event.endAt == null) continue;
      
      final duration = event.endAt!.difference(event.startAt);
      if (!clock.isValidDuration(duration)) continue;
      
      // Split event across day boundaries
      final daySegments = clock.splitEventAcrossDays(
        startAt: event.startAt,
        endAt: event.endAt!,
      );
      
      for (final segment in daySegments) {
        final date = segment.key;
        final minutes = segment.value.inMinutes.toDouble();
        result[date] = (result[date] ?? 0.0) + minutes;
      }
    }
    
    return result;
  }
  
  /// Get minutes per hour (24-hour histogram) with timezone awareness
  static List<int> minutesPerHour(
    List<EventRecord> events, {
    required TimezoneClock clock,
  }) {
    final result = List<int>.filled(24, 0);
    
    for (final event in events) {
      if (event.endAt == null) continue;
      
      final duration = event.endAt!.difference(event.startAt);
      if (!clock.isValidDuration(duration)) continue;
      
      var currentTime = event.startAt;
      var remainingMinutes = duration.inMinutes;
      
      while (remainingMinutes > 0 && currentTime.isBefore(event.endAt!)) {
        final hour = clock.hourOfDay(currentTime);
        final hourStart = clock.hourStart(currentTime);
        final hourEnd = hourStart.add(const Duration(hours: 1));
        
        // Calculate minutes for this hour
        final segmentEnd = event.endAt!.isBefore(hourEnd) ? event.endAt! : hourEnd;
        final segmentMinutes = segmentEnd.difference(currentTime).inMinutes;
        
        if (segmentMinutes > 0) {
          result[hour] += segmentMinutes.round();
          remainingMinutes -= segmentMinutes;
        }
        
        // Move to next hour
        currentTime = hourEnd;
      }
    }
    
    return result;
  }
  
  /// Sum volume per day with unit validation
  static Map<DateTime, double> sumVolumePerDay(
    List<EventRecord> events, {
    required String volumeKey,
    required TimezoneClock clock,
  }) {
    final result = <DateTime, double>{};
    
    for (final event in events) {
      final volume = _extractNumericValue(event.data, volumeKey);
      if (volume == null || volume <= 0) continue;
      
      final date = clock.dateOnly(event.startAt);
      result[date] = (result[date] ?? 0.0) + volume;
    }
    
    return result;
  }
  
  /// Count events per day
  static Map<DateTime, int> countPerDay(
    List<EventRecord> events, {
    required TimezoneClock clock,
  }) {
    final result = <DateTime, int>{};
    
    for (final event in events) {
      final date = clock.dateOnly(event.startAt);
      result[date] = (result[date] ?? 0) + 1;
    }
    
    return result;
  }
  
  /// Get latest numeric value per day (for measurements like weight, height)
  static Map<DateTime, double> latestPerDayNumber(
    List<EventRecord> events, {
    required String key,
    required TimezoneClock clock,
  }) {
    final result = <DateTime, double>{};
    
    // Group events by date
    final eventsByDate = <DateTime, List<EventRecord>>{};
    for (final event in events) {
      final date = clock.dateOnly(event.startAt);
      eventsByDate.putIfAbsent(date, () => []).add(event);
    }
    
    // Get latest value for each date
    for (final entry in eventsByDate.entries) {
      final date = entry.key;
      final dayEvents = entry.value;
      
      // Sort by time (latest first)
      dayEvents.sort((a, b) => b.startAt.compareTo(a.startAt));
      
      // Find first event with valid value
      for (final event in dayEvents) {
        final value = _extractNumericValue(event.data, key);
        if (value != null && value > 0) {
          result[date] = value;
          break;
        }
      }
    }
    
    return result;
  }
  
  /// Create event tags by day for monthly overview
  static Map<DateTime, Set<EventType>> tagsByDay(
    List<EventRecord> events, {
    required Set<EventType> includedTypes,
    required TimezoneClock clock,
  }) {
    final result = <DateTime, Set<EventType>>{};
    
    for (final event in events) {
      if (!includedTypes.contains(event.type)) continue;
      
      final date = clock.dateOnly(event.startAt);
      result.putIfAbsent(date, () => <EventType>{}).add(event.type);
    }
    
    return result;
  }
  
  /// Count diaper types per day
  static Map<DateTime, Map<String, int>> diaperCounts(
    List<EventRecord> events, {
    required TimezoneClock clock,
  }) {
    final result = <DateTime, Map<String, int>>{};
    
    for (final event in events) {
      if (event.type != EventType.diaper) continue;
      
      final kind = event.data['kind'] as String? ?? 'unknown';
      final date = clock.dateOnly(event.startAt);
      
      result.putIfAbsent(date, () => <String, int>{});
      result[date]![kind] = (result[date]![kind] ?? 0) + 1;
    }
    
    return result;
  }
  
  /// Get temperature readings per day (latest value)
  static Map<DateTime, double> temperaturePerDay(
    List<EventRecord> events, {
    required TimezoneClock clock,
  }) {
    return latestPerDayNumber(
      events,
      key: 'celsius',
      clock: clock,
    );
  }
  
  /// Calculate feeding session statistics
  static Map<String, dynamic> feedingSessionStats(
    List<EventRecord> events, {
    required TimezoneClock clock,
  }) {
    if (events.isEmpty) {
      return {
        'totalSessions': 0,
        'averageDuration': 0.0,
        'totalDuration': 0.0,
        'longestSession': 0.0,
        'shortestSession': 0.0,
      };
    }
    
    final durations = <double>[];
    var totalMinutes = 0.0;
    
    for (final event in events) {
      if (event.endAt == null) continue;
      
      final duration = event.endAt!.difference(event.startAt);
      if (!clock.isValidDuration(duration)) continue;
      
      final minutes = duration.inMinutes.toDouble();
      durations.add(minutes);
      totalMinutes += minutes;
    }
    
    if (durations.isEmpty) {
      return {
        'totalSessions': events.length,
        'averageDuration': 0.0,
        'totalDuration': 0.0,
        'longestSession': 0.0,
        'shortestSession': 0.0,
      };
    }
    
    durations.sort();
    
    return {
      'totalSessions': events.length,
      'averageDuration': totalMinutes / durations.length,
      'totalDuration': totalMinutes,
      'longestSession': durations.last,
      'shortestSession': durations.first,
    };
  }
  
  /// Calculate sleep quality metrics
  static Map<String, dynamic> sleepQualityStats(
    List<EventRecord> events, {
    required TimezoneClock clock,
  }) {
    if (events.isEmpty) {
      return {
        'totalSleepTime': 0.0,
        'averageSessionLength': 0.0,
        'numberOfSessions': 0,
        'longestSession': 0.0,
        'nightSleepPercentage': 0.0,
      };
    }
    
    var totalMinutes = 0.0;
    var nightMinutes = 0.0;
    final sessionLengths = <double>[];
    
    for (final event in events) {
      if (event.endAt == null) continue;
      
      final duration = event.endAt!.difference(event.startAt);
      if (!clock.isValidDuration(duration)) continue;
      
      final minutes = duration.inMinutes.toDouble();
      sessionLengths.add(minutes);
      totalMinutes += minutes;
      
      // Check if sleep session overlaps with night hours (22:00 - 06:00)
      final startHour = clock.hourOfDay(event.startAt);
      final endHour = clock.hourOfDay(event.endAt!);
      
      if (_isNightTime(startHour) || _isNightTime(endHour)) {
        nightMinutes += minutes;
      }
    }
    
    sessionLengths.sort();
    
    return {
      'totalSleepTime': totalMinutes,
      'averageSessionLength': sessionLengths.isNotEmpty ? totalMinutes / sessionLengths.length : 0.0,
      'numberOfSessions': events.length,
      'longestSession': sessionLengths.isNotEmpty ? sessionLengths.last : 0.0,
      'nightSleepPercentage': totalMinutes > 0 ? (nightMinutes / totalMinutes) * 100 : 0.0,
    };
  }
  
  /// Helper: Extract numeric value from event data
  static double? _extractNumericValue(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }
  
  /// Helper: Check if hour is night time (22:00 - 06:00)
  static bool _isNightTime(int hour) {
    return hour >= 22 || hour <= 6;
  }
  
  /// Validate and clamp outlier values
  static double clampValue(double value, double min, double max) {
    return math.max(min, math.min(max, value));
  }
  
  /// Round to reasonable precision for display
  static double roundToMinutes(double minutes, int interval) {
    return (minutes / interval).round() * interval.toDouble();
  }
}
