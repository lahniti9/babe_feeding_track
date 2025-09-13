import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/diaper_controller.dart';
import '../models/event_record.dart';
import '../widgets/event_sheet.dart';
import '../widgets/time_row.dart';
import '../widgets/segmented_row.dart';
import '../widgets/chip_group_row.dart';

class DiaperSheet extends StatelessWidget {
  final EventRecord? existingEvent;

  const DiaperSheet({super.key, this.existingEvent});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DiaperController());

    // If editing an existing event, populate the controller
    if (existingEvent != null) {
      controller.editEvent(existingEvent!);
    }

    return Obx(() => EventSheet(
      title: 'Diaper',
      onSubmit: controller.save,
      sections: [
        TimeRow(
          value: controller.time.value,
          onChange: (date) => controller.time.value = date,
        ),
        
        SegmentedRow(
          label: 'Type',
          items: const ['Pee', 'Poop', 'Mixed'],
          selected: () => controller.kind.value.capitalize!,
          onSelect: controller.setKind,
        ),
        
        if (controller.kind.value == 'poop' || controller.kind.value == 'mixed')
          ChipGroupRow(
            label: 'Poop Color',
            options: const ['Yellow', 'Green', 'Brown'],
            selected: controller.color,
            multi: true,
            icon: Icons.palette,
            iconColor: const Color(0xFF9C6F63),
          ),
        
        if (controller.kind.value == 'poop' || controller.kind.value == 'mixed')
          ChipGroupRow(
            label: 'Consistency',
            options: const ['Loose', 'Normal', 'Firm'],
            selected: controller.consistency,
            multi: true,
            icon: Icons.texture,
            iconColor: const Color(0xFF9C6F63),
          ),
      ],
    ));
  }
}
