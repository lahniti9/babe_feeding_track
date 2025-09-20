import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/spurt_models.dart';
import '../data/spurt_presets.dart';
import '../../children/services/children_store.dart';
import '../../../data/services/spurt_content_service.dart';
import '../../../utils/spurt_content_demo.dart';

class SpurtController extends GetxController {
  // Reactive properties that update when active child changes
  final birthDate = Rx<DateTime>(DateTime.now());
  final dueDate = Rx<DateTime>(DateTime.now());
  final childName = RxString('Baby');
  final childId = RxnString();

  late final ChildrenStore _childrenStore;
  late final SpurtContentService _contentService;

  @override
  void onInit() {
    super.onInit();
    _childrenStore = Get.find<ChildrenStore>();
    _contentService = Get.find<SpurtContentService>();
    _initializeFromActiveChild();
    _setupChildChangeListener();
    // Set initial selected week to current week
    selectedWeek.value = currentWeek;
    // Ensure content is loaded
    _ensureContentLoaded();
  }

  /// Ensure content service has loaded data
  Future<void> _ensureContentLoaded() async {
    await _contentService.ensureContentLoaded();

    // Demonstrate the new content system in debug mode
    SpurtContentDemo.demonstrateContentSystem();
  }

  void _initializeFromActiveChild() {
    final activeChild = _childrenStore.active;
    _updateChildData(activeChild);
  }

  void _setupChildChangeListener() {
    // Listen to active child changes
    ever(_childrenStore.activeId, (String? newActiveId) {
      final activeChild = _childrenStore.active;
      _updateChildData(activeChild);
      // Update selected week to current week when child changes
      selectedWeek.value = currentWeek;
    });
  }

  void _updateChildData(dynamic activeChild) {
    if (activeChild != null) {
      birthDate.value = activeChild.birthDate;
      // Use due date for Wonder Weeks calculations, fallback to birth date if not available
      dueDate.value = activeChild.dueDate ?? activeChild.birthDate;
      childName.value = activeChild.name;
      childId.value = activeChild.id;
    } else {
      // Fallback to current date if no active child
      final now = DateTime.now();
      birthDate.value = now;
      dueDate.value = now;
      childName.value = 'Baby';
      childId.value = null;
    }
  }

  final selectedWeek = 1.obs;

  /// Get episodes from content service (with fallback to hardcoded data)
  List<SpurtEpisode> get episodes {
    if (_contentService.isLoaded) {
      return _contentService.episodes;
    }
    // Fallback to hardcoded data if content service isn't loaded yet
    return spurtEpisodes;
  }

  /// Calculate current week since due date (1-based) for Wonder Weeks
  int get currentWeek {
    final days = DateTime.now().difference(dueDate.value).inDays;
    return days <= 0 ? 1 : (days ~/ 7) + 1;
  }

