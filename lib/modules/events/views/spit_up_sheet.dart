import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/spit_up_controller.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
import '../widgets/enhanced_chip_group.dart';

class SpitUpSheet extends StatelessWidget {
  const SpitUpSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SpitUpController());

    return Obx(() => EventSheet(
      title: 'Spit-up',
      subtitle: 'Track spit-up incidents',
      icon: Icons.water_drop_outlined,
      accentColor: const Color(0xFFF59E0B),
      onSubmit: controller.save,
      sections: [
        EnhancedTimeRow(
          label: 'Time',
          value: controller.time.value,
          onChange: controller.setTime,
          icon: Icons.access_time_rounded,
          accentColor: const Color(0xFFF59E0B),
        ),

        EnhancedSegmentedControl(
          label: 'Amount',
          options: const ['Small', 'Medium', 'Large'],
          selected: controller.amount.value.capitalizeFirst!,
          onSelect: controller.setAmount,
          icon: Icons.straighten_rounded,
          accentColor: const Color(0xFFF59E0B),
        ),

        EnhancedSegmentedControl(
          label: 'Type',
          options: const ['Milk', 'Food', 'Mixed'],
          selected: controller.kind.value.capitalizeFirst!,
          onSelect: controller.setKind,
          icon: Icons.category_rounded,
          accentColor: const Color(0xFFF59E0B),
        ),

        EnhancedCommentRow(
          label: 'Notes',
          value: controller.note.value,
          onChanged: controller.setNote,
          icon: Icons.note_rounded,
          accentColor: const Color(0xFFF59E0B),
          hint: 'Add any additional notes...',
        ),
      ],
    ));
  }
}
