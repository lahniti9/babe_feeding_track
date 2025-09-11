import 'package:get/get.dart';
import '../../events/models/event_record.dart';
import '../../events/services/events_store.dart';
import '../services/stats_service.dart';

class MonthlyOverviewController extends GetxController {
  MonthlyOverviewController({required this.childId, required this.month});
  final String childId;
  final DateTime month; // any date inside the month

  final tags = <DateTime, Set<EventType>>{}.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);

    Get.find<EventsStore>().watch(
      childId: childId, 
      from: start, 
      to: end
    ).listen((evts) {
      tags.value = StatsService.tagsByDay(evts, {
        EventType.feedingBreast,
        EventType.feedingBottle,
        EventType.sleeping,
        EventType.diaper,
        EventType.medicine,
        EventType.temperature,
        EventType.doctor,
        EventType.activity,
      });
      isLoading.value = false;
    });
  }

  bool get hasData => tags.isNotEmpty;

  Set<EventType> getTagsForDay(DateTime day) {
    return tags[dateOnly(day)] ?? {};
  }

  bool hasEventOnDay(DateTime day, EventType type) {
    return getTagsForDay(day).contains(type);
  }

  int get daysWithEvents => tags.length;

  int get daysInMonth {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    return end.difference(start).inDays;
  }

  double get eventCoverage => daysInMonth > 0 ? daysWithEvents / daysInMonth : 0.0;

  Map<EventType, int> get eventTypeCounts {
    final counts = <EventType, int>{};
    for (final dayTags in tags.values) {
      for (final type in dayTags) {
        counts[type] = (counts[type] ?? 0) + 1;
      }
    }
    return counts;
  }

  List<DateTime> get daysWithFeeding {
    return tags.entries
        .where((e) => e.value.contains(EventType.feedingBreast) || e.value.contains(EventType.feedingBottle))
        .map((e) => e.key)
        .toList()..sort();
  }

  List<DateTime> get daysWithSleep {
    return tags.entries
        .where((e) => e.value.contains(EventType.sleeping))
        .map((e) => e.key)
        .toList()..sort();
  }

  List<DateTime> get daysWithDiapers {
    return tags.entries
        .where((e) => e.value.contains(EventType.diaper))
        .map((e) => e.key)
        .toList()..sort();
  }
}
