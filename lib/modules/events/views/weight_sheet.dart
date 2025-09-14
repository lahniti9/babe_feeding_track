import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/weight_controller.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
import '../widgets/enhanced_chip_group.dart';
import '../widgets/big_number_wheel.dart';
import '../../../core/theme/spacing.dart';

class WeightSheet extends StatelessWidget {
  const WeightSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WeightController());

    return Obx(() => EventSheet(
      title: 'Weight',
      subtitle: 'Track weight measurements',
      icon: Icons.monitor_weight_rounded,
      accentColor: const Color(0xFF10B981),
      onSubmit: controller.save,
      sections: [
        EnhancedTimeRow(
          label: 'Time',
          value: controller.time.value,
          onChange: controller.setTime,
          icon: Icons.access_time_rounded,
          accentColor: const Color(0xFF10B981),
        ),

        EnhancedSegmentedControl(
          label: 'Unit',
          options: const ['lb/oz', 'kg'],
          selected: controller.unit.value,
          onSelect: controller.setUnit,
          icon: Icons.straighten_rounded,
          accentColor: const Color(0xFF10B981),
        ),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF10B981).withValues(alpha: 0.05),
                const Color(0xFF10B981).withValues(alpha: 0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF10B981).withValues(alpha: 0.2),
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
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.monitor_weight_rounded,
                      color: Color(0xFF10B981),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'WEIGHT',
                    style: TextStyle(
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (controller.isMetric.value)
                BigNumberWheel(
                  value: controller.value.value,
                  unit: 'kg',
                  onChange: controller.setValue,
                  min: 0.0,
                  max: 50.0,
                  decimals: 2,
                )
              else
                _buildPoundsOuncesWheel(controller),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _buildPoundsOuncesWheel(WeightController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pounds
          Column(
            children: [
              const Text(
                'lb',
                style: TextStyle(
                  color: Color(0xFFFF8A00),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 80,
                height: 120,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 40,
                  perspective: 0.005,
                  diameterRatio: 1.2,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) => controller.setPounds(index),
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: 25,
                    builder: (context, index) => Center(
                      child: Text(
                        '$index',
                        style: TextStyle(
                          color: index == controller.pounds.value 
                            ? Colors.white 
                            : const Color(0xFF5B5B5B),
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(width: 40),
          
          // Ounces
          Column(
            children: [
              const Text(
                'oz',
                style: TextStyle(
                  color: Color(0xFFFF8A00),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 80,
                height: 120,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 40,
                  perspective: 0.005,
                  diameterRatio: 1.2,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) => controller.setOunces(index),
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: 16,
                    builder: (context, index) => Center(
                      child: Text(
                        '$index',
                        style: TextStyle(
                          color: index == controller.ounces.value 
                            ? Colors.white 
                            : const Color(0xFF5B5B5B),
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
