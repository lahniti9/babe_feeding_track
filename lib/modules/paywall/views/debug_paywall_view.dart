import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../utils/paywall_testing.dart';
import '../config/paywall_config.dart';

class DebugPaywallView extends StatelessWidget {
  const DebugPaywallView({super.key});

  @override
  Widget build(BuildContext context) {
    // Only show in debug mode
    if (!kDebugMode || !PaywallConfig.isTestMode) {
      return Scaffold(
        appBar: AppBar(title: const Text('Debug')),
        body: const Center(
          child: Text('Debug menu only available in debug mode'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paywall Debug'),
        backgroundColor: AppColors.background,
      ),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildSection(
            'Subscription Testing',
            [
              _buildButton(
                'Simulate Active Subscription',
                () => PaywallTesting.simulateSubscriptionActive(),
                Colors.green,
              ),
              _buildButton(
                'Simulate Inactive Subscription',
                () => PaywallTesting.simulateSubscriptionInactive(),
                Colors.red,
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          _buildSection(
            'Trial Testing',
            [
              _buildButton(
                'Simulate Active Trial',
                () => PaywallTesting.simulateTrialActive(),
                Colors.blue,
              ),
              _buildButton(
                'Simulate Expired Trial',
                () => PaywallTesting.simulateTrialExpired(),
                Colors.orange,
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          _buildSection(
            'Flow Testing',
            [
              _buildButton(
                'Test Onboarding Flow',
                () => PaywallTesting.testOnboardingFlow(),
                AppColors.primary,
              ),
              _buildButton(
                'Test Paywall Flow',
                () => PaywallTesting.testPaywallFlow(),
                AppColors.primary,
              ),
              _buildButton(
                'Test Premium Gating',
                () => PaywallTesting.testPremiumFeatureGating(),
                AppColors.primary,
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          _buildSection(
            'Reset & Debug',
            [
              _buildButton(
                'Reset All Test States',
                () => PaywallTesting.resetTestStates(),
                Colors.grey,
              ),
              _buildButton(
                'Print Debug Info',
                () => PaywallTesting.printDebugInfo(),
                Colors.purple,
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          _buildDebugInfo(),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...children,
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.buttonText,
        ),
      ),
    );
  }

  Widget _buildDebugInfo() {
    return FutureBuilder<Map<String, dynamic>>(
      future: PaywallTesting.getDebugInfo(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final info = snapshot.data!;
        
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Debug Information',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...info.entries.map((entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${entry.key}:',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '${entry.value}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ],
          ),
        );
      },
    );
  }
}
