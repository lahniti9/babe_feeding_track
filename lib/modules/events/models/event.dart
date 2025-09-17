enum UserRole { mom, coParent, caregiver }

enum EventKind {
  sleeping,
  bedtimeRoutine,
  bottle,
  diaper,
  condition,
  cry,
  feeding,
  expressing,
  spitUp,
  food,
  weight,
  height,
  medicine,
  temperature,
  doctor,
  bathing,
  walking,
  activity,
}

extension EventKindExtension on EventKind {
  String get displayName {
    switch (this) {
      case EventKind.sleeping:
        return 'Sleeping';
      case EventKind.bedtimeRoutine:
        return 'Bedtime routine';
      case EventKind.bottle:
        return 'Bottle';
      case EventKind.diaper:
        return 'Diaper';
      case EventKind.condition:
        return 'Condition';
      case EventKind.cry:
        return 'Cry';
      case EventKind.weight:
        return 'Weight';
      case EventKind.height:
        return 'Height';
      case EventKind.feeding:
        return 'Feeding';
      case EventKind.expressing:
        return 'Expressing';
      case EventKind.spitUp:
        return 'Spit-up';
      case EventKind.food:
        return 'Food';
      case EventKind.medicine:
        return 'Medicine';
      case EventKind.temperature:
        return 'Temperature';
      case EventKind.doctor:
        return 'Doctor';
      case EventKind.bathing:
        return 'Bathing';
      case EventKind.walking:
        return 'Walking';
      case EventKind.activity:
        return 'Activity';
    }
  }
}

class EventModel {
  final String id;
  final String childId;             // to associate with specific child
  final EventKind kind;
  final DateTime time;              // for point event
  final DateTime? endTime;          // for ranged events (sleep)
  final String? title;              // e.g., "Bedtime routine", "Condition"
  final String? subtitle;           // e.g., "Swaddling", "Laughing", "5 lb 2 oz"
  final String? comment;            // user comment/note for this event
  final List<String> tags;          // pill tags ("Hi way this")
  final bool showPlus;              // small "+" bubble to add sub-entry/comment

  const EventModel({
    required this.id,
    required this.childId,
    required this.kind,
    required this.time,
    this.endTime,
    this.title,
    this.subtitle,
    this.comment,
    this.tags = const [],
    this.showPlus = false,
  });

  // Duration for ranged events
  Duration? get duration {
    if (endTime != null) {
      return endTime!.difference(time);
    }
    return null;
  }

  // Display title based on kind
  String get displayTitle {
    return title ?? kind.displayName;
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'childId': childId,
      'kind': kind.name,
      'time': time.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'title': title,
      'subtitle': subtitle,
      'comment': comment,
      'tags': tags,
      'showPlus': showPlus,
    };
  }

  // Create from JSON
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      childId: json['childId'] ?? 'default-child', // fallback for old data
      kind: EventKind.values.firstWhere((k) => k.name == json['kind']),
      time: DateTime.parse(json['time']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      title: json['title'],
      subtitle: json['subtitle'],
      comment: json['comment'],
      tags: List<String>.from(json['tags'] ?? []),
      showPlus: json['showPlus'] ?? false,
    );
  }

  // Copy with method for updates
  EventModel copyWith({
    String? id,
    String? childId,
    EventKind? kind,
    DateTime? time,
    DateTime? endTime,
    String? title,
    String? subtitle,
    String? comment,
    List<String>? tags,
    bool? showPlus,
  }) {
    return EventModel(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      kind: kind ?? this.kind,
      time: time ?? this.time,
      endTime: endTime ?? this.endTime,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      comment: comment ?? this.comment,
      tags: tags ?? this.tags,
      showPlus: showPlus ?? this.showPlus,
    );
  }

  @override
  String toString() => 'EventModel(id: $id, kind: $kind, time: $time)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
