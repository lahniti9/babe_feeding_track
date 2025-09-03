import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';
import '../../../core/widgets/metric_toggle.dart';

class OnboardingController extends GetxController {
  final _storage = GetStorage();
  
  // Current step tracking
  final _currentStep = 0.obs;
  int get currentStep => _currentStep.value;
  
  // Answers storage
  final _answers = <String, dynamic>{}.obs;
  Map<String, dynamic> get answers => _answers;
  
  // User data
  final _parentName = ''.obs;
  final _parentRole = TeammateRole.mother.obs;
  final _babyName = ''.obs;
  final _babyBirthday = DateTime.now().obs;
  final _babyGender = Gender.boy.obs;
  final _birthWeight = Rx<Weight?>(null);
  final _teammateName = ''.obs;
  final _teammateRole = TeammateRole.father.obs;
  final _metricSystem = MetricSystem.metric.obs;
  
  // Getters
  String get parentName => _parentName.value;
  TeammateRole get parentRole => _parentRole.value;
  String get babyName => _babyName.value;
  DateTime get babyBirthday => _babyBirthday.value;
  Gender get babyGender => _babyGender.value;
  Weight? get birthWeight => _birthWeight.value;
  String get teammateName => _teammateName.value;
  TeammateRole get teammateRole => _teammateRole.value;
  MetricSystem get metricSystem => _metricSystem.value;
  
  @override
  void onInit() {
    super.onInit();
    _loadSavedData();
  }
  
  // Load saved onboarding data
  void _loadSavedData() {
    final savedAnswers = _storage.read('onboarding_answers');
    if (savedAnswers != null) {
      _answers.addAll(Map<String, dynamic>.from(savedAnswers));
    }
    
    _parentName.value = _storage.read('parent_name') ?? '';
    _babyName.value = _storage.read('baby_name') ?? '';
    _teammateName.value = _storage.read('teammate_name') ?? '';
    
    final savedBirthday = _storage.read('baby_birthday');
    if (savedBirthday != null) {
      _babyBirthday.value = DateTime.parse(savedBirthday);
    }
    
    final savedGender = _storage.read('baby_gender');
    if (savedGender != null) {
      _babyGender.value = Gender.values.firstWhere((g) => g.name == savedGender);
    }
    
    final savedWeight = _storage.read('birth_weight');
    if (savedWeight != null) {
      _birthWeight.value = Weight.fromJson(Map<String, dynamic>.from(savedWeight));
    }
    
    final savedMetric = _storage.read('metric_system');
    if (savedMetric != null) {
      _metricSystem.value = MetricSystem.values.firstWhere((m) => m.name == savedMetric);
    }
  }
  
  // Save answer for a question
  void saveAnswer(String questionId, dynamic value) {
    _answers[questionId] = value;
    _storage.write('onboarding_answers', _answers);
  }
  
  // Get answer for a question
  T? getAnswer<T>(String questionId) {
    final value = _answers[questionId];
    if (value is T) return value;
    return null;
  }
  
  // Check if question is answered
  bool isAnswered(String questionId) {
    return _answers.containsKey(questionId) && _answers[questionId] != null;
  }
  
  // Validate current step
  bool validateCurrentStep(String questionId) {
    return isAnswered(questionId);
  }
  
  // Set parent information
  void setParentName(String name) {
    _parentName.value = name;
    _storage.write('parent_name', name);
  }
  
  void setParentRole(TeammateRole role) {
    _parentRole.value = role;
    _storage.write('parent_role', role.name);
  }
  
  // Set baby information
  void setBabyName(String name) {
    _babyName.value = name;
    _storage.write('baby_name', name);
  }
  
  void setBabyBirthday(DateTime birthday) {
    _babyBirthday.value = birthday;
    _storage.write('baby_birthday', birthday.toIso8601String());
  }
  
  void setBabyGender(Gender gender) {
    _babyGender.value = gender;
    _storage.write('baby_gender', gender.name);
  }
  
  void setBirthWeight(Weight weight) {
    _birthWeight.value = weight;
    _storage.write('birth_weight', weight.toJson());
  }
  
  // Set teammate information
  void setTeammateName(String name) {
    _teammateName.value = name;
    _storage.write('teammate_name', name);
  }
  
  void setTeammateRole(TeammateRole role) {
    _teammateRole.value = role;
    _storage.write('teammate_role', role.name);
  }
  
  // Set metric system
  void setMetricSystem(MetricSystem system) {
    _metricSystem.value = system;
    _storage.write('metric_system', system.name);
  }
  
  // Navigation helpers
  void nextStep() {
    _currentStep.value++;
  }
  
  void previousStep() {
    if (_currentStep.value > 0) {
      _currentStep.value--;
    }
  }
  
  void goToStep(int step) {
    _currentStep.value = step;
  }
  
  // Complete onboarding
  void completeOnboarding() {
    _storage.write('onboarding_completed', true);
    Get.offAllNamed(Routes.tabs);
  }
  
  // Check if onboarding is completed
  bool get isOnboardingCompleted {
    return _storage.read('onboarding_completed') ?? false;
  }
  
  // Reset onboarding (for testing)
  void resetOnboarding() {
    _storage.remove('onboarding_completed');
    _storage.remove('onboarding_answers');
    _storage.remove('parent_name');
    _storage.remove('baby_name');
    _storage.remove('teammate_name');
    _storage.remove('baby_birthday');
    _storage.remove('baby_gender');
    _storage.remove('birth_weight');
    _storage.remove('metric_system');
    _answers.clear();
    _currentStep.value = 0;
  }
  
  // Get progress percentage
  double get progressPercentage {
    const totalSteps = 57; // Total onboarding steps
    return (_currentStep.value / totalSteps).clamp(0.0, 1.0);
  }
}
