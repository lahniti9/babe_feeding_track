import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../controllers/simple_sleep_controller.dart';

class SleepEntryView extends StatelessWidget {
  const SleepEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a simple controller for the original timer functionality
    final controller = Get.put(SimpleSleepController());

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grabber
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.textSecondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          _buildHeader(controller),

          // Tab content - just show timer tab
          Expanded(
            child: _buildTimerTab(controller),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(SimpleSleepController controller) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Title
          Text(
            'Sleeping',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildTimerTab(SimpleSleepController controller) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Central timer control
          Expanded(
            child: Center(
              child: Obx(() => _buildTimerControl(controller)),
            ),
          ),

          // Bottom controls
          _buildTimerBottomControls(controller),


        ],
      ),
    );
  }

  Widget _buildTimerControl(SimpleSleepController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Text(
          controller.running.value ? 'Woke up' : 'Fell asleep',
          style: AppTextStyles.captionMedium,
        ),
        const SizedBox(height: AppSpacing.lg),

        // Big circular button
        GestureDetector(
          onTap: () {
            if (controller.running.value) {
              controller.pauseTimer();
            } else {
              controller.startTimer();
            }
          },
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF6B46C1).withValues(alpha: 0.8),
                  const Color(0xFF7C3AED),
                ],
              ),
            ),
            child: Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  controller.running.value ? Icons.pause : Icons.play_arrow,
                  color: const Color(0xFF6B46C1),
                  size: 40,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Timer display
        Text(
          controller.timerDisplay,
          style: AppTextStyles.captionMedium,
        ),
      ],
    );
  }

  Widget _buildTimerBottomControls(SimpleSleepController controller) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.lg),
        child: Row(
          children: [
            // Reset button
            IconButton(
              onPressed: controller.resetTimer,
              icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
            ),

            const Spacer(),

            // Done button
            Obx(() => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: controller.canStopTimer
                    ? AppColors.success
                    : AppColors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(24),
              ),
              child: GestureDetector(
                onTap: controller.canStopTimer ? controller.stopTimerAndSave : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check,
                      color: controller.canStopTimer
                          ? Colors.white
                          : AppColors.textCaption,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      controller.timerDisplay,
                      style: AppTextStyles.buttonTextSmall.copyWith(
                        color: controller.canStopTimer
                            ? Colors.white
                            : AppColors.textCaption,
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }


}
