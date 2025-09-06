import 'package:flutter/material.dart';
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
                      color: Colors.white,
                      width: 3,
                    )
                  : null,
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: active
                    ? Border.all(
                        color: const Color(0xFF2A2A2A),
                        width: 2,
                      )
                    : null,
                color: profile.gender == BabyGender.girl
                    ? const Color(0xFFFF8266)
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
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
