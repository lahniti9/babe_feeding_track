import 'package:flutter/material.dart';
import '../../../core/theme/spacing.dart';
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: TextEditingController(text: value),
              maxLines: 4,
              maxLength: maxLength,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Here you can write your comment',
                hintStyle: TextStyle(color: Colors.white60),
                border: InputBorder.none,
                counterStyle: TextStyle(color: Colors.white60),
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
