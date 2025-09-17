import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/expressing_controller.dart';
import '../widgets/event_sheet_scaffold.dart';
import '../widgets/time_row.dart';
import '../widgets/timer_circle.dart';
import '../widgets/single_select_chips.dart';

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
          SingleSelectChips<ExpressingSide>(
            options: ExpressingSide.values,
            selected: controller.side,
            onTap: controller.setSide,
            getDisplayName: (side) => side.displayName,
            accentColor: const Color(0xFFE14E63),
          ),
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
          SingleSelectChips<ExpressingMethod>(
            options: ExpressingMethod.values,
            selected: controller.method,
            onTap: controller.setMethod,
            getDisplayName: (method) => method.displayName,
            accentColor: const Color(0xFFE14E63),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String get capitalize => '${this[0].toUpperCase()}${substring(1)}';
}
