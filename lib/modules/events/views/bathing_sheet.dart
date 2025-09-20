import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bathing_controller.dart';
import '../models/event.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
import '../widgets/enhanced_chip_group.dart';
import '../widgets/timer_circle.dart';
import '../utils/event_colors.dart';

class BathingSheet extends StatelessWidget {
  const BathingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BathingController());

    final eventStyle = EventColors.getEventKindStyle(EventKind.bathing);

    return Obx(() => EventSheet(
      title: 'Bathing',
      subtitle: 'Track bath time',
      icon: eventStyle.icon,
      accentColor: eventStyle.color,
      onSubmit: controller.save,
      sections: [
        EnhancedTimeRow(
          label: 'Start Time',
          value: controller.startAt.value,
          onChange: controller.setStartTime,
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
                    'BATH TIMER',
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
                isRunning: controller.isRunning.value,
                timeText: controller.timeText,
                onToggle: controller.toggle,
                gradientStart: eventStyle.color,
                gradientEnd: eventStyle.color.withValues(alpha: 0.8),
              ),
            ],
          ),
        ),

        EnhancedChipGroup(
          label: 'Bath Aids',
          options: const ['Soap', 'Shampoo', 'Emollient', 'Toys', 'Bubbles'],
          selected: controller.aids,
          multiSelect: true,
          icon: Icons.bathtub_outlined,
          accentColor: eventStyle.color,
          onTap: controller.toggleAid,
        ),

        EnhancedChipGroup(
          label: 'Mood',
          options: const ['Enjoyed', 'Cried', 'Calm', 'Playful', 'Relaxed'],
          selected: controller.mood,
          multiSelect: true,
          icon: Icons.sentiment_satisfied_rounded,
          accentColor: eventStyle.color,
          onTap: controller.toggleMood,
        ),
      ],
    ));
  }
}
