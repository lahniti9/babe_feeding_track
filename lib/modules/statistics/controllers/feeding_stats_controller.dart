import 'package:get/get.dart';
import '../../events/models/event_record.dart';
import '../../events/services/events_store.dart';
import '../services/stats_service.dart';

class FeedingStatsController extends GetxController {
  FeedingStatsController({required this.childId});
  final String childId;

  // sum of breast + bottle volumes per day
  final volumePerDay = <MapEntry<DateTime, double>>[].obs;
  final countPerDay = <MapEntry<DateTime, int>>[].obs;
  final durationPerDay = <MapEntry<DateTime, double>>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final store = Get.find<EventsStore>();
    
    // Volume from bottles and expressed milk
    store.watch(
      childId: childId,
      types: {EventType.feedingBottle, EventType.expressing}
    ).listen((evts) {
      final vol = StatsService.sumVolumePerDay(evts, key: 'volume');
      volumePerDay.assignAll(vol.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
      isLoading.value = false;
    });

    // Count of feeding sessions (breast feeding)
    store.watch(
      childId: childId,
      types: {EventType.feedingBreast}
    ).listen((evts) {
      final counts = StatsService.countPerDay(evts);
      countPerDay.assignAll(counts.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
    });

    // Duration of feeding sessions
    store.watch(
      childId: childId,
      types: {EventType.feedingBreast}
    ).listen((evts) {
      final duration = StatsService.sumMinutesPerDay(evts);
      durationPerDay.assignAll(duration.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
    });
  }

  bool get hasVolumeData => volumePerDay.isNotEmpty;
  bool get hasCountData => countPerDay.isNotEmpty;
  bool get hasDurationData => durationPerDay.isNotEmpty;
  bool get hasAnyData => hasVolumeData || hasCountData || hasDurationData;

  double get totalVolumeToday {
    final today = dateOnly(DateTime.now());
    return volumePerDay.where((e) => e.key == today).fold(0.0, (sum, e) => sum + e.value);
  }

  int get feedingCountToday {
    final today = dateOnly(DateTime.now());
    return countPerDay.where((e) => e.key == today).fold(0, (sum, e) => sum + e.value);
  }

  double get feedingDurationToday {
    final today = dateOnly(DateTime.now());
    return durationPerDay.where((e) => e.key == today).fold(0.0, (sum, e) => sum + e.value);
  }
}
