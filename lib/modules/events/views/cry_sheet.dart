import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../../../core/theme/colors.dart';
import '../controllers/cry_controller.dart';
import '../models/cry_event.dart';
import '../widgets/modal_shell.dart';
import '../widgets/multi_select_chips.dart';
import '../widgets/primary_pill.dart';

class CrySheet extends StatelessWidget {
  const CrySheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CryController());

    return ModalShell(
      title: 'Cry',
      right: GestureDetector(
        onTap: () => _showTimePicker(context, controller),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE14E63).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE14E63).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Obx(() => Text(
            DateFormat('MMM d, HH:mm').format(controller.time.value),
            style: const TextStyle(
              color: Color(0xFFE14E63),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          )),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sounds section
          _buildSection(
            icon: Icons.volume_up,
            title: 'SOUNDS',
            child: MultiSelectChips<CrySound>(
              options: CrySound.values,
              selectedSet: controller.sounds,
              onTap: controller.toggleSound,
              getDisplayName: (sound) => sound.displayName,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Volume section
          _buildSection(
            icon: Icons.graphic_eq,
            title: 'VOLUME',
            child: MultiSelectChips<CryVolume>(
              options: CryVolume.values,
              selectedSet: controller.volumes,
              onTap: controller.toggleVolume,
              getDisplayName: (volume) => volume.displayName,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Rhythm section
          _buildSection(
            icon: Icons.waves,
            title: 'RHYTHM',
            child: MultiSelectChips<CryRhythm>(
              options: CryRhythm.values,
              selectedSet: controller.rhythms,
              onTap: controller.toggleRhythm,
              getDisplayName: (rhythm) => rhythm.displayName,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Duration section
          _buildSection(
            icon: Icons.timer,
            title: 'DURATION',
            child: MultiSelectChips<CryDuration>(
              options: CryDuration.values,
              selectedSet: controller.durations,
              onTap: controller.toggleDuration,
              getDisplayName: (duration) => duration.displayName,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Behaviour section
          _buildSection(
            icon: Icons.face,
            title: 'BEHAVIOUR',
            child: MultiSelectChips<CryBehaviour>(
              options: CryBehaviour.values,
              selectedSet: controller.behaviours,
              onTap: controller.toggleBehaviour,
              getDisplayName: (behaviour) => behaviour.displayName,
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Done button
          PrimaryPill(
            label: 'Done',
            icon: Icons.check,
            onTap: controller.save,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.coral,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTextStyles.captionMedium.copyWith(
                color: AppColors.coral,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  void _showTimePicker(BuildContext context, CryController controller) {
    showDatePicker(
      context: context,
      initialDate: controller.time.value,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(controller.time.value),
        ).then((time) {
          if (time != null) {
            final newDateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            controller.setTime(newDateTime);
          }
        });
      }
    });
  }
}
