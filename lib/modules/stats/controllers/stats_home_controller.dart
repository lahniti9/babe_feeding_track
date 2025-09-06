import 'package:get/get.dart';
import '../../profile/profile_controller.dart';

class StatsHomeController extends GetxController {
  final ProfileController _profileController = Get.find<ProfileController>();

  // Current active child
  String? get currentChildId => _profileController.activeChild?.id;

  // Navigation methods for each stats section
  void navigateToHeadCircumference() {
    if (currentChildId == null) return;
    Get.toNamed('/stats/head-circumference', arguments: {'childId': currentChildId});
  }

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
