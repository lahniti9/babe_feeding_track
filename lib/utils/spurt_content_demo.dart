import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../data/services/spurt_content_service.dart';

/// Utility class to demonstrate the new spurt content system
class SpurtContentDemo {
  static void demonstrateContentSystem() {
    if (!kDebugMode) return;
    
    final contentService = Get.find<SpurtContentService>();
    
    if (!contentService.isLoaded) {
      print('SpurtContentDemo: Content not loaded yet');
      return;
    }
    
    print('\n=== Spurt Content System Demo ===');
    
    // Show content statistics
    final stats = contentService.getContentStats();
    print('Content Statistics:');
    print('  Schema Version: ${stats['schema_version']}');
    print('  Total Weeks: ${stats['total_weeks']}');
    print('  Leap Weeks: ${stats['leap_weeks']}');
    print('  Fussy Weeks: ${stats['fussy_weeks']}');
    print('  Available Weeks: ${stats['available_weeks']}');
    
    // Demonstrate content access
    print('\nContent Examples:');
    
    // Show a leap week
    final leapWeek = contentService.getWeekContent(5);
    if (leapWeek != null) {
      print('\nWeek 5 (${leapWeek.type.value}): ${leapWeek.title}');
      print('  Behavior: ${leapWeek.behaviorText}');
      print('  Skills: ${leapWeek.skillsText}');
      print('  Feeding Tips: ${leapWeek.feedingTips}');
      print('  Sleep Tips: ${leapWeek.sleepTips}');
      print('  Communication Tips: ${leapWeek.communicationTips}');
    }
    
    // Show a fussy week
    final fussyWeek = contentService.getWeekContent(4);
    if (fussyWeek != null) {
      print('\nWeek 4 (${fussyWeek.type.value}): ${fussyWeek.title}');
      print('  Behavior: ${fussyWeek.behaviorText}');
      print('  Tips: ${fussyWeek.tips.join(', ')}');
    }
    
    // Demonstrate legacy compatibility
    print('\nLegacy Compatibility:');
    final legacyContent = contentService.getLegacyContent('wk5');
    if (legacyContent != null) {
      print('  Legacy format for week 5:');
      print('    Title Line: ${legacyContent.titleLine}');
      print('    Behavior: ${legacyContent.behavior}');
      print('    Skill: ${legacyContent.skill}');
      print('    Feeding: ${legacyContent.feeding}');
      print('    Sleep: ${legacyContent.sleep}');
      print('    Communication: ${legacyContent.communication}');
    }
    
    // Show episodes for backward compatibility
    final episodes = contentService.episodes;
    print('\nEpisodes (${episodes.length} total):');
    for (final episode in episodes.take(5)) {
      print('  Week ${episode.week}: ${episode.type.name} (${episode.contentKey})');
    }
    
    print('\n=== Demo Complete ===\n');
  }
  
  /// Demonstrate performance characteristics
  static void demonstratePerformance() {
    if (!kDebugMode) return;
    
    final contentService = Get.find<SpurtContentService>();
    
    if (!contentService.isLoaded) {
      print('SpurtContentDemo: Content not loaded for performance test');
      return;
    }
    
    print('\n=== Performance Demo ===');
    
    final stopwatch = Stopwatch()..start();
    
    // Test rapid content access
    for (int i = 0; i < 1000; i++) {
      contentService.getWeekContent(5);
      contentService.getLegacyContent('wk5');
      contentService.hasWeekContent(5);
    }
    
    stopwatch.stop();
    print('1000 content access operations: ${stopwatch.elapsedMicroseconds}μs');
    print('Average per operation: ${stopwatch.elapsedMicroseconds / 1000}μs');
    
    // Test episode generation
    stopwatch.reset();
    stopwatch.start();
    
    for (int i = 0; i < 100; i++) {
      final episodes = contentService.episodes;
      episodes.length; // Force evaluation
    }
    
    stopwatch.stop();
    print('100 episode list generations: ${stopwatch.elapsedMicroseconds}μs');
    print('Average per generation: ${stopwatch.elapsedMicroseconds / 100}μs');
    
    print('=== Performance Demo Complete ===\n');
  }
  
  /// Show content editing capabilities (for development)
  static void showContentEditingInfo() {
    if (!kDebugMode) return;
    
    print('\n=== Content Editing Info ===');
    print('To edit spurt/leap content:');
    print('1. Edit assets/data/spurt_content.json');
    print('2. Hot restart the app (R in flutter run)');
    print('3. Content will be reloaded automatically');
    print('');
    print('JSON Structure:');
    print('- schema_version: Version for compatibility');
    print('- last_updated: Update timestamp');
    print('- content.weeks: Week-indexed content');
    print('  - type: "leap" or "fussy"');
    print('  - title: Display title');
    print('  - behavior: Array of behavior descriptions');
    print('  - skills: Array of skill developments');
    print('  - tips: Array of tips (auto-categorized by keywords)');
    print('');
    print('Benefits:');
    print('✓ No Dart recompilation needed');
    print('✓ Single source of truth');
    print('✓ Background loading prevents UI jank');
    print('✓ In-memory cache for fast access');
    print('✓ Backward compatibility maintained');
    print('✓ Type-safe access');
    print('✓ Schema versioning for future changes');
    print('=== Content Editing Info Complete ===\n');
  }
}
