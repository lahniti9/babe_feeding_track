import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text.dart';
import '../controllers/comment_controller.dart';
import '../models/event.dart';

class CommentSheet extends StatefulWidget {
  final EventKind kind;
  final String? existingComment;

  const CommentSheet({
    super.key,
    required this.kind,
    this.existingComment,
  });

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  late String controllerTag;
  late CommentController controller;
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    // Use a unique tag to ensure fresh controller instance
    controllerTag = 'comment_${widget.kind.name}_${DateTime.now().millisecondsSinceEpoch}';
    controller = Get.put(CommentController(), tag: controllerTag);
    controller.init(widget.kind, comment: widget.existingComment);

    // Initialize TextEditingController with existing comment
    textController = TextEditingController(text: widget.existingComment ?? '');

    // Sync TextEditingController with CommentController
    textController.addListener(() {
      controller.updateText(textController.text);
    });
  }

  @override
  void dispose() {
    // Clean up the controllers
    textController.dispose();
    Get.delete<CommentController>(tag: controllerTag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: MediaQuery.of(context).size.height * 0.6, // Limit to 60% of screen height
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Enhanced grabber
          Container(
            width: 48,
            height: 5,
            margin: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              color: AppColors.coral.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Enhanced header
          _buildEnhancedHeader(controller),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced text field
                _buildEnhancedTextField(controller),

                const SizedBox(height: 24),

                // Enhanced bottom button
                _buildEnhancedBottomButton(controller),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedHeader(CommentController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Column(
        children: [
          Row(
            children: [
              // Event icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.coral.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.coral.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.chat_bubble_outline,
                  color: AppColors.coral,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.existingComment != null ? 'Edit Comment' : 'Add Comment',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'for ${widget.kind.displayName}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.border.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedTextField(CommentController controller) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            'Your comment',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // Enhanced text field
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: textController,
                maxLines: null,
                expands: true,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  height: 1.5,
                ),
                decoration: InputDecoration(
                  hintText: 'Share your thoughts, observations, or notes about this event...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                // onChanged is handled by textController.addListener() in initState
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Enhanced character counter
          Row(
            children: [
              Icon(
                Icons.edit_note,
                color: AppColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 6),
              Obx(() => Text(
                '${controller.characterCount} / ${CommentController.maxCharacters} characters',
                style: AppTextStyles.caption.copyWith(
                  color: controller.isAtLimit
                      ? AppColors.coral
                      : AppColors.textSecondary,
                  fontWeight: controller.isAtLimit ? FontWeight.w600 : FontWeight.normal,
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedBottomButton(CommentController controller) {
    return SafeArea(
      child: Obx(() => GestureDetector(
        onTap: _canSave(controller) ? controller.save : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: _canSave(controller)
                ? AppColors.coral
                : AppColors.textSecondary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(28),
            boxShadow: _canSave(controller) ? [
              BoxShadow(
                color: AppColors.coral.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: _canSave(controller)
                    ? Colors.white
                    : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 10),
              Obx(() => Text(
                _getButtonText(controller),
                style: AppTextStyles.buttonText.copyWith(
                  color: _canSave(controller)
                      ? Colors.white
                      : AppColors.textSecondary,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              )),
            ],
          ),
        ),
      )),
    );
  }

  String _getButtonText(CommentController controller) {
    if (widget.existingComment != null) {
      // Editing mode
      if (controller.text.value.trim().isEmpty) {
        return 'Delete Comment';
      } else if (controller.hasChanged) {
        return 'Update Comment';
      } else {
        return 'No Changes';
      }
    } else {
      // Adding mode
      return 'Save Comment';
    }
  }

  bool _canSave(CommentController controller) {
    if (widget.existingComment != null) {
      // In editing mode, can save if:
      // 1. Text is empty (deletion) OR
      // 2. Text has changed from original
      return controller.text.value.trim().isEmpty || controller.hasChanged;
    } else {
      // In adding mode, can save if text is not empty
      return controller.isValid;
    }
  }
}
