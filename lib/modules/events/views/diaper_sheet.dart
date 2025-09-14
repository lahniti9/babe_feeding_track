import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/diaper_controller.dart';
import '../models/event_record.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
import '../widgets/enhanced_chip_group.dart';

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
      subtitle: 'Track diaper changes',
      icon: Icons.child_care_rounded,
      accentColor: const Color(0xFF8B5CF6),
      onSubmit: controller.save,
      sections: [
        EnhancedTimeRow(
          label: 'Time',
          value: controller.time.value,
          onChange: (date) => controller.time.value = date,
          icon: Icons.access_time_rounded,
          accentColor: const Color(0xFF8B5CF6),
        ),

        EnhancedSegmentedControl(
          label: 'Type',
          options: const ['Pee', 'Poop', 'Mixed'],
          selected: controller.kind.value.capitalize!,
          onSelect: controller.setKind,
          icon: Icons.category_rounded,
          accentColor: const Color(0xFF8B5CF6),
        ),

        if (controller.kind.value == 'poop' || controller.kind.value == 'mixed')
          EnhancedChipGroup(
            label: 'Poop Color',
            options: const ['Yellow', 'Green', 'Brown'],
            selected: controller.color,
            multiSelect: true,
            icon: Icons.palette_rounded,
            accentColor: const Color(0xFF8B5CF6),
            onTap: (option) => controller.color.contains(option)
              ? controller.color.remove(option)
              : controller.color.add(option),
          ),

        if (controller.kind.value == 'poop' || controller.kind.value == 'mixed')
          EnhancedChipGroup(
            label: 'Consistency',
            options: const ['Loose', 'Normal', 'Firm'],
            selected: controller.consistency,
            multiSelect: true,
            icon: Icons.texture_rounded,
            accentColor: const Color(0xFF8B5CF6),
            onTap: (option) => controller.consistency.contains(option)
              ? controller.consistency.remove(option)
              : controller.consistency.add(option),
          ),
      ],
    ));
  }
}
