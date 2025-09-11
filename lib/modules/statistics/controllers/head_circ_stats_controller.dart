import 'package:get/get.dart';
import '../../events/models/event_record.dart';
import '../../events/services/events_store.dart';
import '../services/stats_service.dart';

class HeadCircStatsController extends GetxController {
  HeadCircStatsController({required this.childId});
  final String childId;

  final points = <MapEntry<DateTime, double>>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    Get.find<EventsStore>().watch(
      childId: childId,
      types: {EventType.headCircumference},
    ).listen((evts) {
      final m = StatsService.latestNumericPerDay(evts, 'valueCm');
      points.assignAll(m.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
      isLoading.value = false;
    });
  }

  bool get hasData => points.isNotEmpty;

  String formatCircumference(double cm) {
    return '${cm.toStringAsFixed(1)} cm';
  }

  double get latestCircumference => points.isNotEmpty ? points.last.value : 0.0;
  DateTime? get latestDate => points.isNotEmpty ? points.last.key : null;
}
