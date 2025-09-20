import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/expressing_controller.dart';
import '../models/event.dart';
import '../utils/event_colors.dart';
import '../widgets/event_sheet_scaffold.dart';
import '../../../core/theme/spacing.dart';

class ExpressingVolumeSheet extends StatelessWidget {
  final ExpressingController controller;

  const ExpressingVolumeSheet({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final eventStyle = EventColors.getEventKindStyle(EventKind.expressing);

    return EventSheetScaffold(
      title: 'Expressing completed',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          
          const Text(
            'Add volume?',
            style: TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 40),

          // Volume input
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              SizedBox(
                width: 100,
                child: Obx(() => TextField(
                  controller: TextEditingController(text: controller.volume.value.toString()),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: eventStyle.color),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: eventStyle.color),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: eventStyle.color, width: 2),
                    ),
                    hintText: '0',
                    hintStyle: const TextStyle(
                      color: Color(0xFF5B5B5B),
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onChanged: (text) {
                    final volume = int.tryParse(text) ?? 0;
                    controller.volume.value = volume;
                  },
                )),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _showUnitPicker(context, eventStyle),
                child: Obx(() => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E2E2E),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: eventStyle.color),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.unit.value,
                        style: TextStyle(
                          color: eventStyle.color,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: eventStyle.color,
                        size: 16,
                      ),
                    ],
                  ),
                )),
              ),
            ],
          ),

          const SizedBox(height: 60),

          // Buttons
          Row(
            children: [
              // Skip button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.back(result: null);
                    controller.save(withVolume: false);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E2E2E),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Add button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.back(result: controller.volume.value);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: eventStyle.color,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showUnitPicker(BuildContext context, ({Color color, IconData icon}) eventStyle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF151515),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Unit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ...['ml', 'oz'].map((option) => ListTile(
              title: Text(
                option,
                style: TextStyle(
                  color: option == controller.unit.value ? eventStyle.color : Colors.white,
                  fontWeight: option == controller.unit.value ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              onTap: () {
                controller.unit.value = option;
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }
}
