import 'package:get/get.dart';
import '../../events/models/event_record.dart';
import '../../events/services/events_store.dart';
import '../services/stats_service.dart';

class WeightStatsController extends GetxController {
  WeightStatsController({required this.childId});
  final String childId;

  final points = <MapEntry<DateTime, double>>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final store = Get.find<EventsStore>();
    store.watch(
      childId: childId,
      types: {EventType.weight},
    ).listen((evts) {
      final m = StatsService.latestNumericPerDay(evts, 'valueKg');
      points.assignAll(m.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
      isLoading.value = false;
    });
  }

  bool get hasData => points.isNotEmpty;

  String formatWeight(double kg) {
    // Convert to pounds for display
    final pounds = kg * 2.20462;
    return '${pounds.toStringAsFixed(1)} lbs';
  }

  double get latestWeight => points.isNotEmpty ? points.last.value : 0.0;
  DateTime? get latestDate => points.isNotEmpty ? points.last.key : null;
}
