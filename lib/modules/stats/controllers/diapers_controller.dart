import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/event.dart';
import '../../events/models/event.dart';
import '../models/stats_models.dart';
import '../services/stats_aggregator.dart';

class DiapersController extends GetxController {
  final String childId;
  final _storage = GetStorage();

  DiapersController({required this.childId});

  // Observable state
  final _isLoading = false.obs;
  final _diaperData = <Bar>[].obs;
  final _selectedPeriod = 'Week'.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<Bar> get diaperData => _diaperData;
  RxString get selectedPeriod => _selectedPeriod;

  @override
  void onInit() {
    super.onInit();
    _loadDiaperData();
  }

  void _loadDiaperData() {
    _isLoading.value = true;
    
    try {
      final range = _getRangeForPeriod(_selectedPeriod.value);
      
      // Load events from storage
      final eventsData = _storage.read('events') ?? [];
      final events = (eventsData as List)
          .map((e) => Event.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      // Load EventModel events from storage
      final eventModelsData = _storage.read('events_v2') ?? [];
      final eventModels = (eventModelsData as List)
          .map((e) => EventModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      // Get diaper count data from old events
      final oldDiaperData = StatsAggregator.countByBucket(
        {EventType.diaper},
        childId,
        range,
        events,
      );

      // Get diaper count data from new events
      final newDiaperData = StatsAggregator.countEventModelsByBucket(
        {EventKind.diaper},
        childId,
        range,
        eventModels,
      );

      // Combine data
      final combinedData = <String, double>{};
      for (final bar in oldDiaperData) {
        combinedData[bar.x.toString()] = (combinedData[bar.x.toString()] ?? 0.0) + bar.y;
      }
      for (final bar in newDiaperData) {
        combinedData[bar.x.toString()] = (combinedData[bar.x.toString()] ?? 0.0) + bar.y;
      }

      _diaperData.value = combinedData.entries
          .map((e) => Bar(e.key, e.value))
          .toList()
        ..sort((a, b) => a.x.toString().compareTo(b.x.toString()));

    } catch (e) {
      print('Error loading diaper data: $e');
      _diaperData.value = [];
    } finally {
      _isLoading.value = false;
    }
  }

  void changePeriod(String period) {
    _selectedPeriod.value = period;
    _loadDiaperData();
  }

  StatsRange _getRangeForPeriod(String period) {
    switch (period) {
      case 'Day':
        return StatsRange.lastWeek();
      case 'Week':
        return StatsRange.lastMonth();
      case 'Month':
        return StatsRange.last3Months();
      default:
        return StatsRange.lastMonth();
    }
  }
}