  /// Get the start date of a specific week (based on due date)
  DateTime weekStart(int week) => dueDate.value.add(Duration(days: (week - 1) * 7));

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
      return e.type == SpurtType.leap
          ? 'This growth leap will occur in $days days'
          : 'This fussy phase will start in $days days';
    } else if (now.isAfter(end)) {
      final days = now.difference(end).inDays;
      return e.type == SpurtType.leap
          ? 'This growth leap ended $days days ago'
          : 'This fussy phase ended $days days ago';
    } else {
      return e.type == SpurtType.leap
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
    if (_contentService.isLoaded) {
      return _contentService.getLegacyContent(contentKey);
    }
    // Fallback to hardcoded data if content service isn't loaded yet
    return spurtContent[contentKey];
  }

  /// Check if week has an episode
  bool hasEpisode(int week) {
    return episodeForWeek(week) != null;
  }

  /// Get color for episode type
  String getEpisodeColor(SpurtType type) {
    switch (type) {
      case SpurtType.leap:
        return '#FF6B6B'; // Coral
      case SpurtType.fussy:
        return '#28C076'; // Green
    }
  }

  /// Get episode type name
  String getEpisodeTypeName(SpurtType type) {
    switch (type) {
      case SpurtType.leap:
        return 'Growth Leap';
      case SpurtType.fussy:
        return 'Fussy Phase';
    }
  }

  /// Get total number of weeks to display (up to 55)
  int get totalWeeks => 55;

  /// Get weeks for grid display
  List<int> get weekNumbers => List.generate(totalWeeks, (index) => index + 1);

  /// Get relevant week range based on child's current age
  List<int> get relevantWeekRange {
    if (!hasActiveChild) return weekNumbers;

    final current = currentWeek;
    final start = (current - 8).clamp(1, totalWeeks);
    final end = (current + 12).clamp(1, totalWeeks);

    return List.generate(end - start + 1, (index) => start + index);
  }

  /// Check if a week is in the past
  bool isWeekInPast(int week) {
    return week < currentWeek;
  }

  /// Check if a week is in the future
  bool isWeekInFuture(int week) {
    return week > currentWeek;
  }

  /// Check if a week is upcoming (within next 4 weeks)
  bool isWeekUpcoming(int week) {
    final current = currentWeek;
    return week > current && week <= current + 4;
  }

  /// Check if a week is recent (within last 4 weeks)
  bool isWeekRecent(int week) {
    final current = currentWeek;
    return week < current && week >= current - 4;
  }

  /// Get week status for UI styling
  WeekStatus getWeekStatus(int week) {
    if (isCurrentWeek(week)) return WeekStatus.current;
    if (isWeekUpcoming(week)) return WeekStatus.upcoming;
    if (isWeekRecent(week)) return WeekStatus.recent;
    if (isWeekInPast(week)) return WeekStatus.past;
    return WeekStatus.future;
  }

  /// Get Wonder Weeks data for a specific week
  SpurtWeek? getSpurtWeek(int week) {
    if (_contentService.isLoaded) {
      return _contentService.getSpurtWeek(week);
    }
    // Fallback to hardcoded data if content service isn't loaded yet
    return kSpurtWeeks[week];
  }

  /// Get week color based on Wonder Weeks data
  Color getWeekColor(int week) {
    final info = kSpurtWeeks[week];
    if (info == null) return Colors.transparent;
    return info.type == SpurtType.leap ? const Color(0xFFFF6B6B) : const Color(0xFF22C55E);
  }

  /// Get child's age in days from birth date
  int get childAgeInDays {
    return DateTime.now().difference(birthDate.value).inDays;
  }

  /// Get child's age in weeks from birth date
  int get childAgeInWeeks {
    return childAgeInDays ~/ 7;
  }

  /// Get child's age display string
  String get childAgeDisplay {
    final days = childAgeInDays;
    if (days < 7) {
      return '$days day${days == 1 ? '' : 's'} old';
    } else if (childAgeInWeeks < 8) {
      return '$childAgeInWeeks week${childAgeInWeeks == 1 ? '' : 's'} old';
    } else {
      final months = (childAgeInDays / 30.44).floor(); // Average days per month
      return '$months month${months == 1 ? '' : 's'} old';
    }
  }

  /// Get current week display with context
  String get currentWeekDisplay {
    final week = currentWeek;
    final spurtWeek = getSpurtWeek(week);
    if (spurtWeek != null) {
      return 'Week $week - ${spurtWeek.title}';
    }
    return 'Week $week';
  }

  /// Get next upcoming spurt information
  SpurtWeek? get nextSpurt {
    final current = currentWeek;
    for (int week = current + 1; week <= totalWeeks; week++) {
      final spurt = getSpurtWeek(week);
      if (spurt != null) return spurt;
    }
    return null;
  }

  /// Get days until next spurt
  int? get daysUntilNextSpurt {
    final current = currentWeek;
    for (int week = current + 1; week <= totalWeeks; week++) {
      final spurt = getSpurtWeek(week);
      if (spurt != null) {
        final startDate = weekStart(week);
        return startDate.difference(DateTime.now()).inDays;
      }
    }
    return null;
  }

  /// Check if there's an active child
  bool get hasActiveChild => childId.value != null;

  // Removed duplicate onInit - initialization is done in _initializeFromActiveChild
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
