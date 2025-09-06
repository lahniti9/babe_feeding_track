import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final List<SectionItem> items;

  const SectionCard({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF242424), // Grey background
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;
          
          return Column(
            children: [
              SectionItemWidget(item: item),
              if (!isLast) ...[
                const SizedBox(height: 20),
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                const SizedBox(height: 20),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }
}

class SectionItem {
  final IconData icon;
  final String title;
  final String body;

  const SectionItem({
    required this.icon,
    required this.title,
    required this.body,
  });
}

class SectionItemWidget extends StatelessWidget {
  final SectionItem item;

  const SectionItemWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            item.icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                item.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Body text
              Text(
                item.body,
                style: const TextStyle(
                  color: Color(0xFFD0D0D0), // Light grey
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
