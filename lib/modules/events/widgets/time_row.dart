import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/text.dart';
import '../../../core/theme/colors.dart';

class TimeRow extends StatelessWidget {
  final DateTime value;
  final Function(DateTime) onChange;
  final String label;

  const TimeRow({
    super.key,
    required this.value,
    required this.onChange,
    this.label = 'Time',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), // Reduced from 20 to 16
      padding: const EdgeInsets.all(14), // Reduced from 16 to 14
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12), // Reduced from 16 to 12
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.4), // Increased opacity
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            color: AppColors.coral,
            size: 18, // Reduced from 20 to 18
          ),
          const SizedBox(width: 10), // Reduced from 12 to 10
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14, // Reduced font size
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _showTimePicker(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Reduced padding
              decoration: BoxDecoration(
                color: AppColors.coral,
                borderRadius: BorderRadius.circular(16), // Reduced from 20 to 16
                boxShadow: [
                  BoxShadow(
                    color: AppColors.coral.withValues(alpha: 0.3),
                    blurRadius: 6, // Reduced from 8 to 6
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isToday(value) ? 'Now' : DateFormat('MMM d, HH:mm').format(value),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13, // Reduced from 14 to 13
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4), // Reduced from 6 to 4
                  const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day &&
           (now.difference(date).inMinutes < 5);
  }

  void _showTimePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: value,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(value),
        ).then((time) {
          if (time != null) {
            final newDateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            onChange(newDateTime);
          }
        });
      }
    });
  }
}
