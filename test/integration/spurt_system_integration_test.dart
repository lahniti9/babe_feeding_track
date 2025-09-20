import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:babe_feeding_track/data/services/spurt_content_service.dart';
import 'package:babe_feeding_track/modules/spurt/controllers/spurt_controller.dart';
import 'package:babe_feeding_track/modules/children/services/children_store.dart';
import 'package:babe_feeding_track/modules/spurt/models/spurt_models.dart';

void main() {
  group('Spurt System Integration Tests', () {
    late SpurtContentService contentService;
    late SpurtController spurtController;
    late ChildrenStore childrenStore;

    setUpAll(() async {
      // Initialize GetX
      Get.testMode = true;
      
      // Initialize services
      contentService = SpurtContentService();
      childrenStore = ChildrenStore();
      
      // Put services in GetX
      Get.put<SpurtContentService>(contentService, permanent: true);
      Get.put<ChildrenStore>(childrenStore, permanent: true);
      
      // Wait for content to load
      await contentService.ensureContentLoaded();
      
      // Initialize controller
      spurtController = SpurtController();
    });

    tearDownAll(() {
      Get.reset();
    });

    test('content service should load successfully', () {
      expect(contentService.isLoaded, true);
      expect(contentService.contentData, isNotNull);
      expect(contentService.availableWeeks.isNotEmpty, true);
    });

    test('should have expected content structure', () {
      final stats = contentService.getContentStats();
      
      expect(stats['loaded'], true);
      expect(stats['schema_version'], '1.0.0');
      expect(stats['total_weeks'], greaterThan(20)); // Should have many weeks
      expect(stats['leap_weeks'], greaterThan(5)); // Should have multiple leaps
      expect(stats['fussy_weeks'], greaterThan(5)); // Should have multiple fussy phases
    });

    test('should provide backward compatibility', () {
      // Test legacy content access
      final legacyContent = contentService.getLegacyContent('wk5');
      expect(legacyContent, isNotNull);
      expect(legacyContent!.titleLine, contains('growth leap'));
      expect(legacyContent.behavior, isNotEmpty);
      
      // Test episode generation
      final episodes = contentService.episodes;
      expect(episodes, isNotEmpty);
      expect(episodes.first, isA<SpurtEpisode>());
      
      // Test SpurtWeek compatibility
      final spurtWeek = contentService.getSpurtWeek(5);
      expect(spurtWeek, isNotNull);
      expect(spurtWeek!.type, isA<SpurtType>());
    });

    test('spurt controller should integrate with content service', () {
      // Test that controller can access episodes
      final episodes = spurtController.episodes;
      expect(episodes, isNotEmpty);
      
      // Test content access through controller
      final content = spurtController.getContent('wk5');
      expect(content, isNotNull);
      
      // Test SpurtWeek access
      final spurtWeek = spurtController.getSpurtWeek(5);
      expect(spurtWeek, isNotNull);
    });

    test('should handle missing content gracefully', () {
      // Test non-existent week
      expect(contentService.getWeekContent(999), isNull);
      expect(contentService.hasWeekContent(999), false);
      expect(contentService.getLegacyContent('wk999'), isNull);
      expect(spurtController.getSpurtWeek(999), isNull);
    });

    test('should provide fast content access', () {
      final stopwatch = Stopwatch()..start();
      
      // Perform many content accesses
      for (int i = 0; i < 1000; i++) {
        contentService.getWeekContent(5);
        contentService.hasWeekContent(5);
        contentService.getLegacyContent('wk5');
      }
      
      stopwatch.stop();
      
      // Should be very fast (under 10ms for 1000 operations)
      expect(stopwatch.elapsedMilliseconds, lessThan(10));
    });

    test('should maintain data consistency', () {
      final availableWeeks = contentService.availableWeeks;
      
      for (final week in availableWeeks) {
        // Each available week should have content
        expect(contentService.hasWeekContent(week), true);
        
        final weekContent = contentService.getWeekContent(week);
        expect(weekContent, isNotNull);
        
        // Legacy compatibility should work
        final legacyContent = contentService.getLegacyContent('wk$week');
        expect(legacyContent, isNotNull);
        
        // SpurtWeek compatibility should work
        final spurtWeek = contentService.getSpurtWeek(week);
        expect(spurtWeek, isNotNull);
        
        // Controller access should work
        final controllerContent = spurtController.getContent('wk$week');
        expect(controllerContent, isNotNull);
      }
    });

    test('should categorize content correctly', () {
      final leapWeeks = contentService.leapWeeks;
      final fussyWeeks = contentService.fussyWeeks;
      
      expect(leapWeeks, isNotEmpty);
      expect(fussyWeeks, isNotEmpty);
      
      // Check that categorization is correct
      for (final week in leapWeeks) {
        final content = contentService.getWeekContent(week)!;
        expect(content.type.value, 'leap');
      }
      
      for (final week in fussyWeeks) {
        final content = contentService.getWeekContent(week)!;
        expect(content.type.value, 'fussy');
      }
    });

    test('should handle content tips categorization', () {
      // Find a week with tips
      final weekWithTips = contentService.availableWeeks.firstWhere((week) {
        final content = contentService.getWeekContent(week)!;
        return content.tips.isNotEmpty;
      });
      
      final content = contentService.getWeekContent(weekWithTips)!;
      
      // Tips should be categorized correctly
      final feedingTips = content.feedingTips;
      final sleepTips = content.sleepTips;
      final communicationTips = content.communicationTips;
      
      // At least one category should have content
      expect(feedingTips.isNotEmpty || sleepTips.isNotEmpty || communicationTips.isNotEmpty, true);
      
      // If feeding tips exist, they should contain "feeding"
      if (feedingTips.isNotEmpty) {
        expect(feedingTips.toLowerCase(), contains('feeding'));
      }
      
      // If sleep tips exist, they should contain "sleep"
      if (sleepTips.isNotEmpty) {
        expect(sleepTips.toLowerCase(), contains('sleep'));
      }
      
      // If communication tips exist, they should contain "communication"
      if (communicationTips.isNotEmpty) {
        expect(communicationTips.toLowerCase(), contains('communication'));
      }
    });
  });
}
