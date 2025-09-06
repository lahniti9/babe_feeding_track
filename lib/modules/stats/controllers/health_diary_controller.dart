import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/event.dart';
import '../../events/models/event.dart';
import '../models/stats_models.dart';

class HealthDiaryController extends GetxController {
  final String childId;
  final _storage = GetStorage();

  HealthDiaryController({required this.childId});

  // Observable state
  final _isLoading = false.obs;
  final _temperatureData = <Point>[].obs;
  final _medicineData = <EventModel>[].obs;
  final _doctorData = <EventModel>[].obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<Point> get temperatureData => _temperatureData;
  List<EventModel> get medicineData => _medicineData;
  List<EventModel> get doctorData => _doctorData;

  @override
  void onInit() {
    super.onInit();
    _loadHealthData();
  }

  void _loadHealthData() {
    _isLoading.value = true;
    
    try {
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

      // Filter temperature events
      final temperatureEvents = events
          .where((e) => e.childId == childId && e.type == EventType.condition)
          .where((e) => e.detail.containsKey('temperature'))
          .toList();

      // Convert temperature events to points
      _temperatureData.value = temperatureEvents.map((e) {
        final temp = e.detail['temperature'] as double? ?? 0.0;
        return Point(e.time, temp);
      }).toList()..sort((a, b) => a.x.compareTo(b.x));

      // Filter medicine events
      _medicineData.value = eventModels
          .where((e) => e.kind == EventKind.medicine)
          .toList()..sort((a, b) => b.time.compareTo(a.time));

      // Filter doctor events
      _doctorData.value = eventModels
          .where((e) => e.kind == EventKind.doctor)
          .toList()..sort((a, b) => b.time.compareTo(a.time));

    } catch (e) {
      print('Error loading health diary data: $e');
      _temperatureData.value = [];
      _medicineData.value = [];
      _doctorData.value = [];
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void refresh() {
    _loadHealthData();
  }
}
