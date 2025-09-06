import 'package:flutter/material.dart';

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
                color: Colors.grey[600]!,
                width: 2,
                style: BorderStyle.solid,
              ),
              color: Colors.transparent,
            ),
            child: const Icon(
              Icons.add,
              color: Colors.grey,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'More',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
