import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/temperature_controller.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
import '../widgets/number_row.dart';
import '../widgets/chip_group_row.dart';
import '../models/event_record.dart';
import '../models/event.dart';
import '../utils/event_colors.dart';

class TemperatureSheet extends StatelessWidget {
  final EventRecord? existingEvent;

  const TemperatureSheet({super.key, this.existingEvent});

  @override
  Widget build(BuildContext context) {
    // Ensure we get a fresh controller instance
    Get.delete<TemperatureController>();
    final controller = Get.put(TemperatureController());

    // If editing an existing event, populate the controller
    if (existingEvent != null) {
      controller.editEvent(existingEvent!);
    }

    final eventStyle = EventColors.getEventKindStyle(EventKind.temperature);

    return Obx(() => EventSheet(
      title: 'Temperature',
      subtitle: 'Track body temperature',
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
                      Icons.thermostat_rounded,
                      color: eventStyle.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'TEMPERATURE',
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
                label: 'Temperature',
                value: controller.value.value,
                unit: controller.unit.value,
                onChange: controller.setValue,
                onUnitChange: controller.setUnit,
                unitOptions: const ['°C', '°F'],
                min: 30.0,
                max: 45.0,
                decimals: 1,
                accentColor: eventStyle.color,
              ),

              const SizedBox(height: 20),

              ChipGroupRow(
                label: 'Method',
                options: const ['Axillary', 'Rectal', 'Oral', 'Ear'],
                selected: controller.method,
                multi: false,
                icon: Icons.thermostat,
                iconColor: eventStyle.color,
              ),

              const SizedBox(height: 16),

              ChipGroupRow(
                label: 'Condition',
                options: const ['Fever', 'Normal', 'Low'],
                selected: controller.condition,
                multi: false,
                icon: Icons.health_and_safety,
                iconColor: eventStyle.color,
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
