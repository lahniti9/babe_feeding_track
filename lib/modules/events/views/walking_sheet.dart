import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/walking_controller.dart';
import '../models/event.dart';
import '../utils/event_colors.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
import '../widgets/timer_circle.dart';
import '../widgets/chip_group_row.dart';
import '../../../core/theme/spacing.dart';

class WalkingSheet extends StatelessWidget {
  const WalkingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WalkingController());
    final eventStyle = EventColors.getEventKindStyle(EventKind.walking);

    return Obx(() => EventSheet(
      title: 'Walking',
      subtitle: 'Track walking activities',
      icon: eventStyle.icon,
      accentColor: eventStyle.color,
      onSubmit: controller.save,
      sections: [
        EnhancedTimeRow(
          label: 'Time',
          value: controller.startAt.value,
          onChange: controller.setStartTime,
          icon: Icons.access_time_rounded,
          accentColor: eventStyle.color,
        ),
        
        // Timer section
        Container(
          padding: const EdgeInsets.all(20),
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
              // Timer circle
              TimerCircle(
                isRunning: controller.isRunning.value,
                timeText: controller.timeText,
                onToggle: controller.toggle,
                gradientStart: eventStyle.color,
                gradientEnd: eventStyle.color.withValues(alpha: 0.8),
              ),
              
              const SizedBox(height: AppSpacing.xl),
              
              ChipGroupRow(
                label: 'Mode',
                options: const ['Stroller', 'Carrier', 'Sling'],
                selected: controller.mode,
                multi: false,
                icon: Icons.stroller_outlined,
                iconColor: eventStyle.color,
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              ChipGroupRow(
                label: 'Place',
                options: const ['Outdoor', 'Indoor'],
                selected: controller.place,
                multi: false,
                icon: Icons.location_on,
                iconColor: eventStyle.color,
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
