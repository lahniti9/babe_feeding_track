import 'package:get/get.dart';
import '../../children/services/children_store.dart';

class StatsHomeController extends GetxController {
  final ChildrenStore _childrenStore = Get.find<ChildrenStore>();

  // Current active child
  String? get currentChildId => _childrenStore.activeId.value;

  // Navigation methods for each stats section
  void navigateToHeight() {
    if (currentChildId == null) return;
    Get.toNamed('/stats/height', arguments: {'childId': currentChildId});
  }

  void navigateToWeight() {
    if (currentChildId == null) return;
    Get.toNamed('/stats/weight', arguments: {'childId': currentChildId});
  }

  void navigateToHealthDiary() {
    if (currentChildId == null) return;
    Get.toNamed('/stats/health-diary', arguments: {'childId': currentChildId});
  }

  void navigateToMonthlyOverview() {
    if (currentChildId == null) return;
    Get.toNamed('/stats/monthly-overview', arguments: {'childId': currentChildId});
  }

  void navigateToFeeding() {
    if (currentChildId == null) return;
    Get.toNamed('/stats/feeding', arguments: {'childId': currentChildId});
  }

  void navigateToSleeping() {
    if (currentChildId == null) return;
    Get.toNamed('/stats/sleeping', arguments: {'childId': currentChildId});
  }

  void navigateToDiapers() {
    if (currentChildId == null) return;
    Get.toNamed('/stats/diapers', arguments: {'childId': currentChildId});
  }

  void navigateToDailyResults() {
    if (currentChildId == null) return;
    Get.toNamed('/stats/daily-results', arguments: {'childId': currentChildId});
  }
}
