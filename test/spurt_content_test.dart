import 'package:flutter_test/flutter_test.dart';
import 'package:babe_feeding_track/data/models/spurt_content_models.dart';

void main() {
  group('SpurtContentService Tests', () {

    test('should parse JSON content correctly', () async {
      const jsonString = '''
      {
        "schema_version": "1.0.0",
        "last_updated": "2024-01-01",
        "description": "Test content",
        "content": {
          "weeks": {
            "5": {
              "type": "leap",
              "title": "Leap 1: Changing Sensations",
              "behavior": ["Test behavior"],
              "skills": ["Test skill"],
              "tips": ["Feeding: test tip", "Sleep: test tip"]
            }
          }
        }
      }
      ''';

      final contentData = parseSpurtContentData(jsonString);

      expect(contentData.schema.version, '1.0.0');
      expect(contentData.weeks.length, 1);
      expect(contentData.weeks[5]?.type, SpurtContentType.leap);
      expect(contentData.weeks[5]?.title, 'Leap 1: Changing Sensations');
      expect(contentData.weeks[5]?.behavior, ['Test behavior']);
      expect(contentData.weeks[5]?.skills, ['Test skill']);
      expect(contentData.weeks[5]?.feedingTips, 'Feeding: test tip');
      expect(contentData.weeks[5]?.sleepTips, 'Sleep: test tip');
    });

    test('should handle legacy content conversion', () async {
      const jsonString = '''
      {
        "schema_version": "1.0.0",
        "last_updated": "2024-01-01",
        "description": "Test content",
        "content": {
          "weeks": {
            "5": {
              "type": "leap",
              "title": "Leap 1: Changing Sensations",
              "behavior": ["Becomes more sensitive"],
              "skills": ["Shows first smile"],
              "tips": ["Feeding: may feed more often", "Sleep: keep environment calm", "Communication: talk more"]
            }
          }
        }
      }
      ''';

      final contentData = parseSpurtContentData(jsonString);

      // Test legacy content conversion directly from the model
      final weekContent = contentData.getWeekContent(5)!;

      expect(weekContent.titleLineTemplate, 'This growth leap will occur in {days} days');
      expect(weekContent.behaviorText, 'Becomes more sensitive');
      expect(weekContent.skillsText, 'Shows first smile');
      expect(weekContent.feedingTips, 'Feeding: may feed more often');
      expect(weekContent.sleepTips, 'Sleep: keep environment calm');
      expect(weekContent.communicationTips, 'Communication: talk more');
    });

    test('should return correct week lists', () async {
      const jsonString = '''
      {
        "schema_version": "1.0.0",
        "last_updated": "2024-01-01",
        "description": "Test content",
        "content": {
          "weeks": {
            "4": {
              "type": "fussy",
              "title": "Fussy phase",
              "behavior": ["More clingy"],
              "skills": [],
              "tips": ["Be patient"]
            },
            "5": {
              "type": "leap",
              "title": "Leap 1",
              "behavior": ["More sensitive"],
              "skills": ["First smile"],
              "tips": ["Encourage development"]
            },
            "8": {
              "type": "leap",
              "title": "Leap 2",
              "behavior": ["Notices patterns"],
              "skills": ["Recognizes faces"],
              "tips": ["Point out patterns"]
            }
          }
        }
      }
      ''';

      final contentData = parseSpurtContentData(jsonString);

      expect(contentData.availableWeeks, [4, 5, 8]);
      expect(contentData.leapWeeks, [5, 8]);
      expect(contentData.fussyWeeks, [4]);
      expect(contentData.hasWeekContent(5), true);
      expect(contentData.hasWeekContent(6), false);
    });

    test('should handle content type conversion', () {
      expect(SpurtContentType.fromString('leap'), SpurtContentType.leap);
      expect(SpurtContentType.fromString('fussy'), SpurtContentType.fussy);
      expect(SpurtContentType.fromString('invalid'), SpurtContentType.fussy); // fallback
    });
  });
}


