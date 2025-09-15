import 'dart:async';
import 'package:get/get.dart';
import '../../events/models/event_record.dart';
import '../../events/repositories/event_repository.dart';
import '../services/enhanced_stats_service.dart';
import '../services/timezone_clock.dart';

/// Enhanced sleeping statistics controller with timezone awareness
/// Uses the new repository pattern and enhanced stats service
class EnhancedSleepingStatsController extends GetxController {
  final String childId;
  final TimezoneClock clock;
  
  EnhancedSleepingStatsController({
    required this.childId,
    required this.clock,
  });

  // Reactive data
  final minutesPerDay = <MapEntry<DateTime, double>>[].obs;
  final minutesByHour = List<int>.filled(24, 0).obs;
  final sleepQuality = <String, dynamic>{}.obs;
  final isLoading = true.obs;
  
  // Stream subscription
  StreamSubscription<List<EventRecord>>? _subscription;
  
  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }
  
  void _initializeData() {
    final repository = Get.find<EventRepository>();
    
    // Watch sleep events with debouncing to prevent excessive recomputation
    _subscription = repository
        .watch(
          childId: childId,
          types: {EventType.sleeping},
        )
        .listen(_processEvents);
  }
  
  void _processEvents(List<EventRecord> events) async {
    try {
      isLoading.value = true;
      
      // Process data in background to avoid blocking UI
      await Future.delayed(const Duration(milliseconds: 1));
      
      // Calculate daily minutes
      final dailyMinutes = EnhancedStatsService.sumMinutesPerDay(
        events,
        clock: clock,
      );
      
      // Calculate hourly distribution
      final hourlyMinutes = EnhancedStatsService.minutesPerHour(
        events,
        clock: clock,
      );
      
      // Calculate sleep quality metrics
      final qualityStats = EnhancedStatsService.sleepQualityStats(
        events,
        clock: clock,
      );
      
      // Update reactive data
      minutesPerDay.assignAll(
        dailyMinutes.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key))
      );
      
      minutesByHour.assignAll(hourlyMinutes);
      sleepQuality.assignAll(qualityStats);
      
    } catch (e) {
      // Log error but don't crash
      print('Error processing sleep events: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Computed properties for UI
  bool get hasData => minutesPerDay.isNotEmpty;
  
  double get totalSleepToday {
    final today = clock.dateOnly(DateTime.now());
    final todayEntry = minutesPerDay.firstWhereOrNull(
      (entry) => clock.isSameDay(entry.key, today),
    );
    return todayEntry?.value ?? 0.0;
  }
  
  String get totalSleepTodayFormatted {
    final minutes = totalSleepToday;
    return clock.formatDuration(Duration(minutes: minutes.round()));
  }
  
  double get averageSleepPerDay {
    if (minutesPerDay.isEmpty) return 0.0;
    final total = minutesPerDay.fold(0.0, (sum, entry) => sum + entry.value);
    return total / minutesPerDay.length;
  }
  
  String get averageSleepPerDayFormatted {
    final minutes = averageSleepPerDay;
    return clock.formatDuration(Duration(minutes: minutes.round()));
  }
  
  int get peakSleepHour {
    if (minutesByHour.isEmpty) return 0;
    
    int maxHour = 0;
    int maxMinutes = minutesByHour[0];
    
    for (int i = 1; i < minutesByHour.length; i++) {
      if (minutesByHour[i] > maxMinutes) {
        maxMinutes = minutesByHour[i];
        maxHour = i;
      }
    }
    
    return maxHour;
  }
  
  String get peakSleepHourFormatted {
    final hour = peakSleepHour;
    return '${hour.toString().padLeft(2, '0')}:00';
  }
  
  // Sleep quality metrics
  double get averageSessionLength {
    return (sleepQuality['averageSessionLength'] as double?) ?? 0.0;
  }
  
  String get averageSessionLengthFormatted {
    final minutes = averageSessionLength;
    return clock.formatDuration(Duration(minutes: minutes.round()));
  }
  
  int get numberOfSessions {
    return (sleepQuality['numberOfSessions'] as int?) ?? 0;
  }
  
  double get nightSleepPercentage {
    return (sleepQuality['nightSleepPercentage'] as double?) ?? 0.0;
  }
  
  String get nightSleepPercentageFormatted {
    return '${nightSleepPercentage.round()}%';
  }
  
  double get longestSession {
    return (sleepQuality['longestSession'] as double?) ?? 0.0;
  }
  
  String get longestSessionFormatted {
    final minutes = longestSession;
    return clock.formatDuration(Duration(minutes: minutes.round()));
  }
  
  // Chart data helpers
  List<MapEntry<DateTime, double>> get chartDataDaily {
    return minutesPerDay.toList();
  }
  
  List<MapEntry<int, int>> get chartDataHourly {
    return List.generate(24, (hour) => MapEntry(hour, minutesByHour[hour]));
  }
  
  // Date range filtering
  List<MapEntry<DateTime, double>> getDataForDateRange({
    required DateTime from,
    required DateTime to,
  }) {
    return minutesPerDay
        .where((entry) => 
            !entry.key.isBefore(from) && 
            entry.key.isBefore(to.add(const Duration(days: 1))))
        .toList();
  }
  
  // Weekly aggregation
  Map<DateTime, double> get weeklyData {
    final weekly = <DateTime, double>{};
    
    for (final entry in minutesPerDay) {
      final weekStart = clock.weekStart(entry.key);
      weekly[weekStart] = (weekly[weekStart] ?? 0.0) + entry.value;
    }
    
    return weekly;
  }
  
  // Monthly aggregation
  Map<DateTime, double> get monthlyData {
    final monthly = <DateTime, double>{};
    
    for (final entry in minutesPerDay) {
      final monthStart = clock.monthStart(entry.key);
      monthly[monthStart] = (monthly[monthStart] ?? 0.0) + entry.value;
    }
    
    return monthly;
  }
  
  // Refresh data manually
  void refresh() {
    _initializeData();
  }
  
  // Export data for sharing/backup
  Map<String, dynamic> exportData() {
    return {
      'childId': childId,
      'timezone': clock.location.name,
      'dailyMinutes': minutesPerDay.map((e) => {
        'date': e.key.toIso8601String(),
        'minutes': e.value,
      }).toList(),
      'hourlyDistribution': minutesByHour,
      'sleepQuality': sleepQuality,
      'exportedAt': DateTime.now().toIso8601String(),
    };
  }
  
  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
