import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../models/event.dart';
import 'events_controller.dart';

class BottleEntryController extends GetxController {
  // Time selection
  final Rx<DateTime> time = DateTime.now().obs;
  
  // Feeding type
  final RxString feedingType = "Formula".obs;
  final List<String> feedingTypes = ["Formula", "Breast milk", "Mixed"];
  
  // Amount selection
  final RxInt ozTens = 0.obs;
  final RxInt ozOnes = 0.obs;
  final RxInt fractionIndex = 0.obs;
  
  // Fraction options
  final List<String> fractions = ["0", "1/4", "1/2", "3/4"];
  final List<double> fractionValues = [0, 0.25, 0.5, 0.75];
  
  // Edit mode
  final RxBool isEditMode = false.obs;
  String? editingEventId;

  // Get total amount in oz
  double get amountOz {
    return (ozTens.value * 10 + ozOnes.value) + fractionValues[fractionIndex.value];
  }

  // Set time
  void setTime(DateTime newTime) {
    time.value = newTime;
  }

  // Set feeding type
  void setFeedingType(String type) {
    feedingType.value = type;
  }

  // Set amount from double value
  void setAmount(double amount) {
    final wholeOz = amount.floor();
    ozTens.value = wholeOz ~/ 10;
    ozOnes.value = wholeOz % 10;
    
    final fraction = amount - wholeOz;
    fractionIndex.value = fractionValues.indexWhere((f) => (f - fraction).abs() < 0.01);
    if (fractionIndex.value == -1) fractionIndex.value = 0;
  }

  // Save bottle entry
  void save() {
    if (amountOz <= 0) return;
    
    final event = EventModel(
      id: editingEventId ?? 'event_${DateTime.now().millisecondsSinceEpoch}',
      kind: EventKind.bottle,
      time: time.value,
      title: 'Bottle',
      subtitle: '${amountOz.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '')} oz • $feedingType',
      tags: [],
      showPlus: false,
    );
    
    final eventsController = Get.find<EventsController>();
    if (isEditMode.value && editingEventId != null) {
      // Update existing event
      eventsController.remove(editingEventId!);
    }
    eventsController.addEvent(event);
    
    Get.back();
    _reset();
  }

  // Edit existing event
  void editEvent(EventModel event) {
    isEditMode.value = true;
    editingEventId = event.id;
    time.value = event.time;
    
    // Parse amount and feeding type from subtitle
    if (event.subtitle != null) {
      final parts = event.subtitle!.split(' • ');
      if (parts.length >= 2) {
        // Parse amount
        final amountStr = parts[0].replaceAll(' oz', '');
        final amount = double.tryParse(amountStr) ?? 0;
        setAmount(amount);
        
        // Parse feeding type
        feedingType.value = parts[1];
      }
    }
  }

  // Reset state
  void _reset() {
    isEditMode.value = false;
    editingEventId = null;
    time.value = DateTime.now();
    feedingType.value = "Formula";
    ozTens.value = 0;
    ozOnes.value = 0;
    fractionIndex.value = 0;
  }

  // Check if form is valid
  bool get isValid {
    return amountOz > 0;
  }

  // Show feeding type selection
  void showFeedingTypeSelection() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'Feeding Type',
                style: AppTextStyles.titleMedium,
              ),
            ),
            ...feedingTypes.map((type) => ListTile(
              title: Text(type, style: AppTextStyles.bodyMedium),
              trailing: feedingType.value == type 
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                setFeedingType(type);
                Get.back();
              },
            )),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
