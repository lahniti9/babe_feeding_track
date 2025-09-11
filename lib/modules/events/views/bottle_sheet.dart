import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottle_controller.dart';
import '../widgets/event_sheet.dart';
import '../widgets/time_row.dart';
import '../widgets/segmented_row.dart';
import '../widgets/number_row.dart';

class BottleSheet extends StatelessWidget {
  const BottleSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottleController());

    return Obx(() => EventSheet(
      title: 'Bottle',
      onSubmit: controller.save,
      sections: [
        TimeRow(
          value: controller.time.value,
          onChange: (date) => controller.time.value = date,
        ),
        
        SegmentedRow(
          label: 'Feeding type',
          items: const ['Formula', 'Breast milk'],
          selected: () => controller.feedType.value == 'formula' ? 'Formula' : 'Breast milk',
          onSelect: controller.setFeedType,
        ),
        
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
        ),
      ],
    ));
  }
}
