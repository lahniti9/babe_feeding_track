import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/activity_controller.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
import '../widgets/enhanced_chip_group.dart';
import '../widgets/timer_circle.dart';

class ActivitySheet extends StatelessWidget {
  const ActivitySheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ActivityController());

    return Obx(() => EventSheet(
      title: 'Activity',
      subtitle: 'Track activity time',
      icon: Icons.directions_run_rounded,
      accentColor: const Color(0xFFFF6B35),
      onSubmit: controller.save,
      sections: [
        EnhancedTimeRow(
          label: 'Start Time',
          value: controller.time.value,
          onChange: controller.setTime,
          icon: Icons.access_time_rounded,
          accentColor: const Color(0xFFFF6B35),
        ),

        // Timer section
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFF6B35).withValues(alpha: 0.05),
                const Color(0xFFFF6B35).withValues(alpha: 0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFFF6B35).withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.timer_rounded,
                      color: Color(0xFFFF6B35),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'TIMER',
                    style: TextStyle(
                      color: Color(0xFFFF6B35),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TimerCircle(
                isRunning: controller.running.value,
                timeText: controller.timeText,
                onToggle: controller.toggle,
                gradientStart: const Color(0xFFFF6B35),
                gradientEnd: const Color(0xFFFF8A00),
              ),
            ],
          ),
        ),

        EnhancedSegmentedControl(
          label: 'Activity Type',
          options: const ['Tummy time', 'Play mat', 'Baby gym', 'Outdoor walk', 'Free play'],
          selected: controller.typeDisplayName,
          onSelect: controller.setType,
          icon: Icons.category_rounded,
          accentColor: const Color(0xFFFF6B35),
        ),

        EnhancedSegmentedControl(
          label: 'Intensity',
          options: const ['Light', 'Moderate', 'Active'],
          selected: controller.intensity.value.capitalizeFirst ?? 'Moderate',
          onSelect: controller.setIntensity,
          icon: Icons.speed_rounded,
          accentColor: const Color(0xFFFF6B35),
        ),

        EnhancedCommentRow(
          label: 'Notes',
          value: controller.note.value,
          onChanged: controller.setNote,
          icon: Icons.note_rounded,
          accentColor: const Color(0xFFFF6B35),
          hint: 'Add activity notes...',
        ),
      ],
    ));
  }
}
