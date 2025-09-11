import 'package:flutter/material.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../../../core/theme/colors.dart';

class SegmentedRow extends StatelessWidget {
  final String label;
  final List<String> items;
  final String Function() selected;
  final Function(String) onSelect;

  const SegmentedRow({
    super.key,
    required this.label,
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2E2E2E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: items.map((item) {
                final isSelected = selected() == item;
                final isFirst = items.first == item;
                final isLast = items.last == item;
                
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onSelect(item),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.coral : Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isFirst ? 12 : 0),
                          bottomLeft: Radius.circular(isFirst ? 12 : 0),
                          topRight: Radius.circular(isLast ? 12 : 0),
                          bottomRight: Radius.circular(isLast ? 12 : 0),
                        ),
                      ),
                      child: Text(
                        item,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFFBDBDBD),
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
