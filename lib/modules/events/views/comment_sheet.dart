import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
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
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grabber
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.textSecondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          _buildHeader(controller),
          
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text field
                  _buildTextField(controller),
                  
                  const Spacer(),
                  
                  // Bottom button
                  _buildBottomButton(controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(CommentController controller) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add a comment',
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      kind.displayName,
                      style: AppTextStyles.captionMedium,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: controller.clearText,
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(CommentController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text field
        Container(
          height: 200,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
          ),
          child: TextField(
            maxLines: null,
            expands: true,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Add your comment here...',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: controller.updateText,
          ),
        ),
        
        const SizedBox(height: AppSpacing.sm),
        
        // Character counter
        Obx(() => Text(
          '${controller.characterCount} / ${CommentController.maxCharacters}',
          style: AppTextStyles.caption.copyWith(
            color: controller.isAtLimit 
                ? AppColors.error 
                : AppColors.textSecondary,
          ),
        )),
      ],
    );
  }

  Widget _buildBottomButton(CommentController controller) {
    return SafeArea(
      child: Obx(() => GestureDetector(
        onTap: controller.isValid ? controller.save : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          decoration: BoxDecoration(
            color: controller.isValid 
                ? AppColors.success 
                : AppColors.textSecondary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check,
                color: controller.isValid 
                    ? Colors.white 
                    : AppColors.textCaption,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Done',
                style: AppTextStyles.buttonText.copyWith(
                  color: controller.isValid 
                      ? Colors.white 
                      : AppColors.textCaption,
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
