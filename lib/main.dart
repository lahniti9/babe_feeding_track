import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'modules/children/services/children_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize GetStorage
  await GetStorage.init();
  // Initialize ChildrenStore
  Get.put(ChildrenStore());
  runApp(const BabeFeedingTrackApp());
}

class BabeFeedingTrackApp extends StatelessWidget {
  const BabeFeedingTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if onboarding is completed
    final storage = GetStorage();
    final isOnboardingCompleted = storage.read('onboarding_completed') ?? false;
    final initialRoute = isOnboardingCompleted ? Routes.tabs : Routes.splash;

    return GetMaterialApp(
      title: 'Babe Feeding Track',
      theme: AppTheme.darkTheme,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}


