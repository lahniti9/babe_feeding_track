import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/paywall_config.dart';

class SubscriptionService extends GetxService {
  static SubscriptionService get to => Get.find();

  // Use the entitlement ID from config for strict checking
  static const _entitlementId = PaywallConfig.premiumEntitlementId;

  final _isSubscribed = false.obs;
  final _offerings = Rxn<Offerings>();
  final _customerInfo = Rxn<CustomerInfo>();
  final _isRevenueCatConfigured = false.obs;

  bool get isSubscribed => _isSubscribed.value;
  Offerings? get offerings => _offerings.value;
  CustomerInfo? get customerInfo => _customerInfo.value;
  bool get isRevenueCatConfigured => _isRevenueCatConfigured.value;
  
  @override
  Future<void> onInit() async {
    super.onInit();
    // Initialize in test mode first, then try RevenueCat
    _initializeMockState();

    // Try to configure RevenueCat if not in "skip" mode
    await configureRevenueCat();
  }
  
  Future<void> configureRevenueCat() async {
    try {
      // Skip entirely in intentional test mode
      if (PaywallConfig.shouldSkipPaywall) {
        print('RevenueCat skipped (dev skip).');
        return;
      }

      final apiKey = Platform.isIOS
          ? PaywallConfig.iosApiKey
          : PaywallConfig.androidApiKey;

      // Don't configure with placeholder keys
      if (apiKey.isEmpty || apiKey.contains('test_key_here')) {
        print('RevenueCat not configured (placeholder key).');
        return;
      }

      await Purchases.setLogLevel(LogLevel.debug); // remove in release
      await Purchases.configure(
        PurchasesConfiguration(apiKey)
          ..appUserID = null,
      );

      // Keep service state in sync with RC
      Purchases.addCustomerInfoUpdateListener((info) {
        _customerInfo.value = info;
        _updateSubscriptionStatus(info);
      });

      _isRevenueCatConfigured.value = true;

      // Prime cache
      await refreshOfferings();
      final info = await Purchases.getCustomerInfo();
      _customerInfo.value = info;
      _updateSubscriptionStatus(info);

      print('RevenueCat configured ✅');
    } catch (e) {
      _isRevenueCatConfigured.value = false; // fall back to test mode
      print('RevenueCat configuration failed: $e');
    }
  }

  void _initializeMockState() {
    // For development/testing when RevenueCat isn't configured
    print('Using mock subscription state for development');
    _isSubscribed.value = false;
    _customerInfo.value = null;
    _offerings.value = null;
  }
  
  void _updateSubscriptionStatus(CustomerInfo info) {
    // Be strict: only your entitlement unlocks PRO
    final active = info.entitlements.active;
    _isSubscribed.value = active.containsKey(_entitlementId);
  }
  
  Future<bool> checkSubscriptionStatus() async {
    if (!_isRevenueCatConfigured.value) {
      return await _checkTestSubscriptionStatus();
    }

    try {
      final info = await Purchases.getCustomerInfo();
      _customerInfo.value = info;
      _updateSubscriptionStatus(info);
      return _isSubscribed.value;
    } catch (e) {
      print('Error checking subscription status: $e');
      // Fall back to test subscription state
      return await _checkTestSubscriptionStatus();
    }
  }

  Future<bool> _checkTestSubscriptionStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final testSubscription = prefs.getBool('test_subscription_active') ?? false;
      _isSubscribed.value = testSubscription;
      return testSubscription;
    } catch (e) {
      return false;
    }
  }
  
  Future<CustomerInfo?> purchasePackage(Package package) async {
    if (!_isRevenueCatConfigured.value) {
      // For testing, simulate successful purchase
      return _simulateSuccessfulPurchase();
    }

    try {
      final purchaseResult = await Purchases.purchasePackage(package);
      final customerInfo = purchaseResult.customerInfo;
      _customerInfo.value = customerInfo;
      _updateSubscriptionStatus(customerInfo);
      return customerInfo;
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      print('Purchase PlatformException: $code');
      throw code; // Let controller map to user messaging
    } catch (e) {
      print('Purchase error: $e');
      rethrow;
    }
  }

  CustomerInfo? _simulateSuccessfulPurchase() {
    print('Simulating successful purchase for testing');
    _isSubscribed.value = true;
    return null; // In real implementation, this would be a CustomerInfo object
  }

  // Open subscription management
  void openManageSubscriptions() {
    final uri = Platform.isIOS
        ? Uri.parse('itms-apps://apps.apple.com/account/subscriptions')
        : Uri.parse('https://play.google.com/store/account/subscriptions');
    launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  void onClose() {
    // Optional: remove listener if you add your own wrapper
    super.onClose();
  }
  
  Future<CustomerInfo?> restorePurchases() async {
    if (!_isRevenueCatConfigured.value) {
      // For testing, check if there's a test subscription
      await _checkTestSubscriptionStatus();
      return null;
    }

    try {
      final customerInfo = await Purchases.restorePurchases();
      _customerInfo.value = customerInfo;
      _updateSubscriptionStatus(customerInfo);
      return customerInfo;
    } catch (e) {
      print('Error restoring purchases: $e');
      rethrow;
    }
  }
  
  Future<void> refreshOfferings() async {
    if (!_isRevenueCatConfigured.value) {
      // Skip refreshing offerings in test mode
      return;
    }

    try {
      final offerings = await Purchases.getOfferings();
      _offerings.value = offerings;
    } catch (e) {
      print('Error refreshing offerings: $e');
    }
  }
  
  // Helper methods for specific packages
  Package? get annualPackage => _offerings.value?.current?.annual;
  Package? get monthlyPackage => _offerings.value?.current?.monthly;
  
  // Check if annual package has trial/intro pricing
  bool get annualHasTrial {
    final annual = annualPackage;
    return annual?.storeProduct.introductoryPrice != null;
  }
  
  // Get formatted price for a package
  String getFormattedPrice(Package? package) {
    if (package == null) return '';
    return '${package.storeProduct.priceString}';
  }
  
  // Get price per month for annual package (for comparison)
  String getMonthlyEquivalentPrice(Package? package) {
    if (package == null) return '';
    final price = package.storeProduct.price;
    final monthlyPrice = price / 12;
    return '${monthlyPrice.toStringAsFixed(2)} ${package.storeProduct.currencyCode}';
  }
}

// Helper class for entitlement checks throughout the app
class Entitlements {
  static Future<bool> isPro() async {
    try {
      final service = SubscriptionService.to;
      return await service.checkSubscriptionStatus();
    } catch (e) {
      // If service not initialized, return false (no subscription)
      print('Error checking entitlements: $e');
      return false;
    }
  }
  
  static Future<void> requirePro(VoidCallback allowed, {VoidCallback? onPaywallNeeded}) async {
    if (await isPro()) {
      allowed();
    } else {
      if (onPaywallNeeded != null) {
        onPaywallNeeded();
      } else {
        Get.toNamed('/paywall');
      }
    }
  }
}
