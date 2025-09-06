import 'package:get/get.dart';
import '../controllers/stats_home_controller.dart';

class StatsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatsHomeController>(() => StatsHomeController());
  }
}
