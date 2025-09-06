import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../../data/models/event.dart';
import '../../events/models/sleep_event.dart';
import '../models/stats_models.dart';
import '../services/stats_aggregator.dart';

class DailyResultsController extends GetxController {
  final String childId;
  final _storage = GetStorage();

  DailyResultsController({required this.childId});

  // Observable state
  final _isLoading = false.obs;
  final _dayArcs = <RadialArc>[].obs;
  final _selectedDate = DateTime.now().obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<RadialArc> get dayArcs => _dayArcs;
  String get todayDate => DateFormat('MMM d, yyyy').format(_selectedDate.value);

  @override
  void onInit() {
    super.onInit();
    _loadDayData();
  }

  void _loadDayData() {
    _isLoading.value = true;
    
    try {
      final selectedDay = _selectedDate.value;
      
      // Load events from storage
      final eventsData = _storage.read('events') ?? [];
      final events = (eventsData as List)
          .map((e) => Event.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      // Load sleep events from storage
      final sleepEventsData = _storage.read('sleep_events') ?? [];
      final sleepEvents = (sleepEventsData as List)
          .map((e) => SleepEvent.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      // Get day ring data using the aggregator
      final arcs = StatsAggregator.dayRing(
        childId,
        selectedDay,
        events,
        sleepEvents,
      );

      _dayArcs.value = arcs;
    } catch (e) {
      print('Error loading daily results data: $e');
      _dayArcs.value = [];
    } finally {
      _isLoading.value = false;
    }
  }

  void changeDate(DateTime date) {
    _selectedDate.value = date;
    _loadDayData();
  }

  void goToPreviousDay() {
    _selectedDate.value = _selectedDate.value.subtract(const Duration(days: 1));
    _loadDayData();
  }

  void goToNextDay() {
    _selectedDate.value = _selectedDate.value.add(const Duration(days: 1));
    _loadDayData();
  }

  void goToToday() {
    _selectedDate.value = DateTime.now();
    _loadDayData();
  }
}
