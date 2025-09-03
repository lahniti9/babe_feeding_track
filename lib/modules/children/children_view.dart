import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/text.dart';
import '../../core/widgets/bc_scaffold.dart';
import '../../data/models/child.dart';
import '../profile/profile_controller.dart';

class ChildrenView extends StatelessWidget {
  const ChildrenView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    
    return BCScaffold(
      title: "Children",
      showBack: false,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Children avatars row
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              ),
              child: Row(
                children: [
                  // Active child avatar
                  Obx(() {
                    final activeChild = controller.activeChild;
                    return _buildChildAvatar(
                      name: activeChild?.name ?? "Naji",
                      isActive: true,
                      gender: activeChild?.gender ?? Gender.boy,
                    );
                  }),
                  
                  const SizedBox(width: AppSpacing.md),
                  
                  // Add child button
                  _buildAddButton(),
                  
                  const SizedBox(width: AppSpacing.md),
                  
                  // More options
                  _buildMoreButton(),
                  
                  const Spacer(),
                  
                  // Invitation code
                  _buildInvitationCode(),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Child info section
            Obx(() {
              final activeChild = controller.activeChild;
              if (activeChild == null) {
                return _buildNoChildSection();
              }
              return _buildChildInfoSection(activeChild);
            }),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Relatives section
            _buildRelativesSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddChildDialog(),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.textPrimary),
      ),
    );
  }
  
  Widget _buildChildAvatar({
    required String name,
    required bool isActive,
    required Gender gender,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.cardBackgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: isActive ? AppColors.textPrimary : AppColors.primary,
            child: Icon(
              gender == Gender.boy ? Icons.boy : Icons.girl,
              color: isActive ? AppColors.primary : AppColors.textPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            name,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAddButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(
          color: AppColors.border,
          style: BorderStyle.solid,
        ),
      ),
      child: Icon(
        Icons.add,
        color: AppColors.textSecondary,
        size: 20,
      ),
    );
  }
  
  Widget _buildMoreButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Icon(
        Icons.more_horiz,
        color: AppColors.textSecondary,
        size: 20,
      ),
    );
  }
  
  Widget _buildInvitationCode() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Text(
        "Invitation code",
        style: AppTextStyles.caption,
      ),
    );
  }
  
  Widget _buildNoChildSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.child_care,
              size: 48,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              "No children added yet",
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              "Add your first child to get started",
              style: AppTextStyles.subtitle,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildChildInfoSection(Child child) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "A ${child.gender.name}",
            style: AppTextStyles.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            child.ageDisplay,
            style: AppTextStyles.subtitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            "Birth weight: ${child.birthWeight.toMetricString()}",
            style: AppTextStyles.subtitle,
          ),
        ],
      ),
    );
  }
  
  Widget _buildRelativesSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Relatives",
            style: AppTextStyles.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(
                Icons.phone_iphone,
                color: AppColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                "iPhone",
                style: AppTextStyles.subtitle,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  void _showAddChildDialog() {
    Get.snackbar(
      "Add Child",
      "This feature will be available in a future update",
      backgroundColor: AppColors.cardBackground,
      colorText: AppColors.textPrimary,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
