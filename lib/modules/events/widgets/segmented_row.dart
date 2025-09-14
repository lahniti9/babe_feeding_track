import 'package:flutter/material.dart';
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
      margin: const EdgeInsets.only(bottom: 16), // Reduced from AppSpacing.lg (20) to 16
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14, // Reduced font size
            ),
          ),
          const SizedBox(height: 8), // Reduced from 12 to 8

          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2E2E2E),
              borderRadius: BorderRadius.circular(10), // Reduced from 12 to 10
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: items.map((item) {
                final isSelected = selected() == item;
                final isFirst = items.first == item;
                final isLast = items.last == item;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onSelect(item),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10), // Reduced from 12 to 10
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.coral : Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isFirst ? 10 : 0),
                          bottomLeft: Radius.circular(isFirst ? 10 : 0),
                          topRight: Radius.circular(isLast ? 10 : 0),
                          bottomRight: Radius.circular(isLast ? 10 : 0),
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: AppColors.coral.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ] : null,
                      ),
                      child: Text(
                        item,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFFBDBDBD),
                          fontSize: 15, // Reduced from 16 to 15
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
