import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../../../core/theme/colors.dart';
import '../controllers/cry_controller.dart';
import '../models/cry_event.dart';
import '../widgets/modal_shell.dart';
import '../widgets/single_select_chips.dart';
import '../widgets/primary_pill.dart';

class CrySheet extends StatelessWidget {
  final CryEvent? existingEvent;

  const CrySheet({super.key, this.existingEvent});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CryController());

    // If we have an existing event, set up the controller for editing
    if (existingEvent != null) {
      controller.editEvent(existingEvent!);
    } else {
      controller.reset();
    }

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
            child: SingleSelectChips<CrySound>(
              options: CrySound.values,
              selected: controller.selectedSound,
              onTap: controller.selectSound,
              getDisplayName: (sound) => sound.displayName,
              accentColor: AppColors.coral,
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Volume section
          _buildSection(
            icon: Icons.graphic_eq,
            title: 'VOLUME',
            child: SingleSelectChips<CryVolume>(
              options: CryVolume.values,
              selected: controller.selectedVolume,
              onTap: controller.selectVolume,
              getDisplayName: (volume) => volume.displayName,
              accentColor: AppColors.coral,
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Rhythm section
          _buildSection(
            icon: Icons.waves,
            title: 'RHYTHM',
            child: SingleSelectChips<CryRhythm>(
              options: CryRhythm.values,
              selected: controller.selectedRhythm,
              onTap: controller.selectRhythm,
              getDisplayName: (rhythm) => rhythm.displayName,
              accentColor: AppColors.coral,
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Duration section
          _buildSection(
            icon: Icons.timer,
            title: 'DURATION',
            child: SingleSelectChips<CryDuration>(
              options: CryDuration.values,
              selected: controller.selectedDuration,
              onTap: controller.selectDuration,
              getDisplayName: (duration) => duration.displayName,
              accentColor: AppColors.coral,
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Behaviour section
          _buildSection(
            icon: Icons.face,
            title: 'BEHAVIOUR',
            child: SingleSelectChips<CryBehaviour>(
              options: CryBehaviour.values,
              selected: controller.selectedBehaviour,
              onTap: controller.selectBehaviour,
              getDisplayName: (behaviour) => behaviour.displayName,
              accentColor: AppColors.coral,
            ),
          ),

          const SizedBox(height: AppSpacing.xxxl),

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
