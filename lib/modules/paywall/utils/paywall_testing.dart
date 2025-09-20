import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/subscription_service.dart';
import '../controllers/launch_controller.dart';
import '../config/paywall_config.dart';

class PaywallTesting {
  static const String _testSubscriptionKey = 'test_subscription_active';
  static const String _testTrialKey = 'test_trial_active';
  static const String _paywallDismissCountKey = 'paywall_dismiss_count';
  
  // Test subscription states
  static Future<void> simulateSubscriptionActive() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_testSubscriptionKey, true);
    
    // Refresh subscription service
    try {
      final subscriptionService = Get.find<SubscriptionService>();
      await subscriptionService.checkSubscriptionStatus();
    } catch (e) {
      print('Error refreshing subscription service: $e');
    }
    
    Get.snackbar(
      'Test Mode',
      'Subscription activated for testing',
      snackPosition: SnackPosition.TOP,
    );
  }
  
  static Future<void> simulateSubscriptionInactive() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_testSubscriptionKey, false);
    
    // Refresh subscription service
    try {
      final subscriptionService = Get.find<SubscriptionService>();
      await subscriptionService.checkSubscriptionStatus();
    } catch (e) {
      print('Error refreshing subscription service: $e');
    }
    
    Get.snackbar(
      'Test Mode',
      'Subscription deactivated for testing',
      snackPosition: SnackPosition.TOP,
    );
  }
  
  static Future<void> simulateTrialActive() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_testTrialKey, true);
    
    Get.snackbar(
      'Test Mode',
      'Trial activated for testing',
      snackPosition: SnackPosition.TOP,
    );
  }
  
  static Future<void> simulateTrialExpired() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_testTrialKey, false);
    
    Get.snackbar(
      'Test Mode',
      'Trial expired for testing',
      snackPosition: SnackPosition.TOP,
    );
  }
  
  // Reset all test states
  static Future<void> resetTestStates() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_testSubscriptionKey);
    await prefs.remove(_testTrialKey);
    await prefs.remove(_paywallDismissCountKey);
    await prefs.remove('paywall_discount_deadline');
    await prefs.remove('onboarding_completed');
    
    Get.snackbar(
      'Test Mode',
      'All test states reset',
      snackPosition: SnackPosition.TOP,
    );
  }
  
  // Test paywall flows
  static Future<void> testOnboardingFlow() async {
    await resetTestStates();
    
    try {
      final launchController = Get.find<LaunchController>();
      launchController.resetAppState();
    } catch (e) {
      print('Error resetting launch controller: $e');
    }
    
    Get.snackbar(
      'Test Mode',
      'Testing onboarding flow',
      snackPosition: SnackPosition.TOP,
    );
  }
  
  static Future<void> testPaywallFlow() async {
    await simulateSubscriptionInactive();
    Get.toNamed('/paywall-story');
    
    Get.snackbar(
      'Test Mode',
      'Testing paywall flow',
      snackPosition: SnackPosition.TOP,
    );
  }
  
  static Future<void> testPremiumFeatureGating() async {
    await simulateSubscriptionInactive();
    
    Get.snackbar(
      'Test Mode',
      'Testing premium feature gating - try accessing statistics',
      snackPosition: SnackPosition.TOP,
    );
  }
  
  // Paywall analytics simulation
  static Future<void> trackPaywallShown({String? source}) async {
    if (!PaywallConfig.enablePaywallAnalytics) return;
    
    print('Analytics: Paywall shown from source: ${source ?? 'unknown'}');
    // TODO: Integrate with your analytics service
  }
  
  static Future<void> trackPaywallDismissed({String? reason}) async {
    if (!PaywallConfig.enablePaywallAnalytics) return;
    
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(_paywallDismissCountKey) ?? 0;
    await prefs.setInt(_paywallDismissCountKey, currentCount + 1);
    
    print('Analytics: Paywall dismissed. Reason: ${reason ?? 'unknown'}, Count: ${currentCount + 1}');
    // TODO: Integrate with your analytics service
  }
  
  static Future<void> trackPurchaseAttempted({required String productId}) async {
    if (!PaywallConfig.enablePaywallAnalytics) return;
    
    print('Analytics: Purchase attempted for product: $productId');
    // TODO: Integrate with your analytics service
  }
  
  static Future<void> trackPurchaseCompleted({required String productId}) async {
    if (!PaywallConfig.enablePaywallAnalytics) return;
    
    print('Analytics: Purchase completed for product: $productId');
    // TODO: Integrate with your analytics service
  }
  
  static Future<void> trackPurchaseFailed({required String productId, required String error}) async {
    if (!PaywallConfig.enablePaywallAnalytics) return;
    
    print('Analytics: Purchase failed for product: $productId, Error: $error');
    // TODO: Integrate with your analytics service
  }
  
  // Check test subscription status
  static Future<bool> isTestSubscriptionActive() async {
    if (!PaywallConfig.isTestMode) return false;
    
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_testSubscriptionKey) ?? false;
  }
  
  static Future<bool> isTestTrialActive() async {
    if (!PaywallConfig.isTestMode) return false;
    
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_testTrialKey) ?? false;
  }
  
  // Get paywall dismiss count
  static Future<int> getPaywallDismissCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_paywallDismissCountKey) ?? 0;
  }
  
  // Check if should show paywall based on dismiss count
  static Future<bool> shouldShowPaywallBasedOnDismissals() async {
    final dismissCount = await getPaywallDismissCount();
    return dismissCount < PaywallConfig.maxPaywallDismissals;
  }
  
  // Debug information
  static Future<Map<String, dynamic>> getDebugInfo() async {
    final prefs = await SharedPreferences.getInstance();
    
    return {
      'testMode': PaywallConfig.isTestMode,
      'testSubscriptionActive': await isTestSubscriptionActive(),
      'testTrialActive': await isTestTrialActive(),
      'paywallDismissCount': await getPaywallDismissCount(),
      'onboardingCompleted': prefs.getBool('onboarding_completed') ?? false,
      'discountDeadline': prefs.getString('paywall_discount_deadline'),
      'configValid': PaywallConfig.validateConfig(),
    };
  }
  
  // Print debug info to console
  static Future<void> printDebugInfo() async {
    final info = await getDebugInfo();
    print('=== Paywall Debug Info ===');
    info.forEach((key, value) {
      print('$key: $value');
    });
    print('========================');
  }
}
