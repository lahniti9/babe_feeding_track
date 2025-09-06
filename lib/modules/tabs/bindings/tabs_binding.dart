import 'package:get/get.dart';
import '../tabs_controller.dart';
import '../../timeline/tracking_controller.dart';
import '../../profile/profile_controller.dart';
import '../../events/controllers/events_controller.dart';
import '../../events/controllers/bedtime_routine_controller.dart';
import '../../events/controllers/bottle_entry_controller.dart';
import '../../events/controllers/comment_controller.dart';

class TabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabsController>(() => TabsController());
    Get.lazyPut<TrackingController>(() => TrackingController());
    Get.put<ProfileController>(ProfileController()); // Use put instead of lazyPut to ensure it's available

    // Events module controllers
    Get.lazyPut<EventsController>(() => EventsController());
    // Note: SleepEntryController requires childId parameter, so it's created on-demand
    Get.lazyPut<BedtimeRoutineController>(() => BedtimeRoutineController());
    Get.lazyPut<BottleEntryController>(() => BottleEntryController());
    Get.lazyPut<CommentController>(() => CommentController());
  }
}
