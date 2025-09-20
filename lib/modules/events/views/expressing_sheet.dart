import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/expressing_controller.dart';
import '../models/event.dart';
import '../utils/event_colors.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
import '../widgets/timer_circle.dart';
import '../widgets/single_select_chips.dart';
import '../../../core/theme/spacing.dart';

class ExpressingSheet extends StatelessWidget {
  const ExpressingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExpressingController());
    final eventStyle = EventColors.getEventKindStyle(EventKind.expressing);

    return Obx(() => EventSheet(
      title: 'Expressing',
      subtitle: 'Track expressing sessions',
      icon: eventStyle.icon,
      accentColor: eventStyle.color,
      onSubmit: controller.completeFlow,
      sections: [
        EnhancedTimeRow(
          label: 'Time',
          value: controller.time.value,
          onChange: controller.setTime,
          icon: Icons.access_time_rounded,
          accentColor: eventStyle.color,
        ),

        // Timer section
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
            children: [
              // Timer circle
              TimerCircle(
                isRunning: controller.running.value,
                timeText: controller.timeText,
                onToggle: controller.toggleTimer,
                gradientStart: eventStyle.color,
                gradientEnd: eventStyle.color.withValues(alpha: 0.8),
              ),

              const SizedBox(height: AppSpacing.xl),

              _buildSideChips(controller, eventStyle),

              _buildMethodChips(controller, eventStyle),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _buildSideChips(ExpressingController controller, ({Color color, IconData icon}) eventStyle) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.pregnant_woman,
                color: eventStyle.color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'SIDE',
                style: TextStyle(
                  color: eventStyle.color,
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
            accentColor: eventStyle.color,
          ),
        ],
      ),
    );
  }

  Widget _buildMethodChips(ExpressingController controller, ({Color color, IconData icon}) eventStyle) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.settings,
                color: eventStyle.color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'METHOD',
                style: TextStyle(
                  color: eventStyle.color,
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
            accentColor: eventStyle.color,
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String get capitalize => '${this[0].toUpperCase()}${substring(1)}';
}
