import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'modules/children/services/children_store.dart';
import 'modules/events/services/events_store.dart';
import 'modules/events/services/repository_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize timezone data
  tz.initializeTimeZones();

  // Initialize stores
  Get.put(ChildrenStore());
  Get.put(EventsStore());

  // Initialize repository system
  RepositoryInitializer.initialize();

  runApp(const BabeFeedingTrackApp());
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


