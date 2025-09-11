import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/walking_controller.dart';
import '../widgets/event_sheet_scaffold.dart';
import '../widgets/time_row.dart';
import '../widgets/timer_circle.dart';
import '../widgets/chip_group_row.dart';
import '../widgets/primary_pill.dart';
import '../../../core/theme/spacing.dart';

class WalkingSheet extends StatelessWidget {
  const WalkingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WalkingController());

    return EventSheetScaffold(
      title: 'Walking',
      child: Obx(() => Column(
        children: [
          TimeRow(
            value: controller.startAt.value,
            onChange: controller.setStartTime,
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Timer circle
          TimerCircle(
            isRunning: controller.isRunning.value,
            timeText: controller.timeText,
            onToggle: controller.toggle,
            gradientStart: const Color(0xFF2AC06A),
            gradientEnd: const Color(0xFF1E8E3E),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          ChipGroupRow(
            label: 'Mode',
            options: const ['Stroller', 'Carrier', 'Sling'],
            selected: controller.mode,
            multi: false,
            icon: Icons.stroller_outlined,
            iconColor: const Color(0xFF2AC06A),
          ),
          
          ChipGroupRow(
            label: 'Place',
            options: const ['Outdoor', 'Indoor'],
            selected: controller.place,
            multi: false,
            icon: Icons.location_on,
            iconColor: const Color(0xFF2AC06A),
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
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
                child: PrimaryPill(
                  label: controller.timeText,
                  icon: Icons.check,
                  onTap: controller.save,
                  enabled: controller.seconds.value > 0,
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              // Bell button
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
      )),
    );
  }
}
