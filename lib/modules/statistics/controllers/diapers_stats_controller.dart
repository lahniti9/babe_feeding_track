import 'package:get/get.dart';
import '../../events/models/event_record.dart';
import '../../events/services/events_store.dart';
import '../services/stats_service.dart';

class DiapersStatsController extends GetxController {
  DiapersStatsController({required this.childId});
  final String childId;

  // per day: { wet: x, dirty: y, mixed: z }
  final perDay = <DateTime, Map<String, int>>{}.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    Get.find<EventsStore>()
        .watch(childId: childId, types: {EventType.diaper})
        .listen((evts) {
      perDay.value = StatsService.diaperCounts(evts);
      isLoading.value = false;
    });
  }

  bool get hasData => perDay.isNotEmpty;

  Map<String, int> get todayCounts {
    final today = dateOnly(DateTime.now());
    return perDay[today] ?? {};
  }

  int get totalToday {
    return todayCounts.values.fold(0, (sum, count) => sum + count);
  }

  int get wetToday => todayCounts['wet'] ?? 0;
  int get dirtyToday => todayCounts['dirty'] ?? 0;
  int get mixedToday => todayCounts['mixed'] ?? 0;

  double get averagePerDay {
    if (perDay.isEmpty) return 0.0;
    final totalDiapers = perDay.values.fold(0, (sum, dayMap) {
      return sum + dayMap.values.fold(0, (daySum, count) => daySum + count);
    });
    return totalDiapers / perDay.length;
  }

  List<MapEntry<DateTime, int>> get totalPerDay {
    return perDay.entries.map((e) {
      final total = e.value.values.fold(0, (sum, count) => sum + count);
      return MapEntry(e.key, total);
    }).toList()..sort((a, b) => a.key.compareTo(b.key));
  }

  Map<String, int> get typeDistribution {
    final distribution = <String, int>{};
    for (final dayMap in perDay.values) {
      for (final entry in dayMap.entries) {
        distribution[entry.key] = (distribution[entry.key] ?? 0) + entry.value;
      }
    }
    return distribution;
  }
}
