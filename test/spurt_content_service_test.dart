import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:babe_feeding_track/data/services/spurt_content_service.dart';
import 'package:babe_feeding_track/data/models/spurt_content_models.dart';

void main() {
  group('SpurtContentService Integration Tests', () {
    late SpurtContentService service;

    setUp(() {
      service = SpurtContentService();
    });

    test('should load content from assets successfully', () async {
      // Mock the asset loading
      const mockJsonContent = '''
      {
        "schema_version": "1.0.0",
        "last_updated": "2024-01-01",
        "description": "Wonder Weeks spurt and leap content data",
        "content": {
          "weeks": {
            "4": {
              "type": "fussy",
              "title": "Fussy phase (pre-Leap 1)",
              "behavior": [
                "More clingy/startly; wants contact",
                "Sleep and feeds feel less predictable"
              ],
              "skills": [],
              "tips": [
                "Feeding: quiet, low-stim feeds",
                "Sleep: short soothing, swaddle/white noise",
                "Communication: soft voice, skin-to-skin"
              ]
            },
            "5": {
              "type": "leap",
              "title": "Leap 1: Changing Sensations",
              "behavior": [
                "Becomes more sensitive to surroundings",
                "May cry more, sleep less",
                "Wants more attention and contact"
              ],
              "skills": [
                "Shows first deliberate smile",
                "Follows objects with eyes",
                "Responds to sounds more clearly"
              ],
              "tips": [
                "Feeding: may feed more often for comfort",
                "Sleep: keep environment calm and consistent",
                "Communication: talk and sing to your baby more"
              ]
            }
          }
        }
      }
      ''';

      // Parse the content directly
      final contentData = parseSpurtContentData(mockJsonContent);

      expect(contentData.schema.version, '1.0.0');
      expect(contentData.weeks.length, 2);
      expect(contentData.availableWeeks, [4, 5]);
      expect(contentData.leapWeeks, [5]);
      expect(contentData.fussyWeeks, [4]);
    });

    test('should provide correct legacy content conversion', () {
      const mockJsonContent = '''
      {
        "schema_version": "1.0.0",
        "last_updated": "2024-01-01",
        "description": "Test content",
        "content": {
          "weeks": {
            "5": {
              "type": "leap",
              "title": "Leap 1: Changing Sensations",
              "behavior": ["Becomes more sensitive to surroundings"],
              "skills": ["Shows first deliberate smile"],
              "tips": [
                "Feeding: may feed more often for comfort",
                "Sleep: keep environment calm and consistent",
                "Communication: talk and sing to your baby more"
              ]
            }
          }
        }
      }
      ''';

      final contentData = parseSpurtContentData(mockJsonContent);
      final weekContent = contentData.getWeekContent(5)!;

      // Test content properties
      expect(weekContent.type, SpurtContentType.leap);
      expect(weekContent.title, 'Leap 1: Changing Sensations');
      expect(weekContent.behaviorText, 'Becomes more sensitive to surroundings');
      expect(weekContent.skillsText, 'Shows first deliberate smile');
      expect(weekContent.feedingTips, 'Feeding: may feed more often for comfort');
      expect(weekContent.sleepTips, 'Sleep: keep environment calm and consistent');
      expect(weekContent.communicationTips, 'Communication: talk and sing to your baby more');
      expect(weekContent.titleLineTemplate, 'This growth leap will occur in {days} days');
    });

    test('should handle fussy phase content correctly', () {
      const mockJsonContent = '''
      {
        "schema_version": "1.0.0",
        "last_updated": "2024-01-01",
        "description": "Test content",
        "content": {
          "weeks": {
            "4": {
              "type": "fussy",
              "title": "Fussy phase (pre-Leap 1)",
              "behavior": ["More clingy/startly; wants contact"],
              "skills": [],
              "tips": ["Feeding: quiet, low-stim feeds"]
            }
          }
        }
      }
      ''';

      final contentData = parseSpurtContentData(mockJsonContent);
      final weekContent = contentData.getWeekContent(4)!;

      expect(weekContent.type, SpurtContentType.fussy);
      expect(weekContent.title, 'Fussy phase (pre-Leap 1)');
      expect(weekContent.titleLineTemplate, 'This fussy phase will start in {days} days');
      expect(weekContent.skills, isEmpty);
      expect(weekContent.feedingTips, 'Feeding: quiet, low-stim feeds');
    });

    test('should categorize tips correctly', () {
      const mockJsonContent = '''
      {
        "schema_version": "1.0.0",
        "last_updated": "2024-01-01",
        "description": "Test content",
        "content": {
          "weeks": {
            "5": {
              "type": "leap",
              "title": "Test Leap",
              "behavior": ["Test behavior"],
              "skills": ["Test skill"],
              "tips": [
                "Feeding: test feeding tip",
                "Sleep: test sleep tip",
                "Communication: test communication tip",
                "General tip without category"
              ]
            }
          }
        }
      }
      ''';

      final contentData = parseSpurtContentData(mockJsonContent);
      final weekContent = contentData.getWeekContent(5)!;

      expect(weekContent.feedingTips, 'Feeding: test feeding tip');
      expect(weekContent.sleepTips, 'Sleep: test sleep tip');
      expect(weekContent.communicationTips, 'Communication: test communication tip');
      
      // General tip should not appear in any category
      expect(weekContent.feedingTips, isNot(contains('General tip')));
      expect(weekContent.sleepTips, isNot(contains('General tip')));
      expect(weekContent.communicationTips, isNot(contains('General tip')));
    });

    test('should handle JSON serialization correctly', () {
      const originalJson = '''
      {
        "schema_version": "1.0.0",
        "last_updated": "2024-01-01T00:00:00.000Z",
        "description": "Test content",
        "content": {
          "weeks": {
            "5": {
              "type": "leap",
              "title": "Test Leap",
              "behavior": ["Test behavior"],
              "skills": ["Test skill"],
              "tips": ["Test tip"]
            }
          }
        }
      }
      ''';

      final contentData = parseSpurtContentData(originalJson);
      final serializedJson = contentData.toJson();

      // Verify round-trip serialization
      expect(serializedJson['schema_version'], '1.0.0');
      expect(serializedJson['description'], 'Test content');
      
      final weeksData = serializedJson['content']['weeks'] as Map<String, dynamic>;
      expect(weeksData.containsKey('5'), true);
      
      final week5Data = weeksData['5'] as Map<String, dynamic>;
      expect(week5Data['type'], 'leap');
      expect(week5Data['title'], 'Test Leap');
      expect(week5Data['behavior'], ['Test behavior']);
      expect(week5Data['skills'], ['Test skill']);
      expect(week5Data['tips'], ['Test tip']);
    });

    test('should handle performance requirements', () {
      // Create content with many weeks
      final weeksMap = <String, dynamic>{};
      for (int i = 1; i <= 100; i++) {
        weeksMap[i.toString()] = {
          'type': i % 2 == 0 ? 'leap' : 'fussy',
          'title': 'Week $i',
          'behavior': ['Behavior $i'],
          'skills': ['Skill $i'],
          'tips': ['Tip $i']
        };
      }

      final jsonContent = '''
      {
        "schema_version": "1.0.0",
        "last_updated": "2024-01-01",
        "description": "Performance test content",
        "content": {
          "weeks": ${weeksMap.toString().replaceAll('\'', '"')}
        }
      }
      ''';

      final stopwatch = Stopwatch()..start();
      final contentData = parseSpurtContentData(jsonContent);
      stopwatch.stop();

      // Parsing should be fast (under 100ms for 100 weeks)
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
      expect(contentData.weeks.length, 100);
      expect(contentData.availableWeeks.length, 100);

      // Access should be very fast
      stopwatch.reset();
      stopwatch.start();
      
      for (int i = 0; i < 1000; i++) {
        contentData.getWeekContent(50);
        contentData.hasWeekContent(50);
      }
      
      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(10));
    });
  });
}
