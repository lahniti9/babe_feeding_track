import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bathing_controller.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
import '../widgets/enhanced_chip_group.dart';
import '../widgets/timer_circle.dart';

class BathingSheet extends StatelessWidget {
  const BathingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BathingController());

    return Obx(() => EventSheet(
      title: 'Bathing',
      subtitle: 'Track bath time',
      icon: Icons.bathtub_rounded,
      accentColor: const Color(0xFF06B6D4),
      onSubmit: controller.save,
      sections: [
        EnhancedTimeRow(
          label: 'Start Time',
          value: controller.startAt.value,
          onChange: controller.setStartTime,
          icon: Icons.access_time_rounded,
          accentColor: const Color(0xFF06B6D4),
        ),

        // Timer section
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF06B6D4).withValues(alpha: 0.05),
                const Color(0xFF06B6D4).withValues(alpha: 0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF06B6D4).withValues(alpha: 0.2),
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
                      color: const Color(0xFF06B6D4).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.timer_rounded,
                      color: Color(0xFF06B6D4),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'BATH TIMER',
                    style: TextStyle(
                      color: Color(0xFF06B6D4),
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
                gradientStart: const Color(0xFF06B6D4),
                gradientEnd: const Color(0xFF0891B2),
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
          accentColor: const Color(0xFF06B6D4),
          onTap: controller.toggleAid,
        ),

        EnhancedChipGroup(
          label: 'Mood',
          options: const ['Enjoyed', 'Cried', 'Calm', 'Playful', 'Relaxed'],
          selected: controller.mood,
          multiSelect: true,
          icon: Icons.sentiment_satisfied_rounded,
          accentColor: const Color(0xFF06B6D4),
          onTap: controller.toggleMood,
        ),
      ],
    ));
  }
}
