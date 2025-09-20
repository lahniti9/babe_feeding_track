import 'dart:convert';

/// Schema version for content compatibility
class ContentSchema {
  final String version;
  final DateTime lastUpdated;
  final String description;

  const ContentSchema({
    required this.version,
    required this.lastUpdated,
    required this.description,
  });

  factory ContentSchema.fromJson(Map<String, dynamic> json) {
    return ContentSchema(
      version: json['schema_version'] as String,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schema_version': version,
      'last_updated': lastUpdated.toIso8601String(),
      'description': description,
    };
  }
}

/// Spurt type enumeration
enum SpurtContentType {
  fussy('fussy'),
  leap('leap');

  const SpurtContentType(this.value);
  final String value;

  static SpurtContentType fromString(String value) {
    return SpurtContentType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => SpurtContentType.fussy,
    );
  }
}

/// Individual week content data
class SpurtWeekContent {
  final SpurtContentType type;
  final String title;
  final List<String> behavior;
  final List<String> skills;
  final List<String> tips;

  const SpurtWeekContent({
    required this.type,
    required this.title,
    required this.behavior,
    required this.skills,
    required this.tips,
  });

  factory SpurtWeekContent.fromJson(Map<String, dynamic> json) {
    return SpurtWeekContent(
      type: SpurtContentType.fromString(json['type'] as String),
      title: json['title'] as String,
      behavior: List<String>.from(json['behavior'] as List),
      skills: List<String>.from(json['skills'] as List),
      tips: List<String>.from(json['tips'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'title': title,
      'behavior': behavior,
      'skills': skills,
      'tips': tips,
    };
  }

  /// Get formatted behavior text
  String get behaviorText => behavior.join(' ');

  /// Get formatted skills text
  String get skillsText => skills.join(' ');

  /// Get feeding-related tips
  String get feedingTips => tips
      .where((tip) => tip.toLowerCase().contains('feeding'))
      .join(' ');

  /// Get sleep-related tips
  String get sleepTips => tips
      .where((tip) => tip.toLowerCase().contains('sleep'))
      .join(' ');

  /// Get communication-related tips
  String get communicationTips => tips
      .where((tip) => tip.toLowerCase().contains('communication'))
      .join(' ');

  /// Generate title line with countdown placeholder
  String get titleLineTemplate {
    return type == SpurtContentType.leap
        ? 'This growth leap will occur in {days} days'
        : 'This fussy phase will start in {days} days';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpurtWeekContent &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          title == other.title &&
          _listEquals(behavior, other.behavior) &&
          _listEquals(skills, other.skills) &&
          _listEquals(tips, other.tips);

  @override
  int get hashCode =>
      type.hashCode ^
      title.hashCode ^
      behavior.hashCode ^
      skills.hashCode ^
      tips.hashCode;

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'SpurtWeekContent{type: $type, title: $title, behavior: $behavior, skills: $skills, tips: $tips}';
  }
}

/// Complete content data structure
class SpurtContentData {
  final ContentSchema schema;
  final Map<int, SpurtWeekContent> weeks;

  const SpurtContentData({
    required this.schema,
    required this.weeks,
  });

  factory SpurtContentData.fromJson(Map<String, dynamic> json) {
    final schema = ContentSchema.fromJson(json);
    final contentData = json['content'] as Map<String, dynamic>;
    final weeksData = contentData['weeks'] as Map<String, dynamic>;

    final weeks = <int, SpurtWeekContent>{};
    for (final entry in weeksData.entries) {
      final weekNumber = int.parse(entry.key);
      final weekContent = SpurtWeekContent.fromJson(
        entry.value as Map<String, dynamic>,
      );
      weeks[weekNumber] = weekContent;
    }

    return SpurtContentData(
      schema: schema,
      weeks: weeks,
    );
  }

  Map<String, dynamic> toJson() {
    final weeksJson = <String, dynamic>{};
    for (final entry in weeks.entries) {
      weeksJson[entry.key.toString()] = entry.value.toJson();
    }

    return {
      ...schema.toJson(),
      'content': {
        'weeks': weeksJson,
      },
    };
  }

  /// Get content for a specific week
  SpurtWeekContent? getWeekContent(int week) => weeks[week];

  /// Get all available weeks
  List<int> get availableWeeks => weeks.keys.toList()..sort();

  /// Check if content exists for a week
  bool hasWeekContent(int week) => weeks.containsKey(week);

  /// Get all leap weeks
  List<int> get leapWeeks => weeks.entries
      .where((entry) => entry.value.type == SpurtContentType.leap)
      .map((entry) => entry.key)
      .toList()
    ..sort();

  /// Get all fussy weeks
  List<int> get fussyWeeks => weeks.entries
      .where((entry) => entry.value.type == SpurtContentType.fussy)
      .map((entry) => entry.key)
      .toList()
    ..sort();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpurtContentData &&
          runtimeType == other.runtimeType &&
          schema == other.schema &&
          _mapEquals(weeks, other.weeks);

  @override
  int get hashCode => schema.hashCode ^ weeks.hashCode;

  static bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'SpurtContentData{schema: $schema, weeks: ${weeks.length} weeks}';
  }
}

/// Parse JSON string to SpurtContentData
SpurtContentData parseSpurtContentData(String jsonString) {
  final json = jsonDecode(jsonString) as Map<String, dynamic>;
  return SpurtContentData.fromJson(json);
}
