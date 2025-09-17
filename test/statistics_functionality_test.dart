import 'package:flutter_test/flutter_test.dart';
import '../lib/modules/events/models/event_record.dart';
import '../lib/modules/stats/models/stats_models.dart';

void main() {
  group('Statistics Functionality Tests', () {
    test('DateTimeUtils.bucketKey generates correct keys for different buckets', () {
      final testDate = DateTime(2024, 3, 15, 14, 30);
      
      // Test day bucket
      final dayKey = DateTimeUtils.bucketKey(testDate, Bucket.day);
      expect(dayKey, equals('2024-03-15'));
      
      // Test month bucket
      final monthKey = DateTimeUtils.bucketKey(testDate, Bucket.month);
      expect(monthKey, equals('2024-03'));
      
      // Test year bucket
      final yearKey = DateTimeUtils.bucketKey(testDate, Bucket.year);
      expect(yearKey, equals('2024'));
    });

    test('StatsRange factory constructors create correct date ranges', () {
      final now = DateTime.now();
      
      // Test last week
      final lastWeek = StatsRange.lastWeek();
      expect(lastWeek.bucket, equals(Bucket.day));
      expect(lastWeek.start.isBefore(now), isTrue);
      expect(lastWeek.end.isAfter(lastWeek.start), isTrue);
      
      // Test last month
      final lastMonth = StatsRange.lastMonth();
      expect(lastMonth.bucket, equals(Bucket.day));
      expect(lastMonth.start.isBefore(now), isTrue);
      
      // Test current month
      final currentMonth = StatsRange.currentMonth();
      expect(currentMonth.bucket, equals(Bucket.day));
      expect(currentMonth.start.day, equals(1));
    });

    test('Point and Bar models store data correctly', () {
      final testDate = DateTime(2024, 3, 15);
      final point = Point(testDate, 5.2);
      
      expect(point.x, equals(testDate));
      expect(point.y, equals(5.2));
      
      final bar = Bar('2024-03-15', 120.0);
      expect(bar.x, equals('2024-03-15'));
      expect(bar.y, equals(120.0));
    });

    test('UnitConverter converts weights correctly', () {
      // Test grams to pounds
      final pounds = UnitConverter.gramsToLbs(5200);
      expect(pounds, closeTo(11.46, 0.01));
      
      // Test pounds to grams
      final grams = UnitConverter.lbsToGrams(11.46);
      expect(grams, closeTo(5200, 10));
      
      // Test weight formatting
      final metricFormat = UnitConverter.formatWeight(5200, useMetric: true);
      expect(metricFormat, equals('5200g'));
      
      final imperialFormat = UnitConverter.formatWeight(5200, useMetric: false);
      expect(imperialFormat.contains('lb'), isTrue);
      expect(imperialFormat.contains('oz'), isTrue);
    });

    test('UnitConverter converts heights correctly', () {
      // Test cm to inches
      final inches = UnitConverter.cmToInches(52.5);
      expect(inches, closeTo(20.67, 0.01));
      
      // Test inches to cm
      final cm = UnitConverter.inchesToCm(20.67);
      expect(cm, closeTo(52.5, 0.1));
      
      // Test height formatting
      final metricFormat = UnitConverter.formatHeight(52.5, useMetric: true);
      expect(metricFormat, equals('52.5cm'));
      
      final imperialFormat = UnitConverter.formatHeight(52.5, useMetric: false);
      expect(imperialFormat.contains('ft'), isTrue);
      expect(imperialFormat.contains('in'), isTrue);
    });

    test('DateTimeUtils time calculations work correctly', () {
      final testTime = DateTime(2024, 3, 15, 14, 30); // 2:30 PM
      
      // Test angle from time
      final angle = DateTimeUtils.angleFromTime(testTime);
      expect(angle, equals(217.5)); // (14 * 15) + (30 * 0.25) = 210 + 7.5
      
      // Test duration to angle span
      final duration = const Duration(hours: 2, minutes: 30);
      final angleSpan = DateTimeUtils.angleSpanFromDuration(duration);
      expect(angleSpan, equals(37.5)); // 150 minutes * 0.25
    });

    test('DateTimeUtils sleep time categorization works correctly', () {
      // Test daytime sleep (10 AM to 2 PM)
      final daytimeSleep = DateTimeUtils.isDaytimeSleep(
        DateTime(2024, 3, 15, 10, 0),
        DateTime(2024, 3, 15, 14, 0),
      );
      expect(daytimeSleep, isTrue);
      
      // Test night sleep (9 PM to 6 AM)
      final nightSleep = DateTimeUtils.isNightSleep(
        DateTime(2024, 3, 15, 21, 0),
        DateTime(2024, 3, 16, 6, 0),
      );
      expect(nightSleep, isTrue);
      
      // Test early morning sleep (3 AM start)
      final earlyMorningSleep = DateTimeUtils.isNightSleep(
        DateTime(2024, 3, 15, 3, 0),
        DateTime(2024, 3, 15, 7, 0),
      );
      expect(earlyMorningSleep, isTrue);
    });

    test('EventRecord model stores data correctly', () {
      final testEvent = EventRecord(
        id: 'test-event-123',
        childId: 'child-456',
        type: EventType.weight,
        startAt: DateTime(2024, 3, 15, 10, 0),
        endAt: DateTime(2024, 3, 15, 10, 5),
        data: {'valueKg': 5.2, 'notes': 'Test measurement'},
        comment: 'Test comment',
      );
      
      expect(testEvent.id, equals('test-event-123'));
      expect(testEvent.childId, equals('child-456'));
      expect(testEvent.type, equals(EventType.weight));
      expect(testEvent.data['valueKg'], equals(5.2));
      expect(testEvent.data['notes'], equals('Test measurement'));
      expect(testEvent.comment, equals('Test comment'));
      expect(testEvent.endAt, isNotNull);
    });

    test('EventRecord JSON serialization works correctly', () {
      final testEvent = EventRecord(
        id: 'test-event-123',
        childId: 'child-456',
        type: EventType.feedingBottle,
        startAt: DateTime(2024, 3, 15, 10, 0),
        data: {'volume': 120, 'temperature': 'warm'},
      );
      
      final json = testEvent.toJson();
      expect(json['id'], equals('test-event-123'));
      expect(json['childId'], equals('child-456'));
      expect(json['type'], equals('feedingBottle'));
      expect(json['data']['volume'], equals(120));
      expect(json['data']['temperature'], equals('warm'));
      
      final recreatedEvent = EventRecord.fromJson(json);
      expect(recreatedEvent, isNotNull);
      expect(recreatedEvent!.id, equals(testEvent.id));
      expect(recreatedEvent.childId, equals(testEvent.childId));
      expect(recreatedEvent.type, equals(testEvent.type));
      expect(recreatedEvent.data['volume'], equals(120));
    });

    test('Event filtering by type works correctly', () {
      final events = [
        EventRecord(
          id: 'weight-1',
          childId: 'child-1',
          type: EventType.weight,
          startAt: DateTime.now(),
          data: {'valueKg': 5.2},
        ),
        EventRecord(
          id: 'bottle-1',
          childId: 'child-1',
          type: EventType.feedingBottle,
          startAt: DateTime.now(),
          data: {'volume': 120},
        ),
        EventRecord(
          id: 'weight-2',
          childId: 'child-1',
          type: EventType.weight,
          startAt: DateTime.now(),
          data: {'valueKg': 5.4},
        ),
      ];
      
      final weightEvents = events.where((e) => e.type == EventType.weight).toList();
      expect(weightEvents.length, equals(2));
      expect(weightEvents[0].id, equals('weight-1'));
      expect(weightEvents[1].id, equals('weight-2'));
      
      final bottleEvents = events.where((e) => e.type == EventType.feedingBottle).toList();
      expect(bottleEvents.length, equals(1));
      expect(bottleEvents[0].id, equals('bottle-1'));
    });

    test('Event filtering by child works correctly', () {
      final events = [
        EventRecord(
          id: 'event-1',
          childId: 'child-1',
          type: EventType.weight,
          startAt: DateTime.now(),
          data: {'valueKg': 5.2},
        ),
        EventRecord(
          id: 'event-2',
          childId: 'child-2',
          type: EventType.weight,
          startAt: DateTime.now(),
          data: {'valueKg': 4.8},
        ),
        EventRecord(
          id: 'event-3',
          childId: 'child-1',
          type: EventType.feedingBottle,
          startAt: DateTime.now(),
          data: {'volume': 120},
        ),
      ];
      
      final child1Events = events.where((e) => e.childId == 'child-1').toList();
      expect(child1Events.length, equals(2));
      expect(child1Events[0].id, equals('event-1'));
      expect(child1Events[1].id, equals('event-3'));
      
      final child2Events = events.where((e) => e.childId == 'child-2').toList();
      expect(child2Events.length, equals(1));
      expect(child2Events[0].id, equals('event-2'));
    });

    test('Event filtering by date range works correctly', () {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final threeDaysAgo = now.subtract(const Duration(days: 3));
      
      final events = [
        EventRecord(
          id: 'event-1',
          childId: 'child-1',
          type: EventType.weight,
          startAt: threeDaysAgo,
          data: {'valueKg': 5.0},
        ),
        EventRecord(
          id: 'event-2',
          childId: 'child-1',
          type: EventType.weight,
          startAt: yesterday,
          data: {'valueKg': 5.2},
        ),
        EventRecord(
          id: 'event-3',
          childId: 'child-1',
          type: EventType.weight,
          startAt: now,
          data: {'valueKg': 5.4},
        ),
      ];
      
      // Filter events from last 2 days
      final rangeStart = now.subtract(const Duration(days: 2));
      final recentEvents = events
          .where((e) => e.startAt.isAfter(rangeStart))
          .toList();
      
      expect(recentEvents.length, equals(2));
      expect(recentEvents[0].id, equals('event-2'));
      expect(recentEvents[1].id, equals('event-3'));
    });
  });
}
