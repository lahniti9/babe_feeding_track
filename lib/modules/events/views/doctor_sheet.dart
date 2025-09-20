import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_controller.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
import '../widgets/chip_group_row.dart';
import '../models/event_record.dart';
import '../models/event.dart';
import '../utils/event_colors.dart';

class DoctorSheet extends StatelessWidget {
  final EventRecord? existingEvent;

  const DoctorSheet({super.key, this.existingEvent});

  @override
  Widget build(BuildContext context) {
    // Ensure we get a fresh controller instance
    Get.delete<DoctorController>();
    final controller = Get.put(DoctorController());

    // If editing an existing event, populate the controller
    if (existingEvent != null) {
      controller.editEvent(existingEvent!);
    }

    final eventStyle = EventColors.getEventKindStyle(EventKind.doctor);

    return Obx(() => EventSheet(
      title: 'Doctor',
      subtitle: 'Track medical visits',
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
                      Icons.local_hospital_rounded,
                      color: eventStyle.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'DOCTOR VISIT',
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

              ChipGroupRow(
                label: 'Reason',
                options: const ['Routine', 'Vaccination', 'Symptoms check', 'Follow-up', 'Other'],
                selected: controller.reason,
                multi: true,
                icon: Icons.local_hospital,
                iconColor: eventStyle.color,
              ),

              const SizedBox(height: 16),

              ChipGroupRow(
                label: 'Outcome',
                options: const ['All good', 'Medication', 'Tests ordered', 'Referral'],
                selected: controller.outcome,
                multi: true,
                icon: Icons.assignment_turned_in,
                iconColor: eventStyle.color,
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
