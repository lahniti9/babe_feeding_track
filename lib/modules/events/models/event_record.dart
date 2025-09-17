enum EventType {
  sleeping,
  bedtimeRoutine,
  cry,
  feedingBreast,
  feedingBottle,
  food,
  diaper,
  condition,
  medicine,
  temperature,
  doctor,
  bathing,
  walking,
  activity,
  weight,
  height,
  expressing,
  spitUp,
}

class EventRecord {
  final String id;
  final String childId;
  final EventType type;
  final DateTime startAt;
  final DateTime? endAt;
  final Map<String, dynamic> data;
  final String? comment;

  EventRecord({
    required this.id,
    required this.childId,
    required this.type,
    required this.startAt,
    this.endAt,
    this.data = const {},
    this.comment,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'childId': childId,
    'type': type.name,
    'startAt': startAt.toIso8601String(),
    'endAt': endAt?.toIso8601String(),
    'data': data,
    'comment': comment,
  };

  static EventRecord? fromJson(Map<String, dynamic> json) {
    // Handle removed event types gracefully
    EventType? eventType;
    try {
      eventType = EventType.values.byName(json['type']);
    } catch (e) {
      // Skip events with removed types (like headCircumference)
      return null;
    }

    return EventRecord(
      id: json['id'],
      childId: json['childId'],
      type: eventType,
      startAt: DateTime.parse(json['startAt']),
      endAt: json['endAt'] != null ? DateTime.parse(json['endAt']) : null,
      data: Map<String, dynamic>.from(json['data'] ?? {}),
      comment: json['comment'],
    );
  }

  EventRecord copyWith({
    String? id,
    String? childId,
    EventType? type,
    DateTime? startAt,
    DateTime? endAt,
    Map<String, dynamic>? data,
    String? comment,
  }) => EventRecord(
    id: id ?? this.id,
    childId: childId ?? this.childId,
    type: type ?? this.type,
    startAt: startAt ?? this.startAt,
    endAt: endAt ?? this.endAt,
    data: data ?? this.data,
    comment: comment ?? this.comment,
  );

  Duration? get duration => endAt?.difference(startAt);
}

// Extension for display names
extension EventTypeExtension on EventType {
  String get displayName {
    switch (this) {
      case EventType.sleeping: return 'Sleeping';
      case EventType.bedtimeRoutine: return 'Bedtime Routine';
      case EventType.cry: return 'Cry';
      case EventType.feedingBreast: return 'Feeding (Breast)';
      case EventType.feedingBottle: return 'Bottle';
      case EventType.food: return 'Food';
      case EventType.diaper: return 'Diaper';
      case EventType.condition: return 'Condition';
      case EventType.medicine: return 'Medicine';
      case EventType.temperature: return 'Temperature';
      case EventType.doctor: return 'Doctor';
      case EventType.bathing: return 'Bathing';
      case EventType.walking: return 'Walking';
      case EventType.activity: return 'Activity';
      case EventType.weight: return 'Weight';
      case EventType.height: return 'Height';
      case EventType.expressing: return 'Expressing';
      case EventType.spitUp: return 'Spit-up';
    }
  }
}
