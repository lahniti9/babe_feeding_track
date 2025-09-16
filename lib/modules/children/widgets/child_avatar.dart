import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text.dart';
import '../models/child_profile.dart';

class ChildAvatar extends StatelessWidget {
  final ChildProfile profile;
  final bool active;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ChildAvatar({
    super.key,
    required this.profile,
    required this.active,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: active
                  ? Border.all(
                      color: AppColors.coral,
                      width: 3,
                    )
                  : null,
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: AppColors.coral.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: active
                    ? Border.all(
                        color: Colors.white,
                        width: 2,
                      )
                    : null,
                color: profile.gender == BabyGender.girl
                    ? AppColors.coral
                    : const Color(0xFF3AA3FF),
              ),
              child: profile.avatar != null
                  ? ClipOval(
                      child: Image.network(
                        profile.avatar!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildInitial(),
                      ),
                    )
                  : _buildInitial(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            profile.name,
            style: AppTextStyles.caption.copyWith(
              color: active ? AppColors.coral : AppColors.textPrimary,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildInitial() {
    return Center(
      child: Text(
        profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'B',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
