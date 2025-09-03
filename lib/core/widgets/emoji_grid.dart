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
          color: AppColors.cardBackgroundSecondary,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: InkWell(
            onTap: () => onSelectionChanged?.call(emoji.value),
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(
                  color: isSelected ? AppColors.borderSelected : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    emoji.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    emoji.label,
                    style: AppTextStyles.caption,
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
