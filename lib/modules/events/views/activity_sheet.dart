import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/activity_controller.dart';
import '../widgets/event_sheet_scaffold.dart';
import '../widgets/time_row.dart';
import '../widgets/timer_circle.dart';
import '../widgets/comment_row.dart';
import '../widgets/primary_pill.dart';
import '../../../core/theme/spacing.dart';

class ActivitySheet extends StatelessWidget {
  const ActivitySheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ActivityController());

    return EventSheetScaffold(
      title: 'Activity',
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
            onToggle: controller.toggle,
            gradientStart: const Color(0xFFFFB03A),
            gradientEnd: const Color(0xFFFF8A00),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          _buildTypeChips(controller),
          
          _buildIntensityChips(controller),
          
          CommentRow(
            value: controller.note.value,
            onChanged: controller.setNote,
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Bottom controls
          Row(
            children: [
              // Reset button
              GestureDetector(
                onTap: controller.reset,
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
                  label: controller.timeText,
                  icon: Icons.check,
                  onTap: controller.save,
                  enabled: controller.elapsed.value > 0,
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              // Bell button
              GestureDetector(
                onTap: () {
                  // TODO: Implement reminder functionality
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E2E2E),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }

  Widget _buildTypeChips(ActivityController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.toys,
                color: Color(0xFF2AC06A),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'TYPE',
                style: TextStyle(
                  color: Color(0xFF2AC06A),
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
              'Tummy time', 'Play mat', 'Reading', 'Music', 
              'Baby gym', 'Outdoor walk', 'Massage', 'Free play'
            ].map((option) {
              final isSelected = controller.typeDisplayName == option;
              return GestureDetector(
                onTap: () => controller.setType(option),
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

  Widget _buildIntensityChips(ActivityController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.speed,
                color: Color(0xFF2AC06A),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'INTENSITY',
                style: TextStyle(
                  color: Color(0xFF2AC06A),
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
            children: ['Low', 'Moderate', 'High'].map((option) {
              final isSelected = controller.intensity.value.toLowerCase() == option.toLowerCase();
              return GestureDetector(
                onTap: () => controller.setIntensity(option),
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
