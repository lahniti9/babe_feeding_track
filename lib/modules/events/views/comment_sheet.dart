import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text.dart';
import '../controllers/comment_controller.dart';
import '../models/event.dart';

class CommentSheet extends StatelessWidget {
  final EventKind kind;

  const CommentSheet({
    super.key,
    required this.kind,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommentController());
    controller.init(kind);

    return Container(
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
              color: AppColors.textSecondary.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Enhanced header
          _buildEnhancedHeader(controller),

          // Content
          Expanded(
            child: Padding(
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
                      'Add Comment',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'for ${kind.displayName}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: controller.clearText,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
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
                onChanged: controller.updateText,
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
        onTap: controller.isValid ? controller.save : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: controller.isValid
                ? AppColors.coral
                : AppColors.textSecondary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(28),
            boxShadow: controller.isValid ? [
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
                color: controller.isValid
                    ? Colors.white
                    : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Save Comment',
                style: AppTextStyles.buttonText.copyWith(
                  color: controller.isValid
                      ? Colors.white
                      : AppColors.textSecondary,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
