import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/condition_controller.dart';
import '../widgets/event_sheet.dart';
import '../widgets/time_row.dart';
import '../widgets/comment_row.dart';

class ConditionSheet extends StatelessWidget {
  const ConditionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConditionController());

    return Obx(() => EventSheet(
      title: 'Condition',
      onSubmit: controller.save,
      sections: [
        TimeRow(
          value: controller.time.value,
          onChange: controller.setTime,
        ),
        
        _buildMoodChips(controller),
        
        _buildSeverityChips(controller),
        
        CommentRow(
          value: controller.note.value,
          onChanged: controller.setNote,
        ),
      ],
    ));
  }

  Widget _buildMoodChips(ConditionController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.sentiment_satisfied,
                color: Color(0xFF3BB3C4),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'MOOD',
                style: TextStyle(
                  color: Color(0xFF3BB3C4),
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
            children: [
              'Laughing', 'Calm', 'Fussy', 'Crying', 'Anxious', 
              'Irritable', 'Sleepy', 'Hungry', 'Gassy', 'Colic', 'Teething'
            ].map((option) {
              final isSelected = controller.moods.contains(option.toLowerCase());
              return GestureDetector(
                onTap: () => controller.toggleMood(option),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF5B5B5B) : const Color(0xFF2E2E2E),
                    borderRadius: BorderRadius.circular(14),
                    border: isSelected 
                      ? Border.all(color: const Color(0xFF5B5B5B).withOpacity(0.5), width: 1)
                      : null,
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

  Widget _buildSeverityChips(ConditionController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.priority_high,
                color: Color(0xFF3BB3C4),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'SEVERITY',
                style: TextStyle(
                  color: Color(0xFF3BB3C4),
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
            children: ['Mild', 'Moderate', 'Severe'].map((option) {
              final isSelected = controller.severity.value.toLowerCase() == option.toLowerCase();
              return GestureDetector(
                onTap: () => controller.setSeverity(option),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF5B5B5B) : const Color(0xFF2E2E2E),
                    borderRadius: BorderRadius.circular(14),
                    border: isSelected 
                      ? Border.all(color: const Color(0xFF5B5B5B).withOpacity(0.5), width: 1)
                      : null,
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
