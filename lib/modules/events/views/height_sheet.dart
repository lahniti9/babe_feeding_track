import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/height_controller.dart';
import '../widgets/event_sheet.dart';
import '../widgets/time_row.dart';
import '../widgets/big_number_wheel.dart';
import '../widgets/segmented_row.dart';

class HeightSheet extends StatelessWidget {
  const HeightSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HeightController());

    return Obx(() => EventSheet(
      title: 'Height',
      onSubmit: controller.save,
      sections: [
        TimeRow(
          value: controller.time.value,
          onChange: controller.setTime,
        ),
        
        SegmentedRow(
          label: 'Unit',
          items: const ['cm', 'in'],
          selected: () => controller.unit.value,
          onSelect: controller.setUnit,
        ),
        
        BigNumberWheel(
          value: controller.unit.value == 'cm' ? controller.cm.value : controller.inches.value,
          unit: controller.unit.value,
          onChange: controller.unit.value == 'cm' ? controller.setCm : controller.setInches,
          min: controller.unit.value == 'cm' ? 30.0 : 12.0,
          max: controller.unit.value == 'cm' ? 120.0 : 47.0,
          decimals: 1,
        ),
      ],
    ));
  }
}
