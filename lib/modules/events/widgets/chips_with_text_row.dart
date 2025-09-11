import 'package:flutter/material.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';

class ChipsWithTextRow extends StatelessWidget {
  final String label;
  final List<String> suggestions;
  final String value;
  final Function(String) onChanged;

  const ChipsWithTextRow({
    super.key,
    required this.label,
    required this.suggestions,
    required this.value,
    required this.onChanged,
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
          
          // Text input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2E2E2E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: TextEditingController(text: value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter $label',
                hintStyle: const TextStyle(color: Color(0xFF5B5B5B)),
              ),
              onChanged: onChanged,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Suggestion chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.map((suggestion) {
              final isSelected = value.toLowerCase() == suggestion.toLowerCase();
              return GestureDetector(
                onTap: () => onChanged(suggestion),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF5B5B5B) : const Color(0xFF2E2E2E),
                    borderRadius: BorderRadius.circular(14),
                    border: isSelected 
                      ? Border.all(color: const Color(0xFF5B5B5B).withOpacity(0.5), width: 1)
                      : null,
                  ),
                  child: Text(
                    suggestion,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
