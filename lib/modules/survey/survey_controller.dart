import 'package:get/get.dart';
import '../../data/models/models.dart';

class SurveyController extends GetxController {
  // Single choice selection
  final _selectedSingleChoice = Rx<String?>(null);
  String? get selectedSingleChoice => _selectedSingleChoice.value;
  
  // Multiple choice selections
  final _selectedMultipleChoices = <String>[].obs;
  List<String> get selectedMultipleChoices => _selectedMultipleChoices;
  
  // Text input
  final _textInput = ''.obs;
  String get textInput => _textInput.value;
  
  // Number input
  final _numberInput = Rx<num?>(null);
  num? get numberInput => _numberInput.value;
  
  // Date input
  final _dateInput = Rx<DateTime?>(null);
  DateTime? get dateInput => _dateInput.value;
  
  // Time input
  final _timeInput = Rx<Map<String, int>?>(null);
  Map<String, int>? get timeInput => _timeInput.value;
  
  // Time range input
  final _timeRangeInput = Rx<Map<String, Map<String, int>>?>(null);
  Map<String, Map<String, int>>? get timeRangeInput => _timeRangeInput.value;
  
  // Emoji selection
  final _selectedEmoji = Rx<String?>(null);
  String? get selectedEmoji => _selectedEmoji.value;
  
  // Validation state
  final _isValid = false.obs;
  bool get isValid => _isValid.value;
  
  // Loading state
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  
  // Initialize with existing answer
  void initializeWithAnswer(QuestionAnswer? answer) {
    if (answer == null) {
      _clearAll();
      return;
    }
    
    switch (answer.type) {
      case QuestionType.singleChoice:
        _selectedSingleChoice.value = answer.singleChoiceValue;
        break;
      case QuestionType.multipleChoice:
        _selectedMultipleChoices.value = answer.multipleChoiceValue ?? [];
        break;
      case QuestionType.text:
        _textInput.value = answer.textValue ?? '';
        break;
      case QuestionType.number:
        _numberInput.value = answer.numberValue;
        break;
      case QuestionType.date:
        _dateInput.value = answer.dateValue;
        break;
      case QuestionType.time:
        _timeInput.value = answer.timeValue;
        break;
      case QuestionType.timeRange:
        _timeRangeInput.value = answer.timeRangeValue;
        break;
      case QuestionType.emoji:
        _selectedEmoji.value = answer.singleChoiceValue;
        break;
    }
    
    _validateInput();
  }
  
  // Clear all inputs
  void _clearAll() {
    _selectedSingleChoice.value = null;
    _selectedMultipleChoices.clear();
    _textInput.value = '';
    _numberInput.value = null;
    _dateInput.value = null;
    _timeInput.value = null;
    _timeRangeInput.value = null;
    _selectedEmoji.value = null;
    _isValid.value = false;
  }
  
  // Single choice methods
  void selectSingleChoice(String value) {
    _selectedSingleChoice.value = value;
    _validateInput();
  }
  
  void clearSingleChoice() {
    _selectedSingleChoice.value = null;
    _validateInput();
  }
  
  bool isSingleChoiceSelected(String value) {
    return _selectedSingleChoice.value == value;
  }
  
  // Multiple choice methods
  void toggleMultipleChoice(String value) {
    if (_selectedMultipleChoices.contains(value)) {
      _selectedMultipleChoices.remove(value);
    } else {
      _selectedMultipleChoices.add(value);
    }
    _validateInput();
  }
  
  void selectMultipleChoice(String value) {
    if (!_selectedMultipleChoices.contains(value)) {
      _selectedMultipleChoices.add(value);
      _validateInput();
    }
  }
  
  void deselectMultipleChoice(String value) {
    _selectedMultipleChoices.remove(value);
    _validateInput();
  }
  
  void clearMultipleChoices() {
    _selectedMultipleChoices.clear();
    _validateInput();
  }
  
  bool isMultipleChoiceSelected(String value) {
    return _selectedMultipleChoices.contains(value);
  }
  
  // Text input methods
  void setTextInput(String value) {
    _textInput.value = value;
    _validateInput();
  }
  
  // Number input methods
  void setNumberInput(num value) {
    _numberInput.value = value;
    _validateInput();
  }
  
  // Date input methods
  void setDateInput(DateTime date) {
    _dateInput.value = date;
    _validateInput();
  }
  
  // Time input methods
  void setTimeInput(int hour, int minute) {
    _timeInput.value = {'hour': hour, 'minute': minute};
    _validateInput();
  }
  
  // Time range input methods
  void setTimeRangeInput(Map<String, int> start, Map<String, int> end) {
    _timeRangeInput.value = {'start': start, 'end': end};
    _validateInput();
  }
  
  // Emoji selection methods
  void selectEmoji(String value) {
    _selectedEmoji.value = value;
    _validateInput();
  }
  
  void clearEmoji() {
    _selectedEmoji.value = null;
    _validateInput();
  }
  
  bool isEmojiSelected(String value) {
    return _selectedEmoji.value == value;
  }
  
  // Validation
  void _validateInput() {
    _isValid.value = _hasValidInput();
  }
  
  bool _hasValidInput() {
    return _selectedSingleChoice.value != null ||
           _selectedMultipleChoices.isNotEmpty ||
           _textInput.value.isNotEmpty ||
           _numberInput.value != null ||
           _dateInput.value != null ||
           _timeInput.value != null ||
           _timeRangeInput.value != null ||
           _selectedEmoji.value != null;
  }
  
  // Get current answer value
  dynamic getCurrentValue(QuestionType type) {
    switch (type) {
      case QuestionType.singleChoice:
        return _selectedSingleChoice.value;
      case QuestionType.multipleChoice:
        return _selectedMultipleChoices.toList();
      case QuestionType.text:
        return _textInput.value;
      case QuestionType.number:
        return _numberInput.value;
      case QuestionType.date:
        return _dateInput.value?.toIso8601String();
      case QuestionType.time:
        return _timeInput.value;
      case QuestionType.timeRange:
        return _timeRangeInput.value;
      case QuestionType.emoji:
        return _selectedEmoji.value;
    }
  }
  
  // Create question answer
  QuestionAnswer createAnswer(String questionId, QuestionType type) {
    final now = DateTime.now();
    return QuestionAnswer(
      id: 'answer_${now.millisecondsSinceEpoch}',
      questionId: questionId,
      type: type,
      value: getCurrentValue(type),
      answeredAt: now,
    );
  }
  
  // Set loading state
  void setLoading(bool loading) {
    _isLoading.value = loading;
  }
  
  // Reset controller
  void reset() {
    _clearAll();
  }
}
