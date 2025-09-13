import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/bc_scaffold.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../../../routes/app_routes.dart';

class PromiseFingerprintView extends StatefulWidget {
  const PromiseFingerprintView({super.key});

  @override
  State<PromiseFingerprintView> createState() => _PromiseFingerprintViewState();
}

class _PromiseFingerprintViewState extends State<PromiseFingerprintView> {
  bool _isHolding = false;
  double _holdProgress = 0.0;

  void _startHolding() {
    setState(() {
      _isHolding = true;
    });
    
    // Animate progress over 3 seconds
    Future.delayed(const Duration(milliseconds: 100), () {
      _updateProgress();
    });
  }

  void _updateProgress() {
    if (!_isHolding) return;
    
    setState(() {
      _holdProgress += 0.033; // 3 seconds = 30 updates
    });
    
    if (_holdProgress >= 1.0) {
      // Complete - navigate to next screen
      Get.toNamed(Routes.youCanDoIt);
    } else {
      Future.delayed(const Duration(milliseconds: 100), () {
        _updateProgress();
      });
    }
  }

  void _stopHolding() {
    setState(() {
      _isHolding = false;
      _holdProgress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BCScaffold(
      showBack: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                ),
                child: Text(
                  '"I promise to be patient with myself and my baby as we learn and grow together."',
                  style: AppTextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              GestureDetector(
                onTapDown: (_) => _startHolding(),
                onTapUp: (_) => _stopHolding(),
                onTapCancel: () => _stopHolding(),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: _isHolding ? 10 : 0,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: _holdProgress,
                        strokeWidth: 4,
                        backgroundColor: Colors.white.withValues(alpha: 0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      Icon(
                        Icons.fingerprint,
                        color: Colors.white,
                        size: 40,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                "Hold to confirm",
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
