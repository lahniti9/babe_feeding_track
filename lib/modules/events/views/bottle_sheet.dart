import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottle_controller.dart';
import '../models/event_record.dart';
import '../models/event.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
import '../widgets/enhanced_chip_group.dart';
import '../widgets/number_row.dart';
import '../utils/event_colors.dart';

class BottleSheet extends StatelessWidget {
  final EventRecord? existingEvent;

  const BottleSheet({super.key, this.existingEvent});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottleController());

    // If editing an existing event, populate the controller
    if (existingEvent != null) {
      controller.editEvent(existingEvent!);
    }

    final eventStyle = EventColors.getEventKindStyle(EventKind.bottle);

    return Obx(() => EventSheet(
      title: 'Bottle',
      subtitle: 'Track bottle feeding',
      icon: eventStyle.icon,
      accentColor: eventStyle.color,
      onSubmit: controller.save,
      sections: [
        EnhancedTimeRow(
          label: 'Time',
          value: controller.time.value,
          onChange: (date) => controller.time.value = date,
          icon: Icons.access_time_rounded,
          accentColor: eventStyle.color,
        ),

        EnhancedSegmentedControl(
          label: 'Feeding type',
          options: const ['Formula', 'Breast milk'],
          selected: controller.feedType.value == 'formula' ? 'Formula' : 'Breast milk',
          onSelect: controller.setFeedType,
          icon: Icons.local_drink_rounded,
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
                      Icons.water_drop_rounded,
                      color: eventStyle.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'VOLUME',
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
              NumberRow(
                label: 'Volume',
                value: controller.volume.value,
                unit: controller.unit.value,
                onChange: controller.setVolume,
                onUnitChange: controller.setUnit,
                unitOptions: const ['oz', 'ml'],
                min: 0,
                max: 500,
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
