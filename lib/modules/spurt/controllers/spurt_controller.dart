import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../models/spurt_models.dart';
import '../data/spurt_presets.dart';

class SpurtController extends GetxController {
  SpurtController({required this.birthDate, required this.childName});

  final DateTime birthDate;
  final String childName;

  final episodes = spurtEpisodes.obs;
  final selectedWeek = 1.obs;

  /// Calculate current week since birth (1-based)
  int get currentWeek {
    final days = DateTime.now().difference(birthDate).inDays;
    return days <= 0 ? 1 : (days ~/ 7) + 1;
  }

  /// Get the start date of a specific week
  DateTime weekStart(int week) => birthDate.add(Duration(days: (week - 1) * 7));

  /// Get the end date of a specific week
  DateTime weekEnd(int week) => weekStart(week).add(const Duration(days: 6));

  /// Find episode for a specific week
  SpurtEpisode? episodeForWeek(int w) =>
      episodes.firstWhereOrNull((e) => w >= e.week && w < e.week + e.durationWeeks);

  /// Check if a week is the current week
  bool isCurrentWeek(int w) {
    final now = DateTime.now();
    final start = weekStart(w);
    final end = weekEnd(w).add(const Duration(days: 1));
    return now.isAfter(start) && now.isBefore(end);
  }

  /// Generate countdown text for detail header
  String countdownText(SpurtEpisode e) {
    final start = weekStart(e.week);
    final end = weekEnd(e.week);
    final now = DateTime.now();

    if (now.isBefore(start)) {
      final days = start.difference(now).inDays;
      return e.type == SpurtType.growthLeap
          ? 'This growth leap will occur in $days days'
          : 'This fussy phase will start in $days days';
    } else if (now.isAfter(end)) {
      final days = now.difference(end).inDays;
      return e.type == SpurtType.growthLeap
          ? 'This growth leap ended $days days ago'
          : 'This fussy phase ended $days days ago';
    } else {
      return e.type == SpurtType.growthLeap 
          ? 'This growth leap is ongoing' 
          : 'This fussy phase is ongoing';
    }
  }

  /// Get formatted date range for a week (d/M format)
  String rangeLabel(int w) {
    final start = weekStart(w);
    final end = weekEnd(w);
    return '${DateFormat('d/M').format(start)} – ${DateFormat('d/M').format(end)}';
  }

  /// Get month and day for a week start
  String monthDay(int w) => DateFormat('MMM d').format(weekStart(w));

  /// Get day number for date strip
  String dayNumber(DateTime date) => DateFormat('d').format(date);

  /// Get month abbreviation
  String monthAbbr(DateTime date) => DateFormat('MMM').format(date);

  /// Select a week for detail view
  void selectWeek(int week) {
    selectedWeek.value = week;
  }

  /// Get content for a specific episode
  SpurtContent? getContent(String contentKey) {
    return spurtContent[contentKey];
  }

  /// Check if week has an episode
  bool hasEpisode(int week) {
    return episodeForWeek(week) != null;
  }

  /// Get color for episode type
  String getEpisodeColor(SpurtType type) {
    switch (type) {
      case SpurtType.growthLeap:
        return '#FFA629'; // Orange
      case SpurtType.fussyPhase:
        return '#28C076'; // Green
    }
  }

  /// Get episode type name
  String getEpisodeTypeName(SpurtType type) {
    switch (type) {
      case SpurtType.growthLeap:
        return 'Growth Leap';
      case SpurtType.fussyPhase:
        return 'Fussy Phase';
    }
  }

  /// Get total number of weeks to display (up to 55)
  int get totalWeeks => 55;

  /// Get weeks for grid display
  List<int> get weekNumbers => List.generate(totalWeeks, (index) => index + 1);

  @override
  void onInit() {
    super.onInit();
    // Set initial selected week to current week
    selectedWeek.value = currentWeek;
  }
}

/// Controller for detail view
class SpurtDetailController extends GetxController {
  SpurtDetailController({required this.week, required this.parent});

  final int week;
  final SpurtController parent;

  late final SpurtEpisode episode = parent.episodeForWeek(week)!;
  late final SpurtContent content = parent.getContent(episode.contentKey)!;

  /// Get title line with countdown
  String get titleLine => parent.countdownText(episode);

  /// Get start date of the episode
  DateTime get start => parent.weekStart(week);

  /// Get previous day for date strip
  DateTime get prevDay => start.subtract(const Duration(days: 1));

  /// Get next day for date strip
  DateTime get nextDay => start.add(const Duration(days: 1));

  /// Get month abbreviations for date strip
  String get monthPrev => parent.monthAbbr(prevDay);
  String get monthCurr => parent.monthAbbr(start);
  String get monthNext => parent.monthAbbr(nextDay);

  /// Get day numbers for date strip
  String get dayPrev => parent.dayNumber(prevDay);
  String get dayCurr => parent.dayNumber(start);
  String get dayNext => parent.dayNumber(nextDay);

  /// Get episode color
  String get episodeColor => parent.getEpisodeColor(episode.type);

  /// Get episode type name
  String get episodeTypeName => parent.getEpisodeTypeName(episode.type);

  /// Handle "Got it" button tap
  void onGotItTap() {
    Get.back();
  }
}
