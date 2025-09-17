enum EventType {
  sleeping,
  feeding,
  bottle,
  diaper,
  condition,
  bathing,
  walking,
  weight,
  height,
  milestone,
  note,
}

class Event {
  final String id;
  final String childId;
  final EventType type;
  final DateTime time;
  final Map<String, dynamic> detail;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Event({
    required this.id,
    required this.childId,
    required this.type,
    required this.time,
    required this.detail,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  // Get event type display name
  String get typeDisplay {
    switch (type) {
      case EventType.sleeping:
        return 'Sleeping';
      case EventType.feeding:
        return 'Feeding';
      case EventType.bottle:
        return 'Bottle';
      case EventType.diaper:
        return 'Diaper';
      case EventType.condition:
        return 'Condition';
      case EventType.bathing:
        return 'Bathing';
      case EventType.walking:
        return 'Walking';
      case EventType.weight:
        return 'Weight';
      case EventType.height:
        return 'Height';
      case EventType.milestone:
        return 'Milestone';
      case EventType.note:
        return 'Note';
    }
  }

  // Get event icon
  String get iconName {
    switch (type) {
      case EventType.sleeping:
        return 'bed';
      case EventType.feeding:
        return 'restaurant';
      case EventType.bottle:
        return 'local_drink';
      case EventType.diaper:
        return 'baby_changing_station';
      case EventType.condition:
        return 'mood';
      case EventType.bathing:
        return 'bathtub';
      case EventType.walking:
        return 'directions_walk';
      case EventType.weight:
        return 'monitor_weight';
      case EventType.height:
        return 'height';
      case EventType.milestone:
        return 'star';
      case EventType.note:
        return 'note';
    }
  }

  // Get time ago display
  String get timeAgoDisplay {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      if (minutes == 0) {
        return '${hours}h ago';
      } else {
        return '${hours}h ${minutes}m ago';
      }
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else {
      return '${difference.inDays ~/ 7} week${difference.inDays ~/ 7 == 1 ? '' : 's'} ago';
    }
  }

  // Get detail display string
  String get detailDisplay {
    switch (type) {
      case EventType.weight:
        final grams = detail['grams'] as int?;
        final lb = detail['lb'] as int?;
        final oz = detail['oz'] as int?;
        if (grams != null) {
          return '${grams}g';
        } else if (lb != null && oz != null) {
          return '${lb}lb ${oz}oz';
        }
        return '';
      case EventType.condition:
        return detail['mood'] ?? '';
      case EventType.feeding:
        final duration = detail['duration'] as int?;
        if (duration != null) {
          return '$duration min';
        }
        return '';
      case EventType.bottle:
        final amount = detail['amount'] as num?;
        final unit = detail['unit'] as String?;
        if (amount != null && unit != null) {
          return '$amount $unit';
        }
        return '';
      default:
        return detail['description'] ?? '';
    }
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'childId': childId,
      'type': type.name,
      'time': time.toIso8601String(),
      'detail': detail,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      childId: json['childId'],
      type: EventType.values.firstWhere((t) => t.name == json['type']),
      time: DateTime.parse(json['time']),
      detail: Map<String, dynamic>.from(json['detail']),
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Copy with method for updates
  Event copyWith({
    String? id,
    String? childId,
    EventType? type,
    DateTime? time,
    Map<String, dynamic>? detail,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Event(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      type: type ?? this.type,
      time: time ?? this.time,
      detail: detail ?? this.detail,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Event(id: $id, type: $typeDisplay, time: $timeAgoDisplay)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Event && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
