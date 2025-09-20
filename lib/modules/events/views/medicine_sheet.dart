import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/medicine_controller.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
import '../widgets/number_row.dart';
import '../widgets/chip_group_row.dart';
import '../models/event_record.dart';
import '../models/event.dart';
import '../utils/event_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';

class MedicineSheet extends StatelessWidget {
  final EventRecord? existingEvent;

  const MedicineSheet({super.key, this.existingEvent});

  @override
  Widget build(BuildContext context) {
    // Ensure we get a fresh controller instance
    Get.delete<MedicineController>();
    final controller = Get.put(MedicineController());

    // If editing an existing event, populate the controller
    if (existingEvent != null) {
      controller.editEvent(existingEvent!);
    }

    final eventStyle = EventColors.getEventKindStyle(EventKind.medicine);

    return Obx(() => EventSheet(
      title: 'Medicine',
      subtitle: 'Track medication doses',
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
        
        // Medicine name input
        Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Medicine',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E2E2E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter medicine name',
                    hintStyle: TextStyle(color: Color(0xFF5B5B5B)),
                  ),
                  onChanged: controller.setMedicineName,
                ),
              ),
            ],
          ),
        ),
        
        NumberRow(
          label: 'Dose',
          value: controller.dose.value,
          unit: controller.doseUnit.value,
          onChange: controller.setDose,
          onUnitChange: controller.setDoseUnit,
          unitOptions: const ['ml', 'mg', 'drops'],
          min: 0,
          max: 100,
          decimals: 1,
          accentColor: eventStyle.color,
        ),
        
        ChipGroupRow(
          label: 'Reason',
          options: const ['Fever', 'Pain', 'Cough', 'Allergy', 'Other'],
          selected: controller.reason,
          multi: true,
          icon: Icons.medication_outlined,
          iconColor: eventStyle.color,
        ),
        
        // Reminder toggle
        Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.lg),
          child: Row(
            children: [
              Icon(
                Icons.notifications_outlined,
                color: eventStyle.color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Reminder',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Switch(
                value: controller.reminderEnabled.value,
                onChanged: (_) => controller.toggleReminder(),
                activeColor: eventStyle.color,
              ),
            ],
          ),
        ),
        
        if (controller.reminderEnabled.value)
          EnhancedTimeRow(
            label: 'Reminder Time',
            value: controller.reminderTime.value,
            onChange: controller.setReminderTime,
            icon: Icons.alarm_rounded,
            accentColor: eventStyle.color,
          ),
      ],
    ));
  }
}
