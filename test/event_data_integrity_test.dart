import 'package:flutter_test/flutter_test.dart';
import 'package:babe_feeding_track/modules/children/models/child_profile.dart';
import 'package:babe_feeding_track/modules/events/models/event_record.dart';
import 'package:babe_feeding_track/modules/events/models/sleep_event.dart';

void main() {
  group('Event Data Integrity Logic Tests', () {

    test('should create valid event records with required fields', () {
      final event = EventRecord(
        id: 'test-event-1',
        childId: 'child-1',
        type: EventType.diaper,
        startAt: DateTime.now(),
        data: {'kind': 'wet'},
      );

      expect(event.id, 'test-event-1');
      expect(event.childId, 'child-1');
      expect(event.type, EventType.diaper);
      expect(event.data['kind'], 'wet');
    });

    test('should create valid child profiles', () {
      final child = ChildProfile(
        id: 'child-1',
        name: 'Test Baby',
        gender: BabyGender.girl,
        birthDate: DateTime.now().subtract(const Duration(days: 30)),
      );

      expect(child.id, 'child-1');
      expect(child.name, 'Test Baby');
      expect(child.gender, BabyGender.girl);
      expect(child.ageInDays, 30);
    });

    test('should create valid sleep events', () {
      final now = DateTime.now();
      final sleepEvent = SleepEvent(
        id: 'sleep-1',
        childId: 'child-1',
        fellAsleep: now.subtract(const Duration(hours: 2)),
        wokeUp: now,
        comment: 'Good sleep',
        startTags: ['Content'],
        endTags: ['Woke up naturally'],
        howTags: ['Nursing'],
      );

      expect(sleepEvent.id, 'sleep-1');
      expect(sleepEvent.childId, 'child-1');
      expect(sleepEvent.duration.inHours, 2);
      expect(sleepEvent.comment, 'Good sleep');
      expect(sleepEvent.startTags, ['Content']);
    });

    test('should validate event time ranges correctly', () {
      final now = DateTime.now();

      // Test valid time range
      final validEvent = EventRecord(
        id: 'valid-event',
        childId: 'child-1',
        type: EventType.activity,
        startAt: now.subtract(const Duration(minutes: 20)),
        endAt: now.subtract(const Duration(minutes: 10)),
        data: {'type': 'tummy time'},
      );

      expect(validEvent.startAt.isBefore(validEvent.endAt!), true);

      // Test invalid time range (end before start)
      final invalidEvent = EventRecord(
        id: 'invalid-event',
        childId: 'child-1',
        type: EventType.activity,
        startAt: now,
        endAt: now.subtract(const Duration(minutes: 10)),
        data: {'type': 'tummy time'},
      );

      expect(invalidEvent.startAt.isAfter(invalidEvent.endAt!), true);
    });

    test('should handle event serialization correctly', () {
      final event = EventRecord(
        id: 'test-event',
        childId: 'child-1',
        type: EventType.diaper,
        startAt: DateTime.now(),
        data: {'kind': 'wet', 'color': 'yellow'},
        comment: 'First diaper change',
      );

      // Test JSON serialization
      final json = event.toJson();
      expect(json['id'], 'test-event');
      expect(json['childId'], 'child-1');
      expect(json['type'], 'diaper');
      expect(json['data']['kind'], 'wet');
      expect(json['comment'], 'First diaper change');

      // Test JSON deserialization
      final recreatedEvent = EventRecord.fromJson(json);
      expect(recreatedEvent.id, event.id);
      expect(recreatedEvent.childId, event.childId);
      expect(recreatedEvent.type, event.type);
      expect(recreatedEvent.data['kind'], event.data['kind']);
      expect(recreatedEvent.comment, event.comment);
    });

    test('should handle sleep event serialization correctly', () {
      final sleepEvent = SleepEvent(
        id: 'sleep-1',
        childId: 'child-1',
        fellAsleep: DateTime.now().subtract(const Duration(hours: 2)),
        wokeUp: DateTime.now(),
        comment: 'Good sleep',
        startTags: ['Content'],
        endTags: ['Woke up naturally'],
        howTags: ['Nursing'],
      );

      // Test JSON serialization
      final json = sleepEvent.toJson();
      expect(json['id'], 'sleep-1');
      expect(json['childId'], 'child-1');
      expect(json['comment'], 'Good sleep');
      expect(json['startTags'], ['Content']);

      // Test JSON deserialization
      final recreatedEvent = SleepEvent.fromJson(json);
      expect(recreatedEvent.id, sleepEvent.id);
      expect(recreatedEvent.childId, sleepEvent.childId);
      expect(recreatedEvent.comment, sleepEvent.comment);
      expect(recreatedEvent.startTags, sleepEvent.startTags);
    });

    test('should calculate child age correctly', () {
      final birthDate = DateTime.now().subtract(const Duration(days: 45));
      final child = ChildProfile(
        id: 'child-1',
        name: 'Test Baby',
        gender: BabyGender.girl,
        birthDate: birthDate,
      );

      expect(child.ageInDays, 45);
      expect(child.ageInWeeks, 6); // 45 / 7 = 6
      expect(child.ageInMonths, 1); // Approximately 1 month
    });
  });
}
