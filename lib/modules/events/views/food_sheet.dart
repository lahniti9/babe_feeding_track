import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/food_controller.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
import '../widgets/enhanced_chip_group.dart';
import '../models/event_record.dart';
import '../models/event.dart';
import '../utils/event_colors.dart';

class FoodSheet extends StatelessWidget {
  final EventRecord? existingEvent;

  const FoodSheet({super.key, this.existingEvent});

  @override
  Widget build(BuildContext context) {
    print('FoodSheet: ${existingEvent != null ? 'Editing existing event' : 'Creating new event'}');

    // Ensure we get a fresh controller instance
    Get.delete<FoodController>();
    final controller = Get.put(FoodController());

    // If editing an existing event, populate the controller
    if (existingEvent != null) {
      controller.editEvent(existingEvent!);
    }

    final eventStyle = EventColors.getEventKindStyle(EventKind.food);

    return Obx(() => EventSheet(
      title: 'Food',
      subtitle: 'Track baby feeding',
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

        EnhancedCommentRow(
          label: 'Food',
          value: controller.food.value,
          onChanged: controller.setFood,
          icon: Icons.restaurant_rounded,
          accentColor: eventStyle.color,
          hint: 'Enter food name (e.g., Banana, Apple, Rice cereal)...',
        ),

        EnhancedSegmentedControl(
          label: 'Amount',
          options: const ['Taste', 'Few Spoons', 'Portion'],
          selected: _formatAmount(controller.amount.value),
          onSelect: controller.setAmount,
          icon: Icons.straighten_rounded,
          accentColor: eventStyle.color,
        ),

        EnhancedSegmentedControl(
          label: 'Reaction',
          options: const ['Liked', 'Rejected', 'Rash', 'Gas'],
          selected: controller.reaction.value.isEmpty ? '' : controller.reaction.value.capitalizeFirst!,
          onSelect: controller.setReaction,
          icon: Icons.sentiment_satisfied_rounded,
          accentColor: eventStyle.color,
        ),
      ],
    ));
  }



  String _formatAmount(String amount) {
    switch (amount) {
      case 'taste': return 'Taste';
      case 'few_spoons': return 'Few Spoons';
      case 'portion': return 'Portion';
      default: return amount.isNotEmpty ? '${amount[0].toUpperCase()}${amount.substring(1)}' : amount;
    }
  }
}

extension StringExtension on String {
  String get capitalize => '${this[0].toUpperCase()}${substring(1)}';
}
