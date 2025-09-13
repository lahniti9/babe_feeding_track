import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../controllers/bottle_entry_controller.dart';

class BottleEntryView extends StatelessWidget {
  const BottleEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottleEntryController());
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75, // Limit to 75% of screen height
      ),
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
          _buildHeader(),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  // Time selection
                  _buildTimeRow(controller),
                  
                  const SizedBox(height: AppSpacing.xxl),
                  
                  // Feeding type selection
                  _buildFeedingTypeRow(controller),
                  
                  const SizedBox(height: AppSpacing.xxl),
                  
                  // Amount picker
                  _buildAmountPicker(controller),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Text(
        'Bottle',
        style: AppTextStyles.titleMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTimeRow(BottleEntryController controller) {
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

  Widget _buildFeedingTypeRow(BottleEntryController controller) {
    return GestureDetector(
      onTap: controller.showFeedingTypeSelection,
      child: Row(
        children: [
          const Icon(Icons.local_drink, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.lg),
          Text('Feeding type', style: AppTextStyles.bodyMedium),
          const Spacer(),
          Obx(() => Text(
            controller.feedingType.value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
            ),
          )),
          const SizedBox(width: AppSpacing.xs),
          const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildAmountPicker(BottleEntryController controller) {
    return Column(
      children: [
        Text(
          'Amount',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        
        // Picker row
        SizedBox(
          height: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tens picker
              SizedBox(
                width: 60,
                child: CupertinoPicker(
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    controller.ozTens.value = index;
                  },
                  children: List.generate(10, (index) => Center(
                    child: Text(
                      index.toString(),
                      style: AppTextStyles.titleMedium,
                    ),
                  )),
                ),
              ),
              
              // Ones picker
              SizedBox(
                width: 60,
                child: CupertinoPicker(
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    controller.ozOnes.value = index;
                  },
                  children: List.generate(10, (index) => Center(
                    child: Text(
                      index.toString(),
                      style: AppTextStyles.titleMedium,
                    ),
                  )),
                ),
              ),
              
              // "oz" label
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  'oz',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              
              // Fractions picker
              SizedBox(
                width: 80,
                child: CupertinoPicker(
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    controller.fractionIndex.value = index;
                  },
                  children: controller.fractions.map((fraction) => Center(
                    child: Text(
                      fraction,
                      style: AppTextStyles.titleMedium,
                    ),
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: AppSpacing.lg),
        
        // Total display
        Obx(() => Text(
          '${controller.amountOz.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '')} oz',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        )),
      ],
    );
  }

  Widget _buildBottomButton(BottleEntryController controller) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Obx(() => GestureDetector(
          onTap: controller.isValid ? controller.save : null,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: controller.isValid 
                  ? AppColors.success 
                  : AppColors.textSecondary.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: controller.isValid 
                  ? Colors.white 
                  : AppColors.textCaption,
              size: 32,
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
