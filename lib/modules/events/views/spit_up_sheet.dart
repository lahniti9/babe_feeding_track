import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/spit_up_controller.dart';
import '../widgets/event_sheet.dart';
import '../widgets/time_row.dart';

import '../widgets/comment_row.dart';

class SpitUpSheet extends StatelessWidget {
  const SpitUpSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SpitUpController());

    return Obx(() => EventSheet(
      title: 'Spit-up',
      onSubmit: controller.save,
      sections: [
        TimeRow(
          value: controller.time.value,
          onChange: controller.setTime,
        ),
        
        _buildAmountChips(controller),

        _buildTypeChips(controller),
        
        CommentRow(
          value: controller.note.value,
          onChanged: controller.setNote,
        ),
      ],
    ));
  }

  Widget _buildAmountChips(SpitUpController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.water_drop,
                color: Color(0xFFD4AF37),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'AMOUNT',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Small', 'Medium', 'Large'].map((option) {
              final isSelected = controller.amount.value.toLowerCase() == option.toLowerCase();
              return GestureDetector(
                onTap: () => controller.setAmount(option),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF5B5B5B) : const Color(0xFF2E2E2E),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    option,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }

  Widget _buildTypeChips(SpitUpController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.palette,
                color: Color(0xFFD4AF37),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'TYPE',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Milk', 'Curdled', 'Greenish'].map((option) {
              final isSelected = controller.kind.value.toLowerCase() == option.toLowerCase();
              return GestureDetector(
                onTap: () => controller.setKind(option),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF5B5B5B) : const Color(0xFF2E2E2E),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    option,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String get capitalize => '${this[0].toUpperCase()}${substring(1)}';
}
