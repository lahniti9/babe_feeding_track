import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_controller.dart';
import '../widgets/event_sheet.dart';
import '../widgets/time_row.dart';
import '../widgets/chip_group_row.dart';

class DoctorSheet extends StatelessWidget {
  const DoctorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DoctorController());

    return Obx(() => EventSheet(
      title: 'Doctor',
      onSubmit: controller.save,
      sections: [
        TimeRow(
          value: controller.time.value,
          onChange: controller.setTime,
        ),
        
        ChipGroupRow(
          label: 'Reason',
          options: const ['Routine', 'Vaccination', 'Symptoms check', 'Follow-up', 'Other'],
          selected: controller.reason,
          multi: true,
          icon: Icons.local_hospital,
          iconColor: const Color(0xFF6F86FF),
        ),
        
        ChipGroupRow(
          label: 'Outcome',
          options: const ['All good', 'Medication', 'Tests ordered', 'Referral'],
          selected: controller.outcome,
          multi: true,
          icon: Icons.assignment_turned_in,
          iconColor: const Color(0xFF6F86FF),
        ),
      ],
    ));
  }
}
