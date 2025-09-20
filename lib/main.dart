import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:purchases_flutter/purchases_flutter.dart';
import 'dart:io';

import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'modules/children/services/children_store.dart';
import 'modules/events/services/events_store.dart';
import 'modules/events/services/repository_binding.dart';
import 'modules/statistics/services/timezone_clock.dart';
import 'data/services/spurt_content_service.dart';
import 'modules/paywall/services/subscription_service.dart';
import 'modules/paywall/config/paywall_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize timezone data
  tz.initializeTimeZones();

  // Configure RevenueCat
  await _configureRevenueCat();

  // Initialize core services
  Get.put(TimezoneClock.local(), permanent: true);
  Get.put(ChildrenStore());
  Get.put(EventsStore());

  // Initialize content services
  Get.put(SpurtContentService(), permanent: true);

  // Initialize subscription service
  Get.put(SubscriptionService(), permanent: true);

  // Initialize repository system
  RepositoryInitializer.initialize();

  runApp(const BabeFeedingTrackApp());
}

Future<void> _configureRevenueCat() async {
  try {
    // Use configuration from PaywallConfig
    final String apiKey = Platform.isIOS ? PaywallConfig.iosApiKey : PaywallConfig.androidApiKey;

    // Validate configuration
    PaywallConfig.validateConfig();

    // Only configure if we have valid API keys and not in test mode
    if (apiKey.isNotEmpty &&
        !apiKey.contains('test_key_here') &&
        !PaywallConfig.shouldSkipPaywall) {
      await Purchases.configure(
        PurchasesConfiguration(apiKey)
          ..appUserID = null, // Use anonymous user ID
      );
      print('RevenueCat configured successfully');
    } else {
      print('RevenueCat configuration skipped - using test mode');
    }
  } catch (e) {
    print('RevenueCat configuration failed: $e');
    print('Continuing without RevenueCat - app will work in test mode');
  }
}

class BabeFeedingTrackApp extends StatelessWidget {
  const BabeFeedingTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Always start with splash screen for beautiful app launch
    return GetMaterialApp(
      title: 'Babe Feeding Track',
      theme: AppTheme.darkTheme,
      initialRoute: Routes.splash,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}


