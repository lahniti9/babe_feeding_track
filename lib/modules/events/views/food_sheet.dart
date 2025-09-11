import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/food_controller.dart';
import '../widgets/event_sheet.dart';
import '../widgets/time_row.dart';

import '../widgets/chips_with_text_row.dart';

class FoodSheet extends StatelessWidget {
  const FoodSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FoodController());

    return Obx(() => EventSheet(
      title: 'Food',
      onSubmit: controller.save,
      sections: [
        TimeRow(
          value: controller.time.value,
          onChange: controller.setTime,
        ),
        
        ChipsWithTextRow(
          label: 'Food',
          suggestions: const ['Banana', 'Apple', 'Avocado', 'Carrot', 'Oat'],
          value: controller.food.value,
          onChanged: controller.setFood,
        ),
        
        _buildAmountChips(controller),

        _buildReactionChips(controller),
      ],
    ));
  }

  Widget _buildAmountChips(FoodController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.restaurant,
                color: Color(0xFFFFB03A),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'AMOUNT',
                style: TextStyle(
                  color: Color(0xFFFFB03A),
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
            children: ['Taste', 'Few spoons', 'Portion'].map((option) {
              final isSelected = _formatAmount(controller.amount.value) == option;
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

  Widget _buildReactionChips(FoodController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.sentiment_satisfied,
                color: Color(0xFFFFB03A),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'REACTION',
                style: TextStyle(
                  color: Color(0xFFFFB03A),
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
            children: ['Liked', 'Rejected', 'Rash', 'Gas'].map((option) {
              final isSelected = controller.reaction.contains(option.toLowerCase());
              return GestureDetector(
                onTap: () => controller.toggleReaction(option),
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

  String _formatAmount(String amount) {
    switch (amount) {
      case 'taste': return 'Taste';
      case 'few_spoons': return 'Few spoons';
      case 'portion': return 'Portion';
      default: return amount.isNotEmpty ? '${amount[0].toUpperCase()}${amount.substring(1)}' : amount;
    }
  }
}

extension StringExtension on String {
  String get capitalize => '${this[0].toUpperCase()}${substring(1)}';
}
