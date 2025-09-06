class SleepEvent {
  final String id;
  final String childId;                 // to fetch child name
  final DateTime fellAsleep;
  final DateTime wokeUp;
  final String? comment;                // <= 300 chars
  final List<String> startTags;         // e.g., ["Content"]
  final List<String> endTags;           // e.g., ["Woke up naturally"]
  final List<String> howTags;           // e.g., ["Nursing"]

  const SleepEvent({
    required this.id,
    required this.childId,
    required this.fellAsleep,
    required this.wokeUp,
    this.comment,
    this.startTags = const [],
    this.endTags = const [],
    this.howTags = const [],
  });

  Duration get duration => wokeUp.difference(fellAsleep);

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'childId': childId,
      'fellAsleep': fellAsleep.toIso8601String(),
      'wokeUp': wokeUp.toIso8601String(),
      'comment': comment,
      'startTags': startTags,
      'endTags': endTags,
      'howTags': howTags,
    };
  }

  // Create from JSON
  factory SleepEvent.fromJson(Map<String, dynamic> json) {
    return SleepEvent(
      id: json['id'],
      childId: json['childId'],
      fellAsleep: DateTime.parse(json['fellAsleep']),
      wokeUp: DateTime.parse(json['wokeUp']),
      comment: json['comment'],
      startTags: List<String>.from(json['startTags'] ?? []),
      endTags: List<String>.from(json['endTags'] ?? []),
      howTags: List<String>.from(json['howTags'] ?? []),
    );
  }

  // Copy with method for updates
  SleepEvent copyWith({
    String? id,
    String? childId,
    DateTime? fellAsleep,
    DateTime? wokeUp,
    String? comment,
    List<String>? startTags,
    List<String>? endTags,
    List<String>? howTags,
  }) {
    return SleepEvent(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      fellAsleep: fellAsleep ?? this.fellAsleep,
      wokeUp: wokeUp ?? this.wokeUp,
      comment: comment ?? this.comment,
      startTags: startTags ?? this.startTags,
      endTags: endTags ?? this.endTags,
      howTags: howTags ?? this.howTags,
    );
  }

  @override
  String toString() => 'SleepEvent(id: $id, duration: $duration)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SleepEvent && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Tag catalogs (exact labels from screenshot)
const kSleepStartTags = [
  'Upset',
  'Content',
  'Long time to fall asleep',
];

const kSleepEndTags = [
  'Upset',
  'Woke up naturally',
  'Woke up child',
];

const kSleepHowTags = [
  'Nursing',
  'In bed',
  'Worn or held',
  'Next',
];

// Formatting helpers
String humanDuration(Duration d) {
  if (d.inSeconds < 60) return '${d.inSeconds} secs';
  if (d.inMinutes < 60) return '${d.inMinutes} min';
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  return m == 0 ? '$h hrs' : '$h hrs, $m min';
}

String relativeTime(DateTime t) {
  final now = DateTime.now();
  final diff = now.difference(t);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inHours < 1) return '${diff.inMinutes} min ago';
  return '${diff.inHours} hrs, ${diff.inMinutes.remainder(60)} min ago';
}

String childNameById(String id) {
  // TODO: Get from ProfileController when available
  return 'Naji'; // Default for now
}
