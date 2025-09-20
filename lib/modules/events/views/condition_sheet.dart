import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/condition_controller.dart';
import '../models/event_record.dart';
import '../models/event.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
import '../widgets/enhanced_chip_group.dart';
import '../utils/event_colors.dart';

class ConditionSheet extends StatelessWidget {
  final EventRecord? existingEvent;

  const ConditionSheet({super.key, this.existingEvent});

  @override
  Widget build(BuildContext context) {
    // Ensure we get a fresh controller instance
    Get.delete<ConditionController>();
    final controller = Get.put(ConditionController());

    // If editing an existing event, populate the controller
    if (existingEvent != null) {
      controller.editEvent(existingEvent!);
    }

    final eventStyle = EventColors.getEventKindStyle(EventKind.condition);

    return Obx(() => EventSheet(
      title: 'Condition',
      subtitle: 'Track health and mood',
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
          label: 'Mood',
          options: const ['Happy', 'Calm', 'Fussy', 'Sleepy', 'Alert'],
          selected: controller.mood.value.capitalize!,
          onSelect: controller.setMood,
          icon: Icons.sentiment_satisfied_rounded,
          accentColor: eventStyle.color,
        ),

        EnhancedSegmentedControl(
          label: 'Severity',
          options: const ['Mild', 'Moderate', 'Severe'],
          selected: controller.severity.value.capitalize!,
          onSelect: controller.setSeverity,
          icon: Icons.warning_rounded,
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
