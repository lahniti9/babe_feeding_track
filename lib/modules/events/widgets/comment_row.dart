import 'package:flutter/material.dart';
import '../../../core/theme/text.dart';

class CommentRow extends StatelessWidget {
  final String value;
  final Function(String) onChanged;
  final String label;
  final int maxLength;

  const CommentRow({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'Comment',
    this.maxLength = 300,
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
            padding: const EdgeInsets.all(12), // Reduced from 16 to 12
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12), // Reduced from 16 to 12
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: TextField(
              controller: TextEditingController(text: value),
              maxLines: 3, // Reduced from 4 to 3
              maxLength: maxLength,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14, // Reduced font size
              ),
              decoration: const InputDecoration(
                hintText: 'Add a comment...',
                hintStyle: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                counterStyle: TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
                isDense: true, // Make the field more compact
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
