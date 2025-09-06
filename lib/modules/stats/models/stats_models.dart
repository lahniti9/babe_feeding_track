enum Bucket { day, week, month, year }

class StatsRange {
  final DateTime start;
  final DateTime end;
  final Bucket bucket;

  const StatsRange({
    required this.start,
    required this.end,
    required this.bucket,
  });

  // Factory constructors for common ranges
  factory StatsRange.lastWeek() {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 7));
    return StatsRange(start: start, end: now, bucket: Bucket.day);
  }

  factory StatsRange.lastMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 1, now.day);
    return StatsRange(start: start, end: now, bucket: Bucket.day);
  }

  factory StatsRange.last3Months() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 3, now.day);
    return StatsRange(start: start, end: now, bucket: Bucket.month);
  }

  factory StatsRange.lastYear() {
    final now = DateTime.now();
    final start = DateTime(now.year - 1, now.month, now.day);
    return StatsRange(start: start, end: now, bucket: Bucket.month);
  }

  factory StatsRange.currentMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);
    return StatsRange(start: start, end: end, bucket: Bucket.day);
  }

  factory StatsRange.today() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    return StatsRange(start: start, end: end, bucket: Bucket.day);
  }

  @override
  String toString() => 'StatsRange(start: $start, end: $end, bucket: $bucket)';
}

class Point {
  final DateTime x;
  final double y;

  const Point(this.x, this.y);

  @override
  String toString() => 'Point(x: $x, y: $y)';
}

class Bar {
  final dynamic x; // Can be DateTime, String, or int
  final double y;

  const Bar(this.x, this.y);

  @override
  String toString() => 'Bar(x: $x, y: $y)';
}

class RadialArc {
  final double startAngle; // in degrees (0-360)
  final double sweepAngle; // in degrees
  final String? label;
  final String? color;

  const RadialArc(
    this.startAngle,
    this.sweepAngle, {
    this.label,
    this.color,
  });

  @override
  String toString() => 'RadialArc(start: $startAngle°, sweep: $sweepAngle°)';
}

// Helper functions for date/time calculations
class DateTimeUtils {
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime startOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  static String bucketKey(DateTime date, Bucket bucket) {
    switch (bucket) {
      case Bucket.day:
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      case Bucket.week:
        final weekStart = startOfWeek(date);
        return '${weekStart.year}-W${_weekOfYear(weekStart)}';
      case Bucket.month:
        return '${date.year}-${date.month.toString().padLeft(2, '0')}';
      case Bucket.year:
        return date.year.toString();
    }
  }

  static int _weekOfYear(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final dayOfYear = date.difference(startOfYear).inDays + 1;
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  static double angleFromTime(DateTime time) {
    // Convert time to angle (0-360 degrees)
    // 0 degrees = midnight, 90 degrees = 6 AM, etc.
    final hour = time.hour;
    final minute = time.minute;
    return (hour * 15.0) + (minute * 0.25); // 360/24 = 15 degrees per hour
  }

  static double angleSpanFromDuration(Duration duration) {
    // Convert duration to angle span
    final totalMinutes = duration.inMinutes;
    return totalMinutes * 0.25; // 0.25 degrees per minute
  }

  static bool isDaytimeSleep(DateTime fellAsleep, DateTime wokeUp) {
    // Define daytime as 6 AM to 9 PM
    final daytimeStart = 6;
    final daytimeEnd = 21;
    
    final sleepHour = fellAsleep.hour;
    final wakeHour = wokeUp.hour;

    // Sleep is considered daytime if it starts and ends during daytime hours
    return sleepHour >= daytimeStart && sleepHour < daytimeEnd &&
           wakeHour >= daytimeStart && wakeHour < daytimeEnd;
  }

  static bool isNightSleep(DateTime fellAsleep, DateTime wokeUp) {
    // Night sleep is from 9 PM to 9 AM
    final nightStart = 21; // 9 PM
    final nightEnd = 9;    // 9 AM
    
    final sleepHour = fellAsleep.hour;
    
    // Night sleep typically starts after 9 PM or before 9 AM
    return sleepHour >= nightStart || sleepHour < nightEnd;
  }
}

// Unit conversion utilities
class UnitConverter {
  static double gramsToLbs(int grams) {
    return grams * 0.00220462;
  }

  static double gramsToOz(int grams) {
    return grams * 0.035274;
  }

  static int lbsToGrams(double lbs) {
    return (lbs / 0.00220462).round();
  }

  static int ozToGrams(double oz) {
    return (oz / 0.035274).round();
  }

  static double cmToInches(double cm) {
    return cm * 0.393701;
  }

  static double inchesToCm(double inches) {
    return inches * 2.54;
  }

  static String formatWeight(int grams, {bool useMetric = true}) {
    if (useMetric) {
      return '${grams}g';
    } else {
      final totalOz = gramsToOz(grams);
      final lbs = (totalOz / 16).floor();
      final oz = (totalOz % 16).round();
      return '${lbs}lb ${oz}oz';
    }
  }

  static String formatHeight(double cm, {bool useMetric = true}) {
    if (useMetric) {
      return '${cm.toStringAsFixed(1)}cm';
    } else {
      final inches = cmToInches(cm);
      final feet = (inches / 12).floor();
      final remainingInches = (inches % 12).round();
      return '${feet}ft ${remainingInches}in';
    }
  }
}
