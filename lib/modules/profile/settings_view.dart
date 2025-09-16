import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/text.dart';
import '../../core/widgets/bc_scaffold.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BCScaffold(
      title: "Settings",
      showBack: false,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          // Settings options
          _buildSettingsSection("General", [
            _buildSettingsItem(
              icon: Icons.feedback_outlined,
              title: 'Send Feedback',
              onTap: () => _handleFeedback(),
            ),
            _buildSettingsItem(
              icon: Icons.star_outline_rounded,
              title: 'Rate Us',
              onTap: () => _handleRateUs(),
            ),
            _buildSettingsItem(
              icon: Icons.share_outlined,
              title: 'Share with Friends',
              onTap: () => _handleShare(),
            ),
          ]),

          const SizedBox(height: AppSpacing.lg),

          _buildSettingsSection("Legal", [
            _buildSettingsItem(
              icon: Icons.description_outlined,
              title: 'Terms of Use',
              onTap: () => _handleTerms(),
            ),
            _buildSettingsItem(
              icon: Icons.shield_outlined,
              title: 'Privacy Policy',
              onTap: () => _handlePrivacy(),
            ),
          ]),

          const SizedBox(height: AppSpacing.lg),

          _buildSettingsSection("About", [
            _buildSettingsItem(
              icon: Icons.info_outline_rounded,
              title: 'About',
              onTap: () => _showAbout(),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: AppColors.coral.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.coral.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                  ),
                  child: Icon(
                    Icons.settings_rounded,
                    color: AppColors.coral,
                    size: 16,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.coral,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.coral.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                child: Icon(
                  icon,
                  color: AppColors.coral,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }



  void _handleFeedback() {
    // Handle feedback functionality
    Get.snackbar(
      "Feedback",
      "Thank you for your interest! Feedback feature coming soon.",
      backgroundColor: AppColors.cardBackground,
      colorText: AppColors.textPrimary,
      snackPosition: SnackPosition.BOTTOM,
      icon: Icon(Icons.feedback_outlined, color: AppColors.coral),
    );
  }

  void _handleRateUs() {
    // Handle rate us functionality
    Get.snackbar(
      "Rate Us",
      "Thank you! Please rate us on the App Store.",
      backgroundColor: AppColors.cardBackground,
      colorText: AppColors.textPrimary,
      snackPosition: SnackPosition.BOTTOM,
      icon: Icon(Icons.star_outline_rounded, color: AppColors.coral),
    );
  }

  void _handleShare() {
    // Handle share functionality
    Get.snackbar(
      "Share",
      "Share feature coming soon!",
      backgroundColor: AppColors.cardBackground,
      colorText: AppColors.textPrimary,
      snackPosition: SnackPosition.BOTTOM,
      icon: Icon(Icons.share_outlined, color: AppColors.coral),
    );
  }

  void _handleTerms() {
    // Handle terms of use
    Get.snackbar(
      "Terms of Use",
      "Terms of Use will be available soon.",
      backgroundColor: AppColors.cardBackground,
      colorText: AppColors.textPrimary,
      snackPosition: SnackPosition.BOTTOM,
      icon: Icon(Icons.description_outlined, color: AppColors.coral),
    );
  }

  void _handlePrivacy() {
    // Handle privacy policy
    Get.snackbar(
      "Privacy Policy",
      "Privacy Policy will be available soon.",
      backgroundColor: AppColors.cardBackground,
      colorText: AppColors.textPrimary,
      snackPosition: SnackPosition.BOTTOM,
      icon: Icon(Icons.shield_outlined, color: AppColors.coral),
    );
  }

  void _showAbout() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          side: BorderSide(
            color: AppColors.coral.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: AppColors.coral,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'About',
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Babe Feeding Track',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.coral,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Version 1.0.0',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'A comprehensive baby care tracking app to help you monitor your baby\'s feeding, sleeping, and development milestones.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.coral.withValues(alpha: 0.1),
              foregroundColor: AppColors.coral,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
            ),
            child: Text(
              'OK',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.coral,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
