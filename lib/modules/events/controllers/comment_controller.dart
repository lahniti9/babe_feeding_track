import 'package:get/get.dart';
import '../models/event.dart';
import 'events_controller.dart';

class CommentController extends GetxController {
  // Comment text
  final RxString text = ''.obs;

  // Event kind this comment is for
  late final EventKind kind;

  // Existing comment for editing
  String? existingComment;

  // Character limit
  static const int maxCharacters = 300;

  // Initialize with event kind and optional existing comment
  void init(EventKind eventKind, {String? comment}) {
    kind = eventKind;
    existingComment = comment;
    text.value = comment ?? '';


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
  Future<void> save() async {
    final trimmedText = text.value.trim();

    // If text is empty, handle deletion
    if (trimmedText.isEmpty) {
      if (existingComment != null && existingComment!.isNotEmpty) {
        // Delete existing comment by saving empty string
        final eventsController = Get.find<EventsController>();
        await eventsController.addCommentToLast(kind, '');
      }
      Get.back();
      text.value = '';
      return;
    }

    // Check if comment has actually changed
    if (existingComment != null && trimmedText == existingComment!.trim()) {
      // No changes made, just close without saving
      Get.back();
      text.value = '';
      return;
    }

    // Save the new or modified comment
    final eventsController = Get.find<EventsController>();
    await eventsController.addCommentToLast(kind, trimmedText);

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

  // Check if comment has changed from original
  bool get hasChanged {
    final currentText = text.value.trim();
    final originalText = existingComment?.trim() ?? '';
    return currentText != originalText;
  }

  // Check if comment can be deleted (has existing comment)
  bool get canDelete {
    return existingComment != null && existingComment!.isNotEmpty;
  }
}
