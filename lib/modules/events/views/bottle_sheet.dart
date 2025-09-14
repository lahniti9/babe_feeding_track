import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottle_controller.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
import '../widgets/enhanced_chip_group.dart';
import '../widgets/number_row.dart';

class BottleSheet extends StatelessWidget {
  const BottleSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottleController());

    return Obx(() => EventSheet(
      title: 'Bottle',
      subtitle: 'Track bottle feeding',
      icon: Icons.baby_changing_station_rounded,
      accentColor: const Color(0xFF3B82F6),
      onSubmit: controller.save,
      sections: [
        EnhancedTimeRow(
          label: 'Time',
          value: controller.time.value,
          onChange: (date) => controller.time.value = date,
          icon: Icons.access_time_rounded,
          accentColor: const Color(0xFF3B82F6),
        ),

        EnhancedSegmentedControl(
          label: 'Feeding type',
          options: const ['Formula', 'Breast milk'],
          selected: controller.feedType.value == 'formula' ? 'Formula' : 'Breast milk',
          onSelect: controller.setFeedType,
          icon: Icons.local_drink_rounded,
          accentColor: const Color(0xFF3B82F6),
        ),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF3B82F6).withValues(alpha: 0.05),
                const Color(0xFF3B82F6).withValues(alpha: 0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
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
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.water_drop_rounded,
                      color: Color(0xFF3B82F6),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'VOLUME',
                    style: TextStyle(
                      color: Color(0xFF3B82F6),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              NumberRow(
                label: 'Volume',
                value: controller.volume.value,
                unit: controller.unit.value,
                onChange: controller.setVolume,
                onUnitChange: controller.setUnit,
                unitOptions: const ['oz', 'ml'],
                min: 0,
                max: 500,
                decimals: 1,
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
