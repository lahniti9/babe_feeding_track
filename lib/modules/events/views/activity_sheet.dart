import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/activity_controller.dart';
import '../models/event.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
import '../widgets/enhanced_chip_group.dart';
import '../widgets/timer_circle.dart';
import '../utils/event_colors.dart';

class ActivitySheet extends StatelessWidget {
  const ActivitySheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ActivityController());

    final eventStyle = EventColors.getEventKindStyle(EventKind.activity);

    return Obx(() => EventSheet(
      title: 'Activity',
      subtitle: 'Track activity time',
      icon: eventStyle.icon,
      accentColor: eventStyle.color,
      onSubmit: controller.save,
      sections: [
        EnhancedTimeRow(
          label: 'Start Time',
          value: controller.time.value,
          onChange: controller.setTime,
          icon: Icons.access_time_rounded,
          accentColor: eventStyle.color,
        ),

        // Timer section
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                eventStyle.color.withValues(alpha: 0.05),
                eventStyle.color.withValues(alpha: 0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: eventStyle.color.withValues(alpha: 0.2),
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
                      color: eventStyle.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.timer_rounded,
                      color: eventStyle.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'TIMER',
                    style: TextStyle(
                      color: eventStyle.color,
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
                gradientStart: eventStyle.color,
                gradientEnd: eventStyle.color.withValues(alpha: 0.8),
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
          accentColor: eventStyle.color,
        ),

        EnhancedSegmentedControl(
          label: 'Intensity',
          options: const ['Light', 'Moderate', 'Active'],
          selected: controller.intensity.value.capitalizeFirst ?? 'Moderate',
          onSelect: controller.setIntensity,
          icon: Icons.speed_rounded,
          accentColor: eventStyle.color,
        ),

        EnhancedCommentRow(
          label: 'Notes',
          value: controller.note.value,
          onChanged: controller.setNote,
          icon: Icons.note_rounded,
          accentColor: eventStyle.color,
          hint: 'Add activity notes...',
        ),
      ],
    ));
  }
}
