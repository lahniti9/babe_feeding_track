import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/temperature_controller.dart';
import '../widgets/event_sheet.dart';
import '../widgets/time_row.dart';
import '../widgets/number_row.dart';
import '../widgets/chip_group_row.dart';

class TemperatureSheet extends StatelessWidget {
  const TemperatureSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TemperatureController());

    return Obx(() => EventSheet(
      title: 'Temperature',
      onSubmit: controller.save,
      sections: [
        TimeRow(
          value: controller.time.value,
          onChange: (date) => controller.time.value = date,
        ),
        
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
        
        ChipGroupRow(
          label: 'Method',
          options: const ['Axillary', 'Rectal', 'Oral', 'Ear'],
          selected: controller.method,
          multi: false,
          icon: Icons.thermostat,
          iconColor: const Color(0xFF3BB3C4),
        ),
        
        ChipGroupRow(
          label: 'Condition',
          options: const ['Fever', 'Normal', 'Low'],
          selected: controller.condition,
          multi: false,
          icon: Icons.health_and_safety,
          iconColor: const Color(0xFF3BB3C4),
        ),
      ],
    ));
  }
}
