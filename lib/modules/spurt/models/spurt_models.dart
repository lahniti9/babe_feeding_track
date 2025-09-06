enum SpurtType { growthLeap, fussyPhase }

class SpurtEpisode {
  /// Week index since birth (1-based). The colored tile "number" you show.
  final int week;

  /// Number of consecutive weeks for this episode (most are 1).
  final int durationWeeks;

  final SpurtType type;

  /// Key to look up detail copy (behavior / skills / feeding / sleep / communication).
  final String contentKey;

  const SpurtEpisode({
    required this.week,
    this.durationWeeks = 1,
    required this.type,
    required this.contentKey,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpurtEpisode &&
          runtimeType == other.runtimeType &&
          week == other.week &&
          durationWeeks == other.durationWeeks &&
          type == other.type &&
          contentKey == other.contentKey;

  @override
  int get hashCode =>
      week.hashCode ^
      durationWeeks.hashCode ^
      type.hashCode ^
      contentKey.hashCode;

  @override
  String toString() {
    return 'SpurtEpisode{week: $week, durationWeeks: $durationWeeks, type: $type, contentKey: $contentKey}';
  }
}

class SpurtContent {
  final String titleLine;         // "This growth leap will occur in … days"
  final String behavior;          // "Becomes more sensitive to surroundings…"
  final String skill;             // "Shows first deliberate smile…"
  final String feeding;           // "Feeds more often…"
  final String sleep;             // "Sleeps 16–18 h a day…"
  final String communication;     // "First attempts at eye contact…"

  const SpurtContent({
    required this.titleLine,
    required this.behavior,
    required this.skill,
    required this.feeding,
    required this.sleep,
    required this.communication,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpurtContent &&
          runtimeType == other.runtimeType &&
          titleLine == other.titleLine &&
          behavior == other.behavior &&
          skill == other.skill &&
          feeding == other.feeding &&
          sleep == other.sleep &&
          communication == other.communication;

  @override
  int get hashCode =>
      titleLine.hashCode ^
      behavior.hashCode ^
      skill.hashCode ^
      feeding.hashCode ^
      sleep.hashCode ^
      communication.hashCode;

  @override
  String toString() {
    return 'SpurtContent{titleLine: $titleLine, behavior: $behavior, skill: $skill, feeding: $feeding, sleep: $sleep, communication: $communication}';
  }
}
