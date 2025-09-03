import 'package:get/get.dart';
import '../tabs_controller.dart';
import '../../timeline/tracking_controller.dart';
import '../../profile/profile_controller.dart';

class TabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabsController>(() => TabsController());
    Get.lazyPut<TrackingController>(() => TrackingController());
    Get.put<ProfileController>(ProfileController()); // Use put instead of lazyPut to ensure it's available
  }
}
