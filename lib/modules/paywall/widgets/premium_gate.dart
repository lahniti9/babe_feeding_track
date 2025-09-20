import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/subscription_service.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../../../routes/app_routes.dart';

class PremiumGate extends StatelessWidget {
  final Widget child;
  final String? featureName;
  final String? description;
  final Widget? fallback;

  const PremiumGate({
    super.key,
    required this.child,
    this.featureName,
    this.description,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Entitlements.isPro(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final isPro = snapshot.data ?? false;
        
        if (isPro) {
          return child;
        }
        
        return fallback ?? _buildPremiumPrompt();
      },
    );
  }

  Widget _buildPremiumPrompt() {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.star,
              color: AppColors.primary,
              size: 30,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Premium Feature',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            description ?? 
            (featureName != null 
              ? 'Unlock $featureName with a premium subscription'
              : 'This feature requires a premium subscription'),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: () => Get.toNamed(Routes.paywallStory),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textPrimary,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              'Upgrade to Premium',
              style: AppTextStyles.buttonText,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for gating specific tiles/cards
class PremiumTile extends StatelessWidget {
  final Widget child;
  final String featureName;
  final VoidCallback? onTap;

  const PremiumTile({
    super.key,
    required this.child,
    required this.featureName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Entitlements.isPro(),
      builder: (context, snapshot) {
        final isPro = snapshot.data ?? false;
        
        if (isPro) {
          return GestureDetector(
            onTap: onTap,
            child: child,
          );
        }
        
        return GestureDetector(
          onTap: () => Get.toNamed(Routes.paywallStory),
          child: Stack(
            children: [
              // Dimmed child
              Opacity(
                opacity: 0.5,
                child: child,
              ),
              
              // Premium overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Premium',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Helper function for quick premium checks
Future<void> requirePremium(VoidCallback action, {String? feature}) async {
  await Entitlements.requirePro(
    action,
    onPaywallNeeded: () => Get.toNamed(
      Routes.paywallStory,
      arguments: {'feature': feature},
    ),
  );
}
