import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/text.dart';

class EmojiItem {
  final String emoji;
  final String label;
  final String value;

  const EmojiItem({
    required this.emoji,
    required this.label,
    required this.value,
  });
}

class EmojiGrid extends StatelessWidget {
  final List<EmojiItem> emojis;
  final String? selectedValue;
  final Function(String)? onSelectionChanged;
  final int crossAxisCount;

  const EmojiGrid({
    super.key,
    required this.emojis,
    this.selectedValue,
    this.onSelectionChanged,
    this.crossAxisCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.0,
      ),
      itemCount: emojis.length,
      itemBuilder: (context, index) {
        final emoji = emojis[index];
        final isSelected = selectedValue == emoji.value;
        
        return Material(
          color: isSelected
              ? AppColors.cardBackgroundSecondary.withValues(alpha: 0.8)
              : AppColors.cardBackgroundSecondary,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: InkWell(
            onTap: () => onSelectionChanged?.call(emoji.value),
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(
                  color: isSelected ? AppColors.borderSelected : Colors.transparent,
                  width: isSelected ? 3 : 2,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppColors.borderSelected.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ] : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: isSelected ? 36 : 32,
                    ),
                    child: Text(emoji.emoji),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    emoji.label,
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected ? AppColors.borderSelected : null,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
