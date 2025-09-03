import 'package:get_storage/get_storage.dart';
import '../models/models.dart';

class LocalRepository {
  final _storage = GetStorage();
  
  // Keys for storage
  static const String _childrenKey = 'children';
  static const String _teammatesKey = 'teammates';
  static const String _eventsKey = 'events';
  static const String _answersKey = 'onboarding_answers';
  static const String _currentUserKey = 'current_user';
  static const String _activeChildKey = 'active_child_id';
  static const String _metricSystemKey = 'metric_system';
  static const String _onboardingCompletedKey = 'onboarding_completed';
  
  // Children operations
  Future<List<Child>> getChildren() async {
    final data = _storage.read(_childrenKey);
    if (data == null) return [];
    
    return (data as List)
        .map((item) => Child.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
  
  Future<void> saveChildren(List<Child> children) async {
    await _storage.write(_childrenKey, children.map((c) => c.toJson()).toList());
  }
  
  Future<void> addChild(Child child) async {
    final children = await getChildren();
    children.add(child);
    await saveChildren(children);
  }
  
  Future<void> updateChild(Child child) async {
    final children = await getChildren();
    final index = children.indexWhere((c) => c.id == child.id);
    if (index != -1) {
      children[index] = child;
      await saveChildren(children);
    }
  }
  
  Future<void> deleteChild(String childId) async {
    final children = await getChildren();
    children.removeWhere((c) => c.id == childId);
    await saveChildren(children);
  }
  
  // Teammates operations
  Future<List<Teammate>> getTeammates() async {
    final data = _storage.read(_teammatesKey);
    if (data == null) return [];
    
    return (data as List)
        .map((item) => Teammate.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
  
  Future<void> saveTeammates(List<Teammate> teammates) async {
    await _storage.write(_teammatesKey, teammates.map((t) => t.toJson()).toList());
  }
  
  Future<void> addTeammate(Teammate teammate) async {
    final teammates = await getTeammates();
    teammates.add(teammate);
    await saveTeammates(teammates);
  }
  
  // Events operations
  Future<List<Event>> getEvents() async {
    final data = _storage.read(_eventsKey);
    if (data == null) return [];
    
    return (data as List)
        .map((item) => Event.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
  
  Future<void> saveEvents(List<Event> events) async {
    await _storage.write(_eventsKey, events.map((e) => e.toJson()).toList());
  }
  
  Future<void> addEvent(Event event) async {
    final events = await getEvents();
    events.insert(0, event); // Add to beginning
    await saveEvents(events);
  }
  
  // Onboarding operations
  Future<Map<String, dynamic>> getOnboardingAnswers() async {
    final data = _storage.read(_answersKey);
    return data != null ? Map<String, dynamic>.from(data) : {};
  }
  
  Future<void> saveOnboardingAnswers(Map<String, dynamic> answers) async {
    await _storage.write(_answersKey, answers);
  }
  
  Future<bool> isOnboardingCompleted() async {
    return _storage.read(_onboardingCompletedKey) ?? false;
  }
  
  Future<void> setOnboardingCompleted(bool completed) async {
    await _storage.write(_onboardingCompletedKey, completed);
  }
  
  // User preferences
  Future<Teammate?> getCurrentUser() async {
    final data = _storage.read(_currentUserKey);
    if (data == null) return null;
    
    return Teammate.fromJson(Map<String, dynamic>.from(data));
  }
  
  Future<void> setCurrentUser(Teammate user) async {
    await _storage.write(_currentUserKey, user.toJson());
  }
  
  Future<String?> getActiveChildId() async {
    return _storage.read(_activeChildKey);
  }
  
  Future<void> setActiveChildId(String childId) async {
    await _storage.write(_activeChildKey, childId);
  }
  
  Future<String> getMetricSystem() async {
    return _storage.read(_metricSystemKey) ?? 'metric';
  }
  
  Future<void> setMetricSystem(String system) async {
    await _storage.write(_metricSystemKey, system);
  }
  
  // Clear all data
  Future<void> clearAllData() async {
    await _storage.erase();
  }
}
