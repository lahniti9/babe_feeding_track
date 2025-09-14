import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text.dart';
import '../controllers/simple_sleep_controller.dart';

class SleepEntryView extends StatefulWidget {
  const SleepEntryView({super.key});

  @override
  State<SleepEntryView> createState() => _SleepEntryViewState();
}

class _SleepEntryViewState extends State<SleepEntryView>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for the glow effect
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Rotation animation for the border
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    // Start animations
    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create a simple controller for the original timer functionality
    final controller = Get.put(SimpleSleepController());

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
        minHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            AppColors.cardBackground,
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 32,
            offset: const Offset(0, -12),
          ),
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
            blurRadius: 40,
            offset: const Offset(0, -20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Enhanced handle bar
          Container(
            margin: const EdgeInsets.only(top: 16),
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                  const Color(0xFF8B5CF6).withValues(alpha: 0.6),
                  const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Enhanced header
          _buildEnhancedHeader(controller),

          // Scrollable timer content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: _buildEnhancedTimerContent(controller),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedHeader(SimpleSleepController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.bedtime_rounded,
                  color: Color(0xFF8B5CF6),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sleeping',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                      controller.running.value
                        ? 'Sleep session in progress...'
                        : 'Track your baby\'s sleep time',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedTimerContent(SimpleSleepController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Enhanced circular timer with fixed height
          SizedBox(
            height: 450, // Fixed height for the timer section
            child: Center(
              child: Obx(() => _buildEnhancedCircularTimer(controller)),
            ),
          ),

          const SizedBox(height: 32),

          // Enhanced bottom controls
          _buildEnhancedBottomControls(controller),

          // Add bottom padding for safe area
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEnhancedCircularTimer(SimpleSleepController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Status label
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            controller.running.value
              ? 'Sleep in progress'
              : controller.sessionStartTime.value != null
                ? 'Sleep paused - tap to continue'
                : 'Tap to start sleep tracking',
            key: ValueKey('${controller.running.value}_${controller.sessionStartTime.value != null}'),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Enhanced circular timer with animations
        AnimatedBuilder(
          animation: Listenable.merge([_pulseController, _rotationController]),
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow effect
                if (controller.running.value)
                  Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),

                // Rotating border
                if (controller.running.value)
                  Transform.rotate(
                    angle: _rotationAnimation.value * 2 * 3.14159,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                // Main circular button
                GestureDetector(
                  onTap: controller.toggleTimer,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: controller.running.value
                          ? [
                              const Color(0xFF8B5CF6),
                              const Color(0xFF6D28D9),
                            ]
                          : [
                              const Color(0xFF6B46C1).withValues(alpha: 0.8),
                              const Color(0xFF7C3AED),
                            ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            controller.running.value ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            key: ValueKey(controller.running.value),
                            color: const Color(0xFF8B5CF6),
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 24),

        // Single timer display under the circle
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            controller.timerDisplay,
            key: ValueKey(controller.timerDisplay),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedBottomControls(SimpleSleepController controller) {
    return SafeArea(
      child: Column(
        children: [
          // Control buttons row
          Row(
            children: [
              // Reset button
              Expanded(
                child: GestureDetector(
                  onTap: controller.resetTimer,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackgroundSecondary,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          color: Colors.white.withValues(alpha: 0.7),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Reset',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Done button
              Expanded(
                flex: 2,
                child: Obx(() => GestureDetector(
                  onTap: controller.canStopTimer ? controller.stopTimerAndSave : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      gradient: controller.canStopTimer
                        ? const LinearGradient(
                            colors: [
                              Color(0xFF10B981),
                              Color(0xFF059669),
                            ],
                          )
                        : LinearGradient(
                            colors: [
                              AppColors.textSecondary.withValues(alpha: 0.3),
                              AppColors.textSecondary.withValues(alpha: 0.2),
                            ],
                          ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: controller.canStopTimer
                        ? [
                            BoxShadow(
                              color: const Color(0xFF10B981).withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_rounded,
                          color: controller.canStopTimer
                              ? Colors.white
                              : AppColors.textCaption,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Complete Sleep',
                          style: TextStyle(
                            color: controller.canStopTimer
                                ? Colors.white
                                : AppColors.textCaption,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ),
            ],
          ),

         
        ],
      ),
    );
  }
}
