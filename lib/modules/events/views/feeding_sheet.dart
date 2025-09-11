import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/spacing.dart';
import '../controllers/feeding_controller.dart';
import '../models/breast_feeding_event.dart';
import '../widgets/modal_shell.dart';
import '../widgets/round_timer_button.dart';

class FeedingSheet extends StatelessWidget {
  const FeedingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FeedingController());

    return ModalShell(
      title: 'Feeding',
      right: GestureDetector(
        onTap: () => _showTimePicker(context, controller),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFF8A00),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Now',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      child: Column(
        children: [
          // Tip pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Color(0xFFBDBDBD),
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  'Feeding norms',
                  style: TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Timer buttons
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Left timer
              Flexible(
                child: RoundTimerButton(
                  size: controller.leftRunning ? 280.0 : 160.0,
                  running: controller.leftRunning,
                  timeText: prettySecs(controller.leftSec.value),
                  label: 'Left',
                  onTap: controller.toggleLeft,
                ),
              ),

              const SizedBox(width: 16),

              // Right timer
              Flexible(
                child: RoundTimerButton(
                  size: controller.rightRunning ? 280.0 : 160.0,
                  running: controller.rightRunning,
                  timeText: prettySecs(controller.rightSec.value),
                  label: 'Right',
                  onTap: controller.toggleRight,
                ),
              ),
            ],
          )),

          const SizedBox(height: AppSpacing.xl),

          // Bottom controls
          Row(
            children: [
              // Reset button
              GestureDetector(
                onTap: controller.reset,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E2E2E),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              // Complete button
              Expanded(
                child: Obx(() => GestureDetector(
                  onTap: controller.totalSec > 0 ? controller.completeFlow : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: controller.totalSec > 0 
                        ? const Color(0xFF2E7D32) 
                        : const Color(0xFF2E2E2E),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check, color: Colors.white),
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
                )),
              ),

              const SizedBox(width: AppSpacing.md),

              // Reminder button
              GestureDetector(
                onTap: () {
                  // TODO: Implement reminder functionality
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E2E2E),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTimePicker(BuildContext context, FeedingController controller) {
    showDatePicker(
      context: context,
      initialDate: controller.startAt.value,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(controller.startAt.value),
        ).then((time) {
          if (time != null) {
            final newDateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            controller.setStartTime(newDateTime);
          }
        });
      }
    });
  }
}
