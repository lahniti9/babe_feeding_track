enum QuestionType {
  singleChoice,
  multipleChoice,
  text,
  number,
  date,
  time,
  timeRange,
  emoji,
}

class QuestionAnswer {
  final String id;
  final String questionId;
  final QuestionType type;
  final dynamic value;
  final DateTime answeredAt;

  const QuestionAnswer({
    required this.id,
    required this.questionId,
    required this.type,
    required this.value,
    required this.answeredAt,
  });

  // Get typed value for single choice
  String? get singleChoiceValue {
    if (type == QuestionType.singleChoice && value is String) {
      return value as String;
    }
    return null;
  }

  // Get typed value for multiple choice
  List<String>? get multipleChoiceValue {
    if (type == QuestionType.multipleChoice && value is List) {
      return (value as List).cast<String>();
    }
    return null;
  }

  // Get typed value for text
  String? get textValue {
    if (type == QuestionType.text && value is String) {
      return value as String;
    }
    return null;
  }

  // Get typed value for number
  num? get numberValue {
    if (type == QuestionType.number && value is num) {
      return value as num;
    }
    return null;
  }

  // Get typed value for date
  DateTime? get dateValue {
    if (type == QuestionType.date && value is String) {
      return DateTime.tryParse(value as String);
    }
    return null;
  }

  // Get typed value for time
  Map<String, int>? get timeValue {
    if (type == QuestionType.time && value is Map) {
      final map = value as Map<String, dynamic>;
      return {
        'hour': map['hour'] ?? 0,
        'minute': map['minute'] ?? 0,
      };
    }
    return null;
  }

  // Get typed value for time range
  Map<String, Map<String, int>>? get timeRangeValue {
    if (type == QuestionType.timeRange && value is Map) {
      final map = value as Map<String, dynamic>;
      return {
        'start': {
          'hour': map['start']?['hour'] ?? 0,
          'minute': map['start']?['minute'] ?? 0,
        },
        'end': {
          'hour': map['end']?['hour'] ?? 0,
          'minute': map['end']?['minute'] ?? 0,
        },
      };
    }
    return null;
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionId': questionId,
      'type': type.name,
      'value': value,
      'answeredAt': answeredAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory QuestionAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionAnswer(
      id: json['id'],
      questionId: json['questionId'],
      type: QuestionType.values.firstWhere((t) => t.name == json['type']),
      value: json['value'],
      answeredAt: DateTime.parse(json['answeredAt']),
    );
  }

  // Copy with method for updates
  QuestionAnswer copyWith({
    String? id,
    String? questionId,
    QuestionType? type,
    dynamic value,
    DateTime? answeredAt,
  }) {
    return QuestionAnswer(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      type: type ?? this.type,
      value: value ?? this.value,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }

  @override
  String toString() => 'QuestionAnswer(id: $id, questionId: $questionId, type: $type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuestionAnswer && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
