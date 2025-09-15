import 'package:timezone/timezone.dart' as tz;

/// Timezone-aware clock service for accurate date/time calculations
/// Handles DST transitions and provides consistent day/hour bucketing
class TimezoneClock {
  final tz.Location location;
  
  TimezoneClock(this.location);
  
  /// Create clock with timezone name (e.g., 'America/New_York', 'Europe/London')
  factory TimezoneClock.fromName(String timezoneName) {
    try {
      final location = tz.getLocation(timezoneName);
      return TimezoneClock(location);
    } catch (e) {
      // Fallback to UTC if timezone not found
      return TimezoneClock(tz.UTC);
    }
  }
  
  /// Create clock with local timezone
  factory TimezoneClock.local() {
    return TimezoneClock(tz.local);
  }
  
  /// Get the start of day in the timezone (00:00:00)
  tz.TZDateTime dayStart(DateTime dateTime) {
    final tzDateTime = tz.TZDateTime.from(dateTime, location);
    return tz.TZDateTime(location, tzDateTime.year, tzDateTime.month, tzDateTime.day);
  }
  
  /// Get the end of day in the timezone (23:59:59.999)
  tz.TZDateTime dayEnd(DateTime dateTime) {
    final start = dayStart(dateTime);
    return start.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
  }

  /// Get the start of next day (exclusive end for filtering)
  tz.TZDateTime dayEndExclusive(DateTime dateTime) {
    final start = dayStart(dateTime);
    return start.add(const Duration(days: 1));
  }
  
  /// Get the start of hour in the timezone
  tz.TZDateTime hourStart(DateTime dateTime) {
    final tzDateTime = tz.TZDateTime.from(dateTime, location);
    return tz.TZDateTime(location, tzDateTime.year, tzDateTime.month, 
                        tzDateTime.day, tzDateTime.hour);
  }
  
  /// Convert DateTime to timezone-aware DateTime
  tz.TZDateTime toTimezone(DateTime dateTime) {
    return tz.TZDateTime.from(dateTime, location);
  }
  
  /// Get date-only representation (year, month, day) in timezone
  DateTime dateOnly(DateTime dateTime) {
    final tzDateTime = tz.TZDateTime.from(dateTime, location);
    return DateTime(tzDateTime.year, tzDateTime.month, tzDateTime.day);
  }
  
  /// Check if a date falls within DST in this timezone
  bool isDST(DateTime dateTime) {
    final tzDateTime = tz.TZDateTime.from(dateTime, location);
    return tzDateTime.timeZone.isDst;
  }
  
  /// Get the duration of a day in this timezone (handles DST transitions)
  /// Returns 23, 24, or 25 hours depending on DST transitions
  Duration dayDuration(DateTime dateTime) {
    final start = dayStart(dateTime);
    final end = dayStart(dateTime.add(const Duration(days: 1)));
    return end.difference(start);
  }
  
  /// Split a duration event across day boundaries in timezone
  /// Returns list of (date, duration) pairs for each day the event spans
  List<MapEntry<DateTime, Duration>> splitEventAcrossDays({
    required DateTime startAt,
    required DateTime endAt,
  }) {
    if (!endAt.isAfter(startAt)) {
      return []; // Invalid duration
    }
    
    final result = <MapEntry<DateTime, Duration>>[];
    var currentStart = startAt;
    
    while (currentStart.isBefore(endAt)) {
      final nextDayStart = dayStart(currentStart.add(const Duration(days: 1)));
      
      // Determine the end time for this day segment
      final segmentEnd = endAt.isBefore(nextDayStart) ? endAt : nextDayStart;
      
      // Calculate duration for this day
      final segmentDuration = segmentEnd.difference(currentStart);
      
      if (segmentDuration.inMilliseconds > 0) {
        result.add(MapEntry(dateOnly(currentStart), segmentDuration));
      }
      
      // Move to next day
      currentStart = nextDayStart;
    }
    
    return result;
  }
  
  /// Get hour of day (0-23) in timezone
  int hourOfDay(DateTime dateTime) {
    final tzDateTime = tz.TZDateTime.from(dateTime, location);
    return tzDateTime.hour;
  }
  
  /// Check if two dates are the same day in timezone
  bool isSameDay(DateTime date1, DateTime date2) {
    final day1 = dateOnly(date1);
    final day2 = dateOnly(date2);
    return day1.year == day2.year && 
           day1.month == day2.month && 
           day1.day == day2.day;
  }
  
  /// Get week start (Monday) for a given date in timezone
  DateTime weekStart(DateTime dateTime) {
    final date = dateOnly(dateTime);
    final weekday = date.weekday; // 1 = Monday, 7 = Sunday
    return date.subtract(Duration(days: weekday - 1));
  }
  
  /// Get month start for a given date in timezone
  DateTime monthStart(DateTime dateTime) {
    final tzDateTime = tz.TZDateTime.from(dateTime, location);
    return DateTime(tzDateTime.year, tzDateTime.month, 1);
  }
  
  /// Get year start for a given date in timezone
  DateTime yearStart(DateTime dateTime) {
    final tzDateTime = tz.TZDateTime.from(dateTime, location);
    return DateTime(tzDateTime.year, 1, 1);
  }
  
  /// Format duration in a human-readable way
  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
  
  /// Validate that a duration is reasonable (not negative, not too long)
  bool isValidDuration(Duration duration) {
    return duration.inMilliseconds > 0 && 
           duration.inHours <= 24; // Max 24 hours for single event
  }
  
  /// Clamp duration to reasonable bounds
  Duration clampDuration(Duration duration) {
    if (duration.inMilliseconds <= 0) {
      return Duration.zero;
    }
    if (duration.inHours > 24) {
      return const Duration(hours: 24);
    }
    return duration;
  }
}

/// Extension methods for DateTime to work with TimezoneClock
extension DateTimeTimezoneExtension on DateTime {
  /// Convert to timezone using a clock
  tz.TZDateTime inTimezone(TimezoneClock clock) {
    return clock.toTimezone(this);
  }
  
  /// Get date-only in timezone
  DateTime dateOnlyIn(TimezoneClock clock) {
    return clock.dateOnly(this);
  }
  
  /// Get hour of day in timezone
  int hourIn(TimezoneClock clock) {
    return clock.hourOfDay(this);
  }
}

/// Utility functions for common timezone operations
class TimezoneUtils {
  /// Get common timezone names
  static const commonTimezones = [
    'UTC',
    'America/New_York',
    'America/Chicago', 
    'America/Denver',
    'America/Los_Angeles',
    'Europe/London',
    'Europe/Paris',
    'Europe/Berlin',
    'Asia/Tokyo',
    'Asia/Shanghai',
    'Australia/Sydney',
  ];
  
  /// Get user-friendly timezone display name
  static String getDisplayName(String timezoneName) {
    switch (timezoneName) {
      case 'UTC': return 'UTC';
      case 'America/New_York': return 'Eastern Time';
      case 'America/Chicago': return 'Central Time';
      case 'America/Denver': return 'Mountain Time';
      case 'America/Los_Angeles': return 'Pacific Time';
      case 'Europe/London': return 'London';
      case 'Europe/Paris': return 'Paris';
      case 'Europe/Berlin': return 'Berlin';
      case 'Asia/Tokyo': return 'Tokyo';
      case 'Asia/Shanghai': return 'Shanghai';
      case 'Australia/Sydney': return 'Sydney';
      default: return timezoneName;
    }
  }
  
  /// Detect device timezone (fallback to UTC)
  static String getDeviceTimezone() {
    try {
      return tz.local.name;
    } catch (e) {
      return 'UTC';
    }
  }
}
