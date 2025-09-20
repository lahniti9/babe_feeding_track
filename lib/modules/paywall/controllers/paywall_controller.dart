import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/subscription_service.dart';
import '../../../routes/app_routes.dart';
import 'launch_controller.dart';

class PaywallController extends GetxController {
  final SubscriptionService _subscriptionService = Get.find<SubscriptionService>();
  
  final _selectedPackage = Rxn<Package>();
  final _isLoading = false.obs;
  final _showTrial = true.obs;
  final _discountDeadline = Rxn<DateTime>();
  
  Package? get selectedPackage => _selectedPackage.value;
  bool get isLoading => _isLoading.value;
  bool get showTrial => _showTrial.value;
  DateTime? get discountDeadline => _discountDeadline.value;
  
  Offerings? get offerings => _subscriptionService.offerings;
  bool get annualHasTrial => _subscriptionService.annualHasTrial;
  
  static const String _deadlineKey = 'paywall_discount_deadline';
  
  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializePaywall();
  }
  
  Future<void> _initializePaywall() async {
    // Refresh offerings to ensure we have latest data
    await _subscriptionService.refreshOfferings();

    final current = offerings?.current;

    if (current == null || current.availablePackages.isEmpty) {
      // Fallback: show static prices or a "temporarily unavailable" state
      _selectedPackage.value = null;
      return;
    }

    // Set default selection to annual if available
    _selectedPackage.value = current.annual ?? current.availablePackages.first;

    // Initialize discount deadline
    await _initializeDiscountDeadline();
  }
  
  Future<void> _initializeDiscountDeadline() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDeadline = prefs.getString(_deadlineKey);
    
    if (savedDeadline == null) {
      // Set deadline to 5 minutes from now for demo
      // In production, this should be based on your actual promotion period
      final deadline = DateTime.now().add(const Duration(minutes: 5));
      await prefs.setString(_deadlineKey, deadline.toIso8601String());
      _discountDeadline.value = deadline;
    } else {
      _discountDeadline.value = DateTime.tryParse(savedDeadline);
    }
  }
  
  void selectPackage(Package package) {
    _selectedPackage.value = package;
  }
  
  void toggleTrial() {
    _showTrial.value = !_showTrial.value;
  }
  
  Future<void> purchaseSelected() async {
    final package = _selectedPackage.value;
    if (package == null) {
      Get.snackbar('Error', 'Please select a subscription plan');
      return;
    }
    
    _isLoading.value = true;
    
    try {
      await _subscriptionService.purchasePackage(package);

      // Check subscription status through the service instead of customerInfo directly
      final isSubscribed = await _subscriptionService.checkSubscriptionStatus();

      if (isSubscribed) {
        // Purchase successful, notify launch controller and navigate to main app
        try {
          final launchController = Get.find<LaunchController>();
          launchController.onSubscriptionPurchased();
        } catch (e) {
          // Fallback navigation
          Get.offAllNamed(Routes.tabs);
        }

        Get.snackbar(
          'Welcome to Premium!',
          'Your subscription is now active. Enjoy all premium features!',
          snackPosition: SnackPosition.TOP,
        );
      }
    } on PurchasesErrorCode catch (e) {
      _handlePurchaseError(e);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred. Please try again.');
    } finally {
      _isLoading.value = false;
    }
  }
  
  void _handlePurchaseError(PurchasesErrorCode error) {
    switch (error) {
      case PurchasesErrorCode.purchaseCancelledError:
        // User cancelled, don't show error
        break;
      case PurchasesErrorCode.purchaseNotAllowedError:
        Get.snackbar('Purchase Not Allowed', 'Purchases are not allowed on this device.');
        break;
      case PurchasesErrorCode.purchaseInvalidError:
        Get.snackbar('Invalid Purchase', 'This purchase is invalid. Please try again.');
        break;
      case PurchasesErrorCode.productNotAvailableForPurchaseError:
        Get.snackbar('Product Unavailable', 'This subscription is currently unavailable.');
        break;
      case PurchasesErrorCode.networkError:
        Get.snackbar('Network Error', 'Please check your internet connection and try again.');
        break;
      default:
        Get.snackbar('Purchase Error', 'Unable to complete purchase. Please try again.');
    }
  }
  
  Future<void> restorePurchases() async {
    _isLoading.value = true;
    
    try {
      await _subscriptionService.restorePurchases();

      // Check subscription status through the service
      final isSubscribed = await _subscriptionService.checkSubscriptionStatus();

      if (isSubscribed) {
        // Restore successful, notify launch controller and navigate to main app
        try {
          final launchController = Get.find<LaunchController>();
          launchController.onSubscriptionRestored();
        } catch (e) {
          // Fallback navigation
          Get.offAllNamed(Routes.tabs);
        }

        Get.snackbar(
          'Purchases Restored!',
          'Your subscription has been restored successfully.',
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'No Purchases Found',
          'No active subscriptions found to restore.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar('Restore Error', 'Unable to restore purchases. Please try again.');
    } finally {
      _isLoading.value = false;
    }
  }
  
  void skipPaywall() {
    // For testing purposes - remove in production
    Get.offAllNamed(Routes.tabs);
  }
  
  // Helper methods for UI
  String getPackagePrice(Package? package) {
    return _subscriptionService.getFormattedPrice(package);
  }
  
  String getPackageTitle(Package package) {
    final identifier = package.identifier.toLowerCase();
    if (identifier.contains('annual') || identifier.contains('year')) {
      return '1 Year';
    } else if (identifier.contains('monthly') || identifier.contains('month')) {
      return '1 Month';
    }
    return package.identifier;
  }
  
  String getPackageSubtitle(Package package) {
    final price = getPackagePrice(package);
    final identifier = package.identifier.toLowerCase();
    
    if (identifier.contains('annual') || identifier.contains('year')) {
      return '$price/year';
    } else if (identifier.contains('monthly') || identifier.contains('month')) {
      return '$price/month';
    }
    return price;
  }
  
  bool isPackageSelected(Package package) {
    return _selectedPackage.value?.identifier == package.identifier;
  }
  
  // Calculate discount percentage for annual vs monthly
  String getDiscountPercentage() {
    final annual = _subscriptionService.annualPackage;
    final monthly = _subscriptionService.monthlyPackage;
    
    if (annual == null || monthly == null) return '';
    
    final annualPrice = annual.storeProduct.price;
    final monthlyPrice = monthly.storeProduct.price * 12;
    
    if (monthlyPrice > 0) {
      final discount = ((monthlyPrice - annualPrice) / monthlyPrice * 100).round();
      return '$discount% OFF';
    }
    
    return '';
  }
}
