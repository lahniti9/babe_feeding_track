class BreastFeedingEvent {
  final String id;
  final String childId;
  final DateTime startAt;
  final Duration left;
  final Duration right;
  final int? volumeOz;
  final String? comment;

  BreastFeedingEvent({
    required this.id,
    required this.childId,
    required this.startAt,
    required this.left,
    required this.right,
    this.volumeOz,
    this.comment,
  });

  Duration get total => left + right;

  Map<String, dynamic> toJson() => {
    'id': id,
    'childId': childId,
    'startAt': startAt.toIso8601String(),
    'left': left.inSeconds,
    'right': right.inSeconds,
    'volumeOz': volumeOz,
    'comment': comment,
  };

  factory BreastFeedingEvent.fromJson(Map<String, dynamic> json) => BreastFeedingEvent(
    id: json['id'],
    childId: json['childId'],
    startAt: DateTime.parse(json['startAt']),
    left: Duration(seconds: json['left']),
    right: Duration(seconds: json['right']),
    volumeOz: json['volumeOz'],
    comment: json['comment'],
  );

  BreastFeedingEvent copyWith({
    String? id,
    String? childId,
    DateTime? startAt,
    Duration? left,
    Duration? right,
    int? volumeOz,
    String? comment,
  }) => BreastFeedingEvent(
    id: id ?? this.id,
    childId: childId ?? this.childId,
    startAt: startAt ?? this.startAt,
    left: left ?? this.left,
    right: right ?? this.right,
    volumeOz: volumeOz ?? this.volumeOz,
    comment: comment ?? this.comment,
  );
}

// Helper function for formatting seconds
String prettySecs(int s) =>
  s >= 60 ? '${(s~/60).toString().padLeft(2,'0')}:${(s%60).toString().padLeft(2,'0')}'
          : '$s secs';
