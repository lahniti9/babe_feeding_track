import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../services/subscription_service.dart';
import '../../../routes/app_routes.dart';

class LaunchController extends GetxController {
  final _storage = GetStorage();
  final _isSubscribed = false.obs;
  final _hasCompletedOnboarding = false.obs;
  final _isInitialized = false.obs;
  
  bool get isSubscribed => _isSubscribed.value;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding.value;
  bool get isInitialized => _isInitialized.value;
  
  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    try {
      // Initialize subscription service
      if (!Get.isRegistered<SubscriptionService>()) {
        Get.put(SubscriptionService(), permanent: true);
      }
      
      final subscriptionService = Get.find<SubscriptionService>();
      
      // Check subscription status
      final isSubscribed = await subscriptionService.checkSubscriptionStatus();
      _isSubscribed.value = isSubscribed;
      
      // Check onboarding status
      final hasCompletedOnboarding = _storage.read('onboarding_completed') ?? false;
      _hasCompletedOnboarding.value = hasCompletedOnboarding;
      
      _isInitialized.value = true;
      
      // Navigate based on state
      _navigateBasedOnState();
    } catch (e) {
      print('Error initializing app: $e');
      // Fallback navigation
      _navigateToOnboarding();
    }
  }
  
  void _navigateBasedOnState() {
    if (!_hasCompletedOnboarding.value) {
      // New user - go to onboarding
      _navigateToOnboarding();
    } else if (!_isSubscribed.value) {
      // Existing user without subscription - go to paywall
      _navigateToPaywall();
    } else {
      // Subscribed user - go to main app
      _navigateToMainApp();
    }
  }
  
  void _navigateToOnboarding() {
    Get.offAllNamed(Routes.startGoal);
  }
  
  void _navigateToPaywall() {
    Get.offAllNamed(Routes.paywallStory);
  }
  
  void _navigateToMainApp() {
    Get.offAllNamed(Routes.tabs);
  }
  
  // Called when onboarding is completed
  Future<void> onOnboardingCompleted() async {
    _hasCompletedOnboarding.value = true;
    
    // Check subscription status again
    final subscriptionService = Get.find<SubscriptionService>();
    final isSubscribed = await subscriptionService.checkSubscriptionStatus();
    _isSubscribed.value = isSubscribed;
    
    if (_isSubscribed.value) {
      _navigateToMainApp();
    } else {
      _navigateToPaywall();
    }
  }
  
  // Called when subscription is purchased
  Future<void> onSubscriptionPurchased() async {
    _isSubscribed.value = true;
    _navigateToMainApp();
  }
  
  // Called when subscription is restored
  Future<void> onSubscriptionRestored() async {
    _isSubscribed.value = true;
    _navigateToMainApp();
  }
  
  // Refresh subscription status
  Future<void> refreshSubscriptionStatus() async {
    try {
      final subscriptionService = Get.find<SubscriptionService>();
      final isSubscribed = await subscriptionService.checkSubscriptionStatus();
      _isSubscribed.value = isSubscribed;
    } catch (e) {
      print('Error refreshing subscription status: $e');
    }
  }
  
  // For testing - reset app state
  void resetAppState() {
    _storage.remove('onboarding_completed');
    _hasCompletedOnboarding.value = false;
    _isSubscribed.value = false;
    _navigateToOnboarding();
  }
  
  // Check if user should see paywall for premium features
  Future<bool> shouldShowPaywallForFeature() async {
    if (_isSubscribed.value) {
      return false;
    }
    
    // Refresh subscription status to be sure
    await refreshSubscriptionStatus();
    return !_isSubscribed.value;
  }
  
  // Navigate to paywall from within the app
  void showPaywallForFeature({String? feature}) {
    Get.toNamed(Routes.paywallStory, arguments: {'feature': feature});
  }
}
