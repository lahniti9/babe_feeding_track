import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../../data/models/event.dart';
import '../../events/models/event.dart';
import '../../events/models/sleep_event.dart';
import '../models/stats_models.dart';

class MonthlyOverviewController extends GetxController {
  final String childId;
  final _storage = GetStorage();

  MonthlyOverviewController({required this.childId});

  // Observable state
  final _isLoading = false.obs;
  final _currentMonth = DateTime.now().obs;
  final _selectedFilters = <String>['All events'].obs;
  final _monthlyEvents = <int, List<String>>{}.obs;

  // Available filters
  final List<String> availableFilters = [
    'All events',
    'Bottle',
    'Daytime sleep',
  ];

  // Getters
  bool get isLoading => _isLoading.value;
  DateTime get currentMonth => _currentMonth.value;
  List<String> get selectedFilters => _selectedFilters;
  int get daysInCurrentMonth => DateTime(_currentMonth.value.year, _currentMonth.value.month + 1, 0).day;
  String get monthYearDisplay => DateFormat('MMMM yyyy').format(_currentMonth.value);

  @override
  void onInit() {
    super.onInit();
    _loadMonthlyData();
  }

  void _loadMonthlyData() {
    _isLoading.value = true;
    
    try {
      final monthStart = DateTime(_currentMonth.value.year, _currentMonth.value.month, 1);
      final monthEnd = DateTime(_currentMonth.value.year, _currentMonth.value.month + 1, 0, 23, 59, 59);

      // Load events from storage
      final eventsData = _storage.read('events') ?? [];
      final events = (eventsData as List)
          .map((e) => Event.fromJson(Map<String, dynamic>.from(e)))
          .where((e) => e.childId == childId && 
                       e.time.isAfter(monthStart) && 
                       e.time.isBefore(monthEnd))
          .toList();

      // Load EventModel events from storage
      final eventModelsData = _storage.read('events_v2') ?? [];
      final eventModels = (eventModelsData as List)
          .map((e) => EventModel.fromJson(Map<String, dynamic>.from(e)))
          .where((e) => e.time.isAfter(monthStart) && 
                       e.time.isBefore(monthEnd))
          .toList();

      // Load sleep events from storage
      final sleepEventsData = _storage.read('sleep_events') ?? [];
      final sleepEvents = (sleepEventsData as List)
          .map((e) => SleepEvent.fromJson(Map<String, dynamic>.from(e)))
          .where((e) => e.childId == childId &&
                       e.fellAsleep.isAfter(monthStart) && 
                       e.fellAsleep.isBefore(monthEnd))
          .toList();

      // Process events by day
      final eventsByDay = <int, List<String>>{};
      
      // Process bottle events
      for (final event in events) {
        if (event.type == EventType.bottle) {
          final day = event.time.day;
          eventsByDay.putIfAbsent(day, () => []).add('Bottle');
        }
      }

      for (final event in eventModels) {
        if (event.kind == EventKind.bottle) {
          final day = event.time.day;
          eventsByDay.putIfAbsent(day, () => []).add('Bottle');
        }
      }

      // Process daytime sleep events
      for (final sleep in sleepEvents) {
        if (DateTimeUtils.isDaytimeSleep(sleep.fellAsleep, sleep.wokeUp)) {
          final day = sleep.fellAsleep.day;
          eventsByDay.putIfAbsent(day, () => []).add('Daytime sleep');
        }
      }

      // Add "All events" marker for days with any events
      for (final day in eventsByDay.keys) {
        if (!eventsByDay[day]!.contains('All events')) {
          eventsByDay[day]!.add('All events');
        }
      }

      _monthlyEvents.value = eventsByDay;
    } catch (e) {
      print('Error loading monthly overview data: $e');
      _monthlyEvents.value = {};
    } finally {
      _isLoading.value = false;
    }
  }

  void toggleFilter(String filter) {
    if (_selectedFilters.contains(filter)) {
      _selectedFilters.remove(filter);
    } else {
      _selectedFilters.add(filter);
    }
  }

  List<String> getEventsForDay(int day) {
    final dayEvents = _monthlyEvents[day] ?? [];
    
    // Filter events based on selected filters
    if (_selectedFilters.contains('All events')) {
      return dayEvents;
    }
    
    return dayEvents.where((event) => _selectedFilters.contains(event)).toList();
  }

  bool isToday(int day) {
    final today = DateTime.now();
    return today.year == _currentMonth.value.year &&
           today.month == _currentMonth.value.month &&
           today.day == day;
  }

  void previousMonth() {
    _currentMonth.value = DateTime(_currentMonth.value.year, _currentMonth.value.month - 1);
    _loadMonthlyData();
  }

  void nextMonth() {
    _currentMonth.value = DateTime(_currentMonth.value.year, _currentMonth.value.month + 1);
    _loadMonthlyData();
  }

  void openFullReport() {
    Get.snackbar(
      'Full Report',
      'Detailed monthly overview and insights',
      backgroundColor: Colors.teal.withValues(alpha: 0.2),
      colorText: Colors.teal,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
