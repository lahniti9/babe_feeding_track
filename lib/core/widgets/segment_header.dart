import 'package:flutter/material.dart';
import '../theme/spacing.dart';
import '../theme/text.dart';

class SegmentHeader extends StatelessWidget {
  final String title;
  final String? caption;
  final TextAlign textAlign;
  final EdgeInsets? padding;

  const SegmentHeader({
    super.key,
    required this.title,
    this.caption,
    this.textAlign = TextAlign.center,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.xxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.titleLarge,
            textAlign: textAlign,
          ),
          if (caption != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              caption!,
              style: AppTextStyles.captionMedium,
              textAlign: textAlign,
            ),
          ],
        ],
      ),
    );
  }
}
