class PaywallConfig {
  // RevenueCat API Keys
  static const String iosApiKey = 'appl_test_key_here'; // Replace with your iOS API key
  static const String androidApiKey = 'goog_test_key_here'; // Replace with your Android API key
  
  // Product IDs (must match your App Store Connect and Play Console setup)
  static const String annualProductId = 'baby_tracker_annual';
  static const String monthlyProductId = 'baby_tracker_monthly';
  
  // Offering configuration
  static const String defaultOfferingId = 'default';
  
  // Trial configuration
  static const bool enableTrials = true;
  static const int trialDurationDays = 7; // 7-day free trial
  
  // Discount configuration
  static const bool enableDiscountTimer = true;
  static const int discountDurationMinutes = 5; // 5-minute limited offer
  static const String discountPercentage = '67% OFF'; // Display text
  
  // Feature flags
  static const bool enablePremiumGating = true;
  static const bool enableRestorePurchases = true;
  static const bool enablePaywallAnalytics = false; // Set to true when you have analytics
  
  // Premium features list
  static const List<String> premiumFeatures = [
    'Advanced Statistics',
    'Height & Weight Tracking',
    'Monthly Analytics',
    'Export Data',
    'Unlimited Children',
    'Cloud Sync',
    'Premium Support',
  ];
  
  // Paywall copy
  static const String paywallTitle = 'Unlock Premium Features';
  static const String paywallSubtitle = 'Get unlimited access to advanced tracking, insights, and personalized guidance for your baby\'s development.';
  static const String paywallReview = '"This app has been a lifesaver for tracking my baby\'s feeding and sleep patterns!"';
  

  // Testing configuration
  static const bool enableTestMode = true; // Set to false in production
  static const bool skipPaywallInDebug = false; // Set to true to skip paywall during development
  
  // Subscription entitlement identifier (from RevenueCat)
  static const String premiumEntitlementId = 'premium';
  
  // Paywall presentation settings
  static const bool showPaywallAfterOnboarding = true;
  static const bool showPaywallOnPremiumFeatureAccess = true;
  static const int maxPaywallDismissals = 3; // Show paywall again after 3 dismissals
  
  // Grace period for subscription lapses
  static const int subscriptionGracePeriodDays = 3;
  
  // Pricing display
  static const bool showMonthlyEquivalentForAnnual = true;
  static const bool highlightAnnualPlan = true;
  
  // A/B testing configuration (for future use)
  static const String paywallVariant = 'default'; // 'default', 'variant_a', 'variant_b'
  
  // Helper methods
  static bool get isTestMode => enableTestMode;
  static bool get shouldSkipPaywall => skipPaywallInDebug && isTestMode;
  
  static String get currentApiKey {
    // This will be set properly in main.dart based on platform
    return '';
  }
  
  // Get feature description for paywall
  static String getFeatureDescription(String feature) {
    switch (feature) {
      case 'Height Tracking':
        return 'Track your baby\'s height growth with detailed charts and percentile tracking';
      case 'Weight Tracking':
        return 'Monitor weight gain patterns with visual progress charts';
      case 'Monthly Analytics':
        return 'Get comprehensive monthly reports and insights';
      case 'Export Data':
        return 'Export your data to PDF or CSV for sharing with healthcare providers';
      case 'Advanced Statistics':
        return 'Access detailed analytics and trends for all tracked activities';
      default:
        return 'Unlock this premium feature with a subscription';
    }
  }
  
  // Validate configuration
  static bool validateConfig() {
    if (iosApiKey == 'appl_test_key_here' || androidApiKey == 'goog_test_key_here') {
      print('WARNING: Using test API keys. Please update with your actual RevenueCat keys.');
      return false;
    }
    return true;
  }
}
