import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/theme/colors.dart';
import '../../../routes/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _pulseController;

  late Animation<double> _iconScaleAnimation;
  late Animation<double> _iconOpacityAnimation;
  late Animation<double> _iconRotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Icon animations - smooth entrance with elastic effect
    _iconScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
    ));

    _iconOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _iconRotationAnimation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
    ));

    // Pulse animation - continuous gentle pulsing
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    // Start icon animation with a gentle delay
    await Future.delayed(const Duration(milliseconds: 200));
    _iconController.forward();

    // Start continuous pulsing after icon appears
    await Future.delayed(const Duration(milliseconds: 1000));
    _pulseController.repeat(reverse: true);

    // Navigate to onboarding after main animations complete
    await Future.delayed(const Duration(milliseconds: 2000));
    _navigateToOnboarding();
  }

  void _navigateToOnboarding() {
    // Check if onboarding is completed
    final storage = GetStorage();
    final isOnboardingCompleted = storage.read('onboarding_completed') ?? false;

    if (isOnboardingCompleted) {
      // Navigate to main app
      Get.offNamed(Routes.tabs);
    } else {
      // Navigate to onboarding
      Get.offNamed(Routes.startGoal);
    }
  }

  @override
  void dispose() {
    _iconController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _iconController,
          _pulseController,
        ]),
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.background,
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Main app icon with animations
                  Transform.scale(
                    scale: _iconScaleAnimation.value * _pulseAnimation.value,
                    child: Transform.rotate(
                      angle: _iconRotationAnimation.value,
                      child: Opacity(
                        opacity: _iconOpacityAnimation.value,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/app_icon.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


