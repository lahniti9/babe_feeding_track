import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/spit_up_controller.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
import '../widgets/enhanced_chip_group.dart';
import '../models/event_record.dart';
import '../models/event.dart';
import '../utils/event_colors.dart';

class SpitUpSheet extends StatelessWidget {
  final EventRecord? existingEvent;

  const SpitUpSheet({super.key, this.existingEvent});

  @override
  Widget build(BuildContext context) {
    print('SpitUpSheet: ${existingEvent != null ? 'Editing existing event with comment: ${existingEvent!.comment}' : 'Creating new event'}');

    // Ensure we get a fresh controller instance
    Get.delete<SpitUpController>();
    final controller = Get.put(SpitUpController());

    // If editing an existing event, populate the controller
    if (existingEvent != null) {
      controller.editEvent(existingEvent!);
    }

    final eventStyle = EventColors.getEventKindStyle(EventKind.spitUp);

    return Obx(() => EventSheet(
      title: 'Spit-up',
      subtitle: 'Track spit-up incidents',
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

        EnhancedSegmentedControl(
          label: 'Amount',
          options: const ['Small', 'Medium', 'Large'],
          selected: controller.amount.value.capitalizeFirst!,
          onSelect: controller.setAmount,
          icon: Icons.straighten_rounded,
          accentColor: eventStyle.color,
        ),

        EnhancedSegmentedControl(
          label: 'Type',
          options: const ['Milk', 'Food', 'Mixed'],
          selected: controller.kind.value.capitalizeFirst!,
          onSelect: controller.setKind,
          icon: Icons.category_rounded,
          accentColor: eventStyle.color,
        ),

        EnhancedCommentRow(
          label: 'Notes',
          value: controller.note.value,
          onChanged: controller.setNote,
          icon: Icons.note_rounded,
          accentColor: eventStyle.color,
          hint: 'Add any additional notes...',
        ),
      ],
    ));
  }
}
