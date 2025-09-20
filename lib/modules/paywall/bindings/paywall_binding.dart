import 'package:get/get.dart';
import '../controllers/paywall_controller.dart';
import '../services/subscription_service.dart';

class PaywallBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize subscription service if not already initialized
    if (!Get.isRegistered<SubscriptionService>()) {
      Get.put(SubscriptionService(), permanent: true);
    }
    
    // Initialize paywall controller
    Get.lazyPut<PaywallController>(() => PaywallController());
  }
}
