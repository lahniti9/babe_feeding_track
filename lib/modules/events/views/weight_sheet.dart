import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/weight_controller.dart';
import '../widgets/event_sheet.dart';
import '../widgets/time_row.dart';
import '../widgets/big_number_wheel.dart';
import '../widgets/segmented_row.dart';
import '../../../core/theme/spacing.dart';

class WeightSheet extends StatelessWidget {
  const WeightSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WeightController());

    return Obx(() => EventSheet(
      title: 'Weight',
      onSubmit: controller.save,
      sections: [
        TimeRow(
          value: controller.time.value,
          onChange: controller.setTime,
        ),
        
        SegmentedRow(
          label: 'Unit',
          items: const ['lb/oz', 'kg'],
          selected: () => controller.unit.value,
          onSelect: controller.setUnit,
        ),
        
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
