import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/height_controller.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
import '../widgets/big_number_wheel.dart';
import '../widgets/segmented_row.dart';
import '../models/event_record.dart';
import '../models/event.dart';
import '../utils/event_colors.dart';

class HeightSheet extends StatelessWidget {
  final EventRecord? existingEvent;

  const HeightSheet({super.key, this.existingEvent});

  @override
  Widget build(BuildContext context) {
    // Ensure we get a fresh controller instance
    Get.delete<HeightController>();
    final controller = Get.put(HeightController());

    // If editing an existing event, populate the controller
    if (existingEvent != null) {
      controller.editEvent(existingEvent!);
    }

    final eventStyle = EventColors.getEventKindStyle(EventKind.height);

    return Obx(() => EventSheet(
      title: 'Height',
      subtitle: 'Track height measurements',
      icon: eventStyle.icon,
      accentColor: eventStyle.color,
      onSubmit: controller.save,
      sections: [
        EnhancedTimeRow(
          label: 'Time',
          value: controller.time.value,
          onChange: controller.setTime,
          icon: Icons.access_time_rounded,
          accentColor: eventStyle.color,
        ),

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      Icons.height_rounded,
                      color: eventStyle.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'HEIGHT',
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

              SegmentedRow(
                label: 'Unit',
                items: const ['cm', 'in'],
                selected: () => controller.unit.value,
                onSelect: controller.setUnit,
                accentColor: eventStyle.color,
              ),

              const SizedBox(height: 20),

              BigNumberWheel(
                value: controller.unit.value == 'cm' ? controller.cm.value : controller.inches.value,
                unit: controller.unit.value,
                onChange: controller.unit.value == 'cm' ? controller.setCm : controller.setInches,
                min: 0.0,
                max: controller.unit.value == 'cm' ? 120.0 : 47.0,
                decimals: 1,
                accentColor: eventStyle.color,
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
