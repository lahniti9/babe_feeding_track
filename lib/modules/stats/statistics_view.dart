import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/text.dart';
import '../../core/widgets/bc_scaffold.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BCScaffold(
      title: "Statistics",
      showBack: false,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          // Promo banner
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Track your baby's growth",
                        style: AppTextStyles.bodyLarge,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        "Monitor development milestones and health metrics",
                        style: AppTextStyles.subtitle,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.trending_up,
                  color: AppColors.primary,
                  size: AppSpacing.iconLg,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Statistics rows
          _buildStatsRow(
            icon: Icons.face,
            title: "Head circumference",
            onTap: () => _showComingSoon(),
          ),
          _buildStatsRow(
            icon: Icons.height,
            title: "Height",
            onTap: () => _showComingSoon(),
          ),
          _buildStatsRow(
            icon: Icons.monitor_weight,
            title: "Weight",
            onTap: () => _showComingSoon(),
          ),
          _buildStatsRow(
            icon: Icons.restaurant,
            title: "Feeding",
            onTap: () => _showComingSoon(),
          ),
          _buildStatsRow(
            icon: Icons.bed,
            title: "Sleeping",
            onTap: () => _showComingSoon(),
          ),
          _buildStatsRow(
            icon: Icons.baby_changing_station,
            title: "Diaper changes",
            onTap: () => _showComingSoon(),
          ),
          _buildStatsRow(
            icon: Icons.star,
            title: "Milestones",
            onTap: () => _showComingSoon(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatsRow({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.bodyLarge,
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
}
