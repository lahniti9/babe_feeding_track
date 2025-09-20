import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/weight_controller.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
import '../widgets/big_number_wheel.dart';
import '../models/event_record.dart';
import '../models/event.dart';
import '../utils/event_colors.dart';

class WeightSheet extends StatelessWidget {
  final EventRecord? existingEvent;

  const WeightSheet({super.key, this.existingEvent});

  @override
  Widget build(BuildContext context) {
    print('WeightSheet: ${existingEvent != null ? 'Editing existing event' : 'Creating new event'}');

    // Ensure we get a fresh controller instance
    Get.delete<WeightController>();
    final controller = Get.put(WeightController());

    // If editing an existing event, populate the controller
    if (existingEvent != null) {
      controller.editEvent(existingEvent!);
    }

    final eventStyle = EventColors.getEventKindStyle(EventKind.weight);

    return Obx(() => EventSheet(
      title: 'Weight',
      subtitle: 'Track weight measurements',
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

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                eventStyle.color.withValues(alpha: 0.05),
                eventStyle.color.withValues(alpha: 0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: eventStyle.color.withValues(alpha: 0.2),
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
                      color: eventStyle.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.monitor_weight_rounded,
                      color: eventStyle.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'WEIGHT',
                    style: TextStyle(
                      color: eventStyle.color,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              BigNumberWheel(
                value: controller.value.value,
                unit: controller.unit.value,
                onChange: controller.setValue,
                onUnitChange: controller.setUnit,
                unitOptions: const ['kg', 'lb'],
                min: 0.0,
                max: 50.0,
                decimals: 2,
                accentColor: eventStyle.color,
              ),
            ],
          ),
        ),
      ],
    ));
  }


}
