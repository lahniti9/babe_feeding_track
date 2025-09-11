import 'package:get/get.dart';
import '../../events/models/event_record.dart';
import '../../events/services/events_store.dart';
import '../services/stats_service.dart';

class SleepingStatsController extends GetxController {
  SleepingStatsController({required this.childId});
  final String childId;

  final minutesPerDay = <MapEntry<DateTime, double>>[].obs;
  final minutesByHour = List<int>.filled(24, 0).obs; // 0..23
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final store = Get.find<EventsStore>();
    store.watch(
      childId: childId, 
      types: {EventType.sleeping}
    ).listen((evts) {
      final perDay = StatsService.sumMinutesPerDay(evts);
      minutesPerDay.assignAll(perDay.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
      minutesByHour.assignAll(StatsService.minutesPerHour(evts));
      isLoading.value = false;
    });
  }

  bool get hasData => minutesPerDay.isNotEmpty;

  double get averageSleepHours {
    if (minutesPerDay.isEmpty) return 0.0;
    final totalMinutes = minutesPerDay.fold(0.0, (sum, e) => sum + e.value);
    return (totalMinutes / minutesPerDay.length) / 60.0;
  }

  double get sleepToday {
    final today = dateOnly(DateTime.now());
    final todayEntry = minutesPerDay.where((e) => e.key == today).firstOrNull;
    return todayEntry?.value ?? 0.0;
  }

  String formatSleepTime(double minutes) {
    final hours = (minutes / 60).floor();
    final mins = (minutes % 60).round();
    if (hours > 0) {
      return '${hours}h ${mins}m';
    } else {
      return '${mins}m';
    }
  }

  int get peakSleepHour {
    int maxHour = 0;
    int maxMinutes = 0;
    for (int i = 0; i < 24; i++) {
      if (minutesByHour[i] > maxMinutes) {
        maxMinutes = minutesByHour[i];
        maxHour = i;
      }
    }
    return maxHour;
  }
}
