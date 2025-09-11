import 'package:get/get.dart';
import '../../events/models/event_record.dart';
import '../../events/services/events_store.dart';
import '../services/stats_service.dart';

class DailyResultsController extends GetxController {
  DailyResultsController({required this.childId, required this.day});
  final String childId;
  final DateTime day;

  // minutes per hour for categories
  final sleep = List<int>.filled(24, 0).obs;
  final feed = List<int>.filled(24, 0).obs;
  final activity = List<int>.filled(24, 0).obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    final store = Get.find<EventsStore>();

    store.watch(
      childId: childId, 
      from: start, 
      to: end, 
      types: {EventType.sleeping}
    ).listen((evts) {
      sleep.assignAll(StatsService.minutesPerHour(evts));
      isLoading.value = false;
    });

    store.watch(
      childId: childId,
      from: start,
      to: end,
      types: {EventType.feedingBreast, EventType.feedingBottle}
    ).listen((evts) {
      feed.assignAll(StatsService.minutesPerHour(evts));
    });

    store.watch(
      childId: childId, 
      from: start, 
      to: end, 
      types: {EventType.activity}
    ).listen((evts) {
      activity.assignAll(StatsService.minutesPerHour(evts));
    });
  }

  bool get hasData => sleep.any((m) => m > 0) || feed.any((m) => m > 0) || activity.any((m) => m > 0);

  int get totalSleepMinutes => sleep.fold(0, (sum, m) => sum + m);
  int get totalFeedMinutes => feed.fold(0, (sum, m) => sum + m);
  int get totalActivityMinutes => activity.fold(0, (sum, m) => sum + m);

  String get totalSleepFormatted {
    final hours = totalSleepMinutes ~/ 60;
    final minutes = totalSleepMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  String get totalFeedFormatted {
    final hours = totalFeedMinutes ~/ 60;
    final minutes = totalFeedMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String get totalActivityFormatted {
    final hours = totalActivityMinutes ~/ 60;
    final minutes = totalActivityMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  // Get the dominant activity for each hour
  List<String> get hourlyDominantActivity {
    final result = <String>[];
    for (int hour = 0; hour < 24; hour++) {
      final sleepMins = sleep[hour];
      final feedMins = feed[hour];
      final actMins = activity[hour];
      
      if (sleepMins >= feedMins && sleepMins >= actMins && sleepMins > 0) {
        result.add('sleep');
      } else if (feedMins >= actMins && feedMins > 0) {
        result.add('feed');
      } else if (actMins > 0) {
        result.add('activity');
      } else {
        result.add('none');
      }
    }
    return result;
  }

  // Get percentage breakdown for the day
  Map<String, double> get dayBreakdown {
    final total = totalSleepMinutes + totalFeedMinutes + totalActivityMinutes;
    if (total == 0) return {'sleep': 0, 'feed': 0, 'activity': 0, 'other': 100};
    
    final sleepPercent = (totalSleepMinutes / total) * 100;
    final feedPercent = (totalFeedMinutes / total) * 100;
    final activityPercent = (totalActivityMinutes / total) * 100;
    final otherPercent = 100 - sleepPercent - feedPercent - activityPercent;
    
    return {
      'sleep': sleepPercent,
      'feed': feedPercent,
      'activity': activityPercent,
      'other': otherPercent.clamp(0, 100),
    };
  }
}
