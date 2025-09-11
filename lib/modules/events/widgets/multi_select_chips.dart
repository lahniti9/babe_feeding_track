import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultiSelectChips<T> extends StatelessWidget {
  final List<T> options;
  final RxSet<T> selectedSet;
  final Function(T) onTap;
  final String Function(T) getDisplayName;

  const MultiSelectChips({
    super.key,
    required this.options,
    required this.selectedSet,
    required this.onTap,
    required this.getDisplayName,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selectedSet.contains(option);
        return GestureDetector(
          onTap: () => onTap(option),
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
              getDisplayName(option),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        );
      }).toList(),
    ));
  }
}
