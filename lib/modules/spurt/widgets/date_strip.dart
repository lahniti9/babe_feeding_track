import 'package:flutter/material.dart';

class DateStrip extends StatelessWidget {
  final String prevDay;
  final String currentDay;
  final String nextDay;
  final String prevMonth;
  final String currentMonth;
  final String nextMonth;
  final Color accentColor;

  const DateStrip({
    super.key,
    required this.prevDay,
    required this.currentDay,
    required this.nextDay,
    required this.prevMonth,
    required this.currentMonth,
    required this.nextMonth,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Date strip
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Previous day
            _DateItem(
              day: prevDay,
              month: prevMonth,
              isSelected: false,
              accentColor: accentColor,
            ),
            
            const SizedBox(width: 16),
            
            // Current day (highlighted)
            _DateItem(
              day: currentDay,
              month: currentMonth,
              isSelected: true,
              accentColor: accentColor,
            ),
            
            const SizedBox(width: 16),
            
            // Next day
            _DateItem(
              day: nextDay,
              month: nextMonth,
              isSelected: false,
              accentColor: accentColor,
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Caption
        Text(
          'Expected Start Date',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _DateItem extends StatelessWidget {
  final String day;
  final String month;
  final bool isSelected;
  final Color accentColor;

  const _DateItem({
    required this.day,
    required this.month,
    required this.isSelected,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: isSelected ? Colors.transparent : Colors.transparent,
        border: isSelected 
            ? Border.all(color: accentColor, width: 3)
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Day number
          Text(
            day,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[400],
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          
          const SizedBox(height: 2),
          
          // Month
          Text(
            month,
            style: TextStyle(
              color: isSelected ? Colors.grey[300] : Colors.grey[500],
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
