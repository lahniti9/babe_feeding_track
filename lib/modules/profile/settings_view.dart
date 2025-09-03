import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/text.dart';
import '../../core/widgets/bc_scaffold.dart';
import '../../core/widgets/metric_toggle.dart';
import 'profile_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    
    return BCScaffold(
      title: "Settings",
      showBack: false,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          // Profile section
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile",
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.md),
                Obx(() => Text(
                  controller.currentUserDisplayName,
                  style: AppTextStyles.subtitle,
                )),
                const SizedBox(height: AppSpacing.sm),
                Obx(() => Text(
                  "Active child: ${controller.activeChildDisplayName}",
                  style: AppTextStyles.subtitle,
                )),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Preferences section
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Preferences",
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Measurement System",
                      style: AppTextStyles.bodyMedium,
                    ),
                    Obx(() => MetricToggle(
                      selectedSystem: controller.metricSystem,
                      onChanged: controller.setMetricSystem,
                    )),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Settings options
          _buildSettingsSection("General", [
            _buildSettingsItem(
              icon: Icons.notifications,
              title: "Notifications",
              onTap: () => _showComingSoon(),
            ),
            _buildSettingsItem(
              icon: Icons.backup,
              title: "Backup & Sync",
              onTap: () => _showComingSoon(),
            ),
            _buildSettingsItem(
              icon: Icons.privacy_tip,
              title: "Privacy",
              onTap: () => _showComingSoon(),
            ),
          ]),
          
          const SizedBox(height: AppSpacing.lg),
          
          _buildSettingsSection("Support", [
            _buildSettingsItem(
              icon: Icons.help,
              title: "Help & FAQ",
              onTap: () => _showComingSoon(),
            ),
            _buildSettingsItem(
              icon: Icons.feedback,
              title: "Send Feedback",
              onTap: () => _showComingSoon(),
            ),
            _buildSettingsItem(
              icon: Icons.info,
              title: "About",
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              title,
              style: AppTextStyles.bodyLarge,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.textSecondary,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyMedium,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showComingSoon() {
    Get.snackbar(
      "Coming Soon",
      "This feature will be available in a future update",
      backgroundColor: AppColors.cardBackground,
      colorText: AppColors.textPrimary,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void _showAbout() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text('About', style: AppTextStyles.titleMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Babe Feeding Track',
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Version 1.0.0',
              style: AppTextStyles.subtitle,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'A comprehensive baby care tracking app to help you monitor your baby\'s feeding, sleeping, and development milestones.',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Close',
              style: AppTextStyles.buttonTextSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
