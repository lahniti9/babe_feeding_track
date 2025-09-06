import 'package:get/get.dart';
import '../services/children_store.dart';

class ChildrenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChildrenStore>(() => ChildrenStore());
  }
}
