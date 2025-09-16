import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text.dart';

class MoreAvatar extends StatelessWidget {
  final VoidCallback onTap;

  const MoreAvatar({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.coral.withValues(alpha: 0.5),
                width: 2,
                style: BorderStyle.solid,
              ),
              color: AppColors.coral.withValues(alpha: 0.1),
            ),
            child: Icon(
              Icons.add_rounded,
              color: AppColors.coral,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add Child',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.coral,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
