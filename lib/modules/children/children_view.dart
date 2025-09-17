import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/text.dart';
import 'services/children_store.dart';
import 'models/child_profile.dart';
import 'views/add_child_sheet.dart';
import 'views/edit_child_sheet.dart';

class ChildrenView extends StatelessWidget {
  const ChildrenView({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Get.find<ChildrenStore>();

    return Obx(() {
      final kids = store.children;

      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // Enhanced header with coral theme
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.coral.withValues(alpha: 0.1),
                      AppColors.cardBackground,
                    ],
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.coral.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Enhanced icon with coral theme
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.coral.withValues(alpha: 0.2),
                                AppColors.coral.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                            border: Border.all(
                              color: AppColors.coral.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.family_restroom_rounded,
                            color: AppColors.coral,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'My Children',
                                style: AppTextStyles.h2.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${kids.length} ${kids.length == 1 ? 'child' : 'children'} registered',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Add child button
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.coral,
                            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.coral.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            onPressed: () => _openAddChild(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Children list section
              Expanded(
                child: kids.isEmpty ? _buildEmptyState() : _buildChildrenList(kids, store),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius * 2),
                border: Border.all(
                  color: AppColors.coral.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.child_care_rounded,
                size: 64,
                color: AppColors.coral.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'No Children Yet',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Add your first child to start tracking their feeding, sleep, and growth patterns.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: () => _openAddChild(),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add First Child'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coral,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.lg,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildrenList(List<ChildProfile> kids, ChildrenStore store) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: kids.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.lg),
      itemBuilder: (_, i) {
        final child = kids[i];
        return Obx(() {
          final isActive = child.id == store.activeId.value;
          return _buildChildCard(child, isActive, store);
        });
      },
    );
  }

  Widget _buildChildCard(ChildProfile child, bool isActive, ChildrenStore store) {
    return GestureDetector(
      onTap: () => store.setActive(child.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isActive
                ? [
                    AppColors.coral.withValues(alpha: 0.15),
                    AppColors.cardBackground,
                  ]
                : [
                    AppColors.cardBackground,
                    AppColors.cardBackgroundSecondary,
                  ],
          ),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: isActive
                ? AppColors.coral.withValues(alpha: 0.5)
                : AppColors.border,
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.coral.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              // Child avatar
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: child.gender == BabyGender.girl
                      ? AppColors.coral
                      : const Color(0xFF3AA3FF),
                  border: isActive
                      ? Border.all(
                          color: Colors.white,
                          width: 3,
                        )
                      : null,
                ),
                child: child.avatar != null
                    ? ClipOval(
                        child: Image.network(
                          child.avatar!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildInitial(child),
                        ),
                      )
                    : _buildInitial(child),
              ),
              const SizedBox(width: AppSpacing.lg),

              // Child info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            child.name,
                            style: AppTextStyles.h4.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (isActive)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.coral,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Active',
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      child.ageDisplay,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: (child.gender == BabyGender.girl
                                    ? AppColors.coral
                                    : const Color(0xFF3AA3FF))
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: child.gender == BabyGender.girl
                                  ? AppColors.coral
                                  : const Color(0xFF3AA3FF),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            child.gender == BabyGender.girl ? 'Girl' : 'Boy',
                            style: AppTextStyles.caption.copyWith(
                              color: child.gender == BabyGender.girl
                                  ? AppColors.coral
                                  : const Color(0xFF3AA3FF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.settings_rounded,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          onPressed: () => _openEditChild(child),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitial(ChildProfile child) {
    return Center(
      child: Text(
        child.name.isNotEmpty ? child.name[0].toUpperCase() : 'B',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _openAddChild() => Get.bottomSheet(
    const AddChildSheet(),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );

  void _openEditChild(ChildProfile c) => Get.bottomSheet(
    EditChildSheet(profile: c),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}
