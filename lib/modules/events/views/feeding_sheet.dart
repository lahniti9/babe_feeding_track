import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/colors.dart';
import '../controllers/feeding_controller.dart';
import '../models/breast_feeding_event.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';

class FeedingSheet extends StatelessWidget {
  const FeedingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FeedingController());

    return Obx(() => EventSheet(
      title: 'Feeding',
      subtitle: 'Track breastfeeding session',
      icon: Icons.child_care_rounded,
      accentColor: AppColors.coral,
      onSubmit: controller.completeFlow,
      sections: [
        // Enhanced time selection
        EnhancedTimeRow(
          label: 'Start Time',
          value: controller.startAt.value,
          onChange: controller.setStartTime,
          icon: Icons.access_time_rounded,
          accentColor: AppColors.coral,
        ),

        // Feeding norms tip
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackgroundSecondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.coral.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.coral.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.coral,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Feeding norms',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Enhanced timer section
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBackgroundSecondary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.coral.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Section header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.coral.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.timer_rounded,
                      color: AppColors.coral,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'FEEDING TIMERS',
                    style: TextStyle(
                      color: AppColors.coral,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Enhanced timer buttons
              Row(
                children: [
                  // Left timer
                  Expanded(
                    child: _EnhancedTimerButton(
                      label: 'Left',
                      timeText: prettySecs(controller.leftSec.value),
                      isRunning: controller.leftRunning,
                      onTap: controller.toggleLeft,
                      color: const Color(0xFF8B5CF6),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Right timer
                  Expanded(
                    child: _EnhancedTimerButton(
                      label: 'Right',
                      timeText: prettySecs(controller.rightSec.value),
                      isRunning: controller.rightRunning,
                      onTap: controller.toggleRight,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Control buttons row
              Row(
                children: [
                  // Reset button
                  _EnhancedControlButton(
                    icon: Icons.refresh_rounded,
                    onTap: controller.reset,
                    color: AppColors.coral,
                  ),

                  const SizedBox(width: 12),

                  // Total time display
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.coral.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.coral,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            controller.totalTime,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                ],
              ),
            ],
          ),
        ),
      ],
    ));
  }

}

// Enhanced timer button component
class _EnhancedTimerButton extends StatelessWidget {
  final String label;
  final String timeText;
  final bool isRunning;
  final VoidCallback onTap;
  final Color color;

  const _EnhancedTimerButton({
    required this.label,
    required this.timeText,
    required this.isRunning,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isRunning ? 140 : 120,
        decoration: BoxDecoration(
          color: isRunning
            ? color.withValues(alpha: 0.15)
            : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isRunning
              ? color
              : color.withValues(alpha: 0.3),
            width: isRunning ? 2 : 1,
          ),
          boxShadow: isRunning ? [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ] : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Play/Pause icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isRunning
                  ? color.withValues(alpha: 0.2)
                  : color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isRunning ? Icons.stop_rounded : Icons.play_arrow_rounded,
                color: color,
                size: 24,
              ),
            ),

            const SizedBox(height: 8),

            // Time text
            Text(
              timeText,
              style: TextStyle(
                color: isRunning ? color : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 4),

            // Label
            Text(
              label,
              style: TextStyle(
                color: isRunning ? color : Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Enhanced control button component
class _EnhancedControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _EnhancedControlButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: 22,
        ),
      ),
    );
  }
}
