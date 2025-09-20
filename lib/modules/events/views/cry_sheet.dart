import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/colors.dart';
import '../controllers/cry_controller.dart';
import '../models/cry_event.dart';
import '../models/event.dart';
import '../utils/event_colors.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
import '../widgets/single_select_chips.dart';

class CrySheet extends StatelessWidget {
  final CryEvent? existingEvent;

  const CrySheet({super.key, this.existingEvent});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CryController());
    final eventStyle = EventColors.getEventKindStyle(EventKind.cry);

    // If we have an existing event, set up the controller for editing
    if (existingEvent != null) {
      controller.editEvent(existingEvent!);
    } else {
      controller.reset();
    }

    return Obx(() => EventSheet(
      title: 'Cry',
      subtitle: 'Track crying episodes',
      icon: eventStyle.icon,
      accentColor: eventStyle.color,
      onSubmit: controller.save,
      sections: [
        EnhancedTimeRow(
          label: 'Time',
          value: controller.time.value,
          onChange: controller.setTime,
          icon: Icons.access_time_rounded,
          accentColor: eventStyle.color,
        ),

        // Sounds section
        _buildSection(
          icon: Icons.volume_up,
          title: 'SOUNDS',
          child: SingleSelectChips<CrySound>(
            options: CrySound.values,
            selected: controller.selectedSound,
            onTap: controller.selectSound,
            getDisplayName: (sound) => sound.displayName,
            accentColor: eventStyle.color,
          ),
        ),

        // Volume section
        _buildSection(
          icon: Icons.graphic_eq,
          title: 'VOLUME',
          child: SingleSelectChips<CryVolume>(
            options: CryVolume.values,
            selected: controller.selectedVolume,
            onTap: controller.selectVolume,
            getDisplayName: (volume) => volume.displayName,
            accentColor: eventStyle.color,
          ),
        ),

        // Rhythm section
        _buildSection(
          icon: Icons.waves,
          title: 'RHYTHM',
          child: SingleSelectChips<CryRhythm>(
            options: CryRhythm.values,
            selected: controller.selectedRhythm,
            onTap: controller.selectRhythm,
            getDisplayName: (rhythm) => rhythm.displayName,
            accentColor: eventStyle.color,
          ),
        ),

        // Duration section
        _buildSection(
          icon: Icons.timer,
          title: 'DURATION',
          child: SingleSelectChips<CryDuration>(
            options: CryDuration.values,
            selected: controller.selectedDuration,
            onTap: controller.selectDuration,
            getDisplayName: (duration) => duration.displayName,
            accentColor: eventStyle.color,
          ),
        ),

        // Behaviour section
        _buildSection(
          icon: Icons.face,
          title: 'BEHAVIOUR',
          child: SingleSelectChips<CryBehaviour>(
            options: CryBehaviour.values,
            selected: controller.selectedBehaviour,
            onTap: controller.selectBehaviour,
            getDisplayName: (behaviour) => behaviour.displayName,
            accentColor: eventStyle.color,
          ),
        ),
      ],
    ));
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
              style: const TextStyle(
                color: AppColors.coral,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
