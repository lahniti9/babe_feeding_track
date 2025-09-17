import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/temperature_controller.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
import '../widgets/number_row.dart';
import '../widgets/chip_group_row.dart';
import '../models/event_record.dart';

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

    return Obx(() => EventSheet(
      title: 'Temperature',
      subtitle: 'Track body temperature',
      icon: Icons.thermostat_rounded,
      accentColor: const Color(0xFF3BB3C4),
      onSubmit: controller.save,
      sections: [
        EnhancedTimeRow(
          label: 'Time',
          value: controller.time.value,
          onChange: controller.setTime,
          icon: Icons.access_time_rounded,
          accentColor: const Color(0xFF3BB3C4),
        ),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF3BB3C4).withValues(alpha: 0.05),
                const Color(0xFF3BB3C4).withValues(alpha: 0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF3BB3C4).withValues(alpha: 0.2),
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
                      color: const Color(0xFF3BB3C4).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.thermostat_rounded,
                      color: Color(0xFF3BB3C4),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'TEMPERATURE',
                    style: TextStyle(
                      color: Color(0xFF3BB3C4),
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
              ),

              const SizedBox(height: 20),

              ChipGroupRow(
                label: 'Method',
                options: const ['Axillary', 'Rectal', 'Oral', 'Ear'],
                selected: controller.method,
                multi: false,
                icon: Icons.thermostat,
                iconColor: const Color(0xFF3BB3C4),
              ),

              const SizedBox(height: 16),

              ChipGroupRow(
                label: 'Condition',
                options: const ['Fever', 'Normal', 'Low'],
                selected: controller.condition,
                multi: false,
                icon: Icons.health_and_safety,
                iconColor: const Color(0xFF3BB3C4),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
