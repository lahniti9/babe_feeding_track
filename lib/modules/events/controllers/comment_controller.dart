import 'package:get/get.dart';
import '../models/event.dart';
import 'events_controller.dart';

class CommentController extends GetxController {
  // Comment text
  final RxString text = ''.obs;
  
  // Event kind this comment is for
  late final EventKind kind;
  
  // Character limit
  static const int maxCharacters = 300;

  // Initialize with event kind
  void init(EventKind eventKind) {
    kind = eventKind;
    text.value = '';
  }

  // Update text
  void updateText(String newText) {
    if (newText.length <= maxCharacters) {
      text.value = newText;
    }
  }

  // Clear text
  void clearText() {
    text.value = '';
  }

  // Save comment
  void save() {
    if (text.value.trim().isEmpty) return;
    
    final eventsController = Get.find<EventsController>();
    eventsController.addCommentToLast(kind, text.value.trim());
    
    Get.back();
    text.value = '';
  }

  // Check if form is valid
  bool get isValid {
    return text.value.trim().isNotEmpty;
  }

  // Get character count
  int get characterCount {
    return text.value.length;
  }

  // Get remaining characters
  int get remainingCharacters {
    return maxCharacters - text.value.length;
  }

  // Check if at character limit
  bool get isAtLimit {
    return text.value.length >= maxCharacters;
  }
}
