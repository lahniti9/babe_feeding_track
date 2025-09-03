import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/models/models.dart';
import '../../core/widgets/metric_toggle.dart';

class ProfileController extends GetxController {
  final _storage = GetStorage();
  
  // Current user (parent)
  final _currentUser = Rx<Teammate?>(null);
  Teammate? get currentUser => _currentUser.value;
  
  // Children
  final _children = <Child>[].obs;
  List<Child> get children => _children;
  
  // Current active child
  final _activeChild = Rx<Child?>(null);
  Child? get activeChild => _activeChild.value;
  
  // Teammates
  final _teammates = <Teammate>[].obs;
  List<Teammate> get teammates => _teammates;
  
  // Metric system preference
  final _metricSystem = MetricSystem.metric.obs;
  MetricSystem get metricSystem => _metricSystem.value;
  
  @override
  void onInit() {
    super.onInit();
    _loadProfileData();
  }
  
  // Load profile data from storage
  void _loadProfileData() {
    // Load current user
    final userData = _storage.read('current_user');
    if (userData != null) {
      _currentUser.value = Teammate.fromJson(Map<String, dynamic>.from(userData));
    }
    
    // Load children
    final childrenData = _storage.read('children');
    if (childrenData != null) {
      _children.value = (childrenData as List)
          .map((child) => Child.fromJson(Map<String, dynamic>.from(child)))
          .toList();
    }
    
    // Load active child
    final activeChildId = _storage.read('active_child_id');
    if (activeChildId != null && _children.isNotEmpty) {
      _activeChild.value = _children.firstWhereOrNull((child) => child.id == activeChildId);
    } else if (_children.isNotEmpty) {
      _activeChild.value = _children.first;
    }
    
    // Load teammates
    final teammatesData = _storage.read('teammates');
    if (teammatesData != null) {
      _teammates.value = (teammatesData as List)
          .map((teammate) => Teammate.fromJson(Map<String, dynamic>.from(teammate)))
          .toList();
    }
    
    // Load metric system
    final savedMetric = _storage.read('metric_system');
    if (savedMetric != null) {
      _metricSystem.value = MetricSystem.values.firstWhere((m) => m.name == savedMetric);
    }
  }
  
  // Save profile data to storage
  void _saveProfileData() {
    if (_currentUser.value != null) {
      _storage.write('current_user', _currentUser.value!.toJson());
    }
    
    _storage.write('children', _children.map((child) => child.toJson()).toList());
    _storage.write('teammates', _teammates.map((teammate) => teammate.toJson()).toList());
    _storage.write('metric_system', _metricSystem.value.name);
    
    if (_activeChild.value != null) {
      _storage.write('active_child_id', _activeChild.value!.id);
    }
  }
  
  // Set current user
  void setCurrentUser(Teammate user) {
    _currentUser.value = user;
    _saveProfileData();
  }
  
  // Add child
  void addChild(Child child) {
    _children.add(child);
    if (_activeChild.value == null) {
      _activeChild.value = child;
    }
    _saveProfileData();
  }
  
  // Update child
  void updateChild(Child updatedChild) {
    final index = _children.indexWhere((child) => child.id == updatedChild.id);
    if (index != -1) {
      _children[index] = updatedChild;
      if (_activeChild.value?.id == updatedChild.id) {
        _activeChild.value = updatedChild;
      }
      _saveProfileData();
    }
  }
  
  // Remove child
  void removeChild(String childId) {
    _children.removeWhere((child) => child.id == childId);
    if (_activeChild.value?.id == childId) {
      _activeChild.value = _children.isNotEmpty ? _children.first : null;
    }
    _saveProfileData();
  }
  
  // Set active child
  void setActiveChild(Child child) {
    if (_children.contains(child)) {
      _activeChild.value = child;
      _saveProfileData();
    }
  }
  
  // Add teammate
  void addTeammate(Teammate teammate) {
    _teammates.add(teammate);
    _saveProfileData();
  }
  
  // Update teammate
  void updateTeammate(Teammate updatedTeammate) {
    final index = _teammates.indexWhere((teammate) => teammate.id == updatedTeammate.id);
    if (index != -1) {
      _teammates[index] = updatedTeammate;
      _saveProfileData();
    }
  }
  
  // Remove teammate
  void removeTeammate(String teammateId) {
    _teammates.removeWhere((teammate) => teammate.id == teammateId);
    _saveProfileData();
  }
  
  // Set metric system
  void setMetricSystem(MetricSystem system) {
    _metricSystem.value = system;
    _saveProfileData();
  }
  
  // Get child by ID
  Child? getChildById(String childId) {
    return _children.firstWhereOrNull((child) => child.id == childId);
  }
  
  // Get teammate by ID
  Teammate? getTeammateById(String teammateId) {
    return _teammates.firstWhereOrNull((teammate) => teammate.id == teammateId);
  }
  
  // Check if user has multiple children
  bool get hasMultipleChildren => _children.length > 1;
  
  // Check if user has teammates
  bool get hasTeammates => _teammates.isNotEmpty;
  
  // Get display name for current user
  String get currentUserDisplayName {
    return _currentUser.value?.name ?? 'User';
  }
  
  // Get display name for active child
  String get activeChildDisplayName {
    return _activeChild.value?.name ?? 'Baby';
  }
  
  // Create profile from onboarding data
  void createProfileFromOnboarding({
    required String parentName,
    required TeammateRole parentRole,
    required String babyName,
    required DateTime babyBirthday,
    required Gender babyGender,
    required Weight birthWeight,
    String? teammateName,
    TeammateRole? teammateRole,
    required MetricSystem metricSystem,
  }) {
    final now = DateTime.now();
    
    // Create current user
    final user = Teammate(
      id: 'user_${now.millisecondsSinceEpoch}',
      name: parentName,
      role: parentRole,
      isPrimary: true,
      createdAt: now,
      updatedAt: now,
    );
    setCurrentUser(user);
    
    // Create child
    final child = Child(
      id: 'child_${now.millisecondsSinceEpoch}',
      name: babyName,
      birthday: babyBirthday,
      gender: babyGender,
      birthWeight: birthWeight,
      createdAt: now,
      updatedAt: now,
    );
    addChild(child);
    
    // Create teammate if provided
    if (teammateName != null && teammateName.isNotEmpty && teammateRole != null) {
      final teammate = Teammate(
        id: 'teammate_${now.millisecondsSinceEpoch}',
        name: teammateName,
        role: teammateRole,
        isPrimary: false,
        createdAt: now,
        updatedAt: now,
      );
      addTeammate(teammate);
    }
    
    // Set metric system
    setMetricSystem(metricSystem);
  }
}
