import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../controllers/bedtime_routine_controller.dart';

class BedtimeRoutineView extends StatelessWidget {
  const BedtimeRoutineView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BedtimeRoutineController());
    
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grabber
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.textSecondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          _buildHeader(controller),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time selection
                  _buildTimeRow(controller),
                  
                  const SizedBox(height: AppSpacing.xxl),
                  
                  // Info card
                  _buildInfoCard(),
                  
                  const SizedBox(height: AppSpacing.xxl),
                  
                  // Steps checklist
                  _buildStepsChecklist(controller),
                ],
              ),
            ),
          ),
          
          // Bottom button
          _buildBottomButton(controller),
        ],
      ),
    );
  }

  Widget _buildHeader(BedtimeRoutineController controller) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Text(
        'Bedtime routine',
        style: AppTextStyles.titleMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTimeRow(BedtimeRoutineController controller) {
    final dateFormat = DateFormat('MMM d');
    final timeFormat = DateFormat('HH:mm');
    
    return Row(
      children: [
        const Icon(Icons.access_time, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.lg),
        Text('Time', style: AppTextStyles.bodyMedium),
        const Spacer(),
        GestureDetector(
          onTap: () => _showDateTimePicker(
            Get.context!,
            controller.time.value,
            (time) => controller.setTime(time),
          ),
          child: Obx(() => Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardBackgroundSecondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  dateFormat.format(controller.time.value),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardBackgroundSecondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  timeFormat.format(controller.time.value),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          )),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Create the perfect bedtime routine',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(
                Icons.info_outline,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'A consistent bedtime routine helps your baby wind down and prepare for sleep. Select the activities you did tonight.',
            style: AppTextStyles.captionMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildStepsChecklist(BedtimeRoutineController controller) {
    return Column(
      children: controller.availableSteps.map((step) {
        return Obx(() => _buildStepTile(
          step: step,
          isSelected: controller.steps.contains(step),
          count: controller.steps.contains(step) 
              ? controller.steps.toList().indexOf(step) + 1 
              : null,
          onTap: () => controller.toggleStep(step),
        ));
      }).toList(),
    );
  }

  Widget _buildStepTile({
    required String step,
    required bool isSelected,
    required int? count,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    step,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (isSelected && count != null)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        count.toString(),
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.border,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(BedtimeRoutineController controller) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Obx(() => GestureDetector(
          onTap: controller.isValid ? controller.save : null,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            decoration: BoxDecoration(
              color: controller.isValid 
                  ? AppColors.success 
                  : AppColors.textSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              'Done',
              style: AppTextStyles.buttonText.copyWith(
                color: controller.isValid 
                    ? Colors.white 
                    : AppColors.textCaption,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )),
      ),
    );
  }

  void _showDateTimePicker(
    BuildContext context,
    DateTime initialTime,
    Function(DateTime) onTimeSelected,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: AppTextStyles.buttonTextSmall),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onTimeSelected(initialTime);
                  },
                  child: Text(
                    'Done',
                    style: AppTextStyles.buttonTextSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                initialDateTime: initialTime,
                onDateTimeChanged: (time) {
                  // Update the time as user scrolls
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
