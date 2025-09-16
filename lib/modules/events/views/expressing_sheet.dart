import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/expressing_controller.dart';
import '../widgets/event_sheet_scaffold.dart';
import '../widgets/time_row.dart';
import '../widgets/timer_circle.dart';

import '../widgets/primary_pill.dart';
import '../../../core/theme/spacing.dart';

class ExpressingSheet extends StatelessWidget {
  const ExpressingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExpressingController());

    return EventSheetScaffold(
      title: 'Expressing',
      child: Obx(() => Column(
        children: [
          TimeRow(
            value: controller.time.value,
            onChange: controller.setTime,
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Timer circle
          TimerCircle(
            isRunning: controller.running.value,
            timeText: controller.timeText,
            onToggle: controller.toggleTimer,
            gradientStart: const Color(0xFFE14E63),
            gradientEnd: const Color(0xFFB71C1C),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          _buildSideChips(controller),

          _buildMethodChips(controller),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Bottom controls
          Row(
            children: [
              // Reset button
              GestureDetector(
                onTap: controller.resetTimer,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E2E2E),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              // Complete button
              Expanded(
                child: PrimaryPill(
                  label: 'Done',
                  icon: Icons.check,
                  onTap: controller.completeFlow,
                  enabled: controller.elapsed.value > 0,
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }

  Widget _buildSideChips(ExpressingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.pregnant_woman,
                color: Color(0xFFE14E63),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'SIDE',
                style: TextStyle(
                  color: const Color(0xFFE14E63),
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
            children: ['Left', 'Right', 'Both'].map((option) {
              final isSelected = controller.side.value.toLowerCase() == option.toLowerCase();
              return GestureDetector(
                onTap: () => controller.setSide(option),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF5B5B5B) : const Color(0xFF2E2E2E),
                    borderRadius: BorderRadius.circular(14),
                    border: isSelected
                      ? Border.all(color: const Color(0xFF5B5B5B).withValues(alpha: 0.5), width: 1)
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

  Widget _buildMethodChips(ExpressingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.settings,
                color: Color(0xFFE14E63),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'METHOD',
                style: TextStyle(
                  color: const Color(0xFFE14E63),
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
            children: ['Manual', 'Electric'].map((option) {
              final isSelected = controller.method.value.toLowerCase() == option.toLowerCase();
              return GestureDetector(
                onTap: () => controller.setMethod(option),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF5B5B5B) : const Color(0xFF2E2E2E),
                    borderRadius: BorderRadius.circular(14),
                    border: isSelected
                      ? Border.all(color: const Color(0xFF5B5B5B).withValues(alpha: 0.5), width: 1)
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

extension StringExtension on String {
  String get capitalize => '${this[0].toUpperCase()}${substring(1)}';
}
