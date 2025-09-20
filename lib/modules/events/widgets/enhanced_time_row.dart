import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text.dart';

class EnhancedTimeRow extends StatelessWidget {
  final String label;
  final DateTime value;
  final Function(DateTime) onChange;
  final IconData? icon;
  final Color? accentColor;
  final bool showDate;

  const EnhancedTimeRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChange,
    this.icon,
    this.accentColor,
    this.showDate = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveAccentColor = accentColor ?? AppColors.coral;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            effectiveAccentColor.withValues(alpha: 0.05),
            effectiveAccentColor.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: effectiveAccentColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and label
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: effectiveAccentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: effectiveAccentColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: AppTextStyles.captionMedium.copyWith(
                    color: effectiveAccentColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Time display and picker
          GestureDetector(
            onTap: () => _showTimePicker(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: effectiveAccentColor.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Time display
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showDate) ...[
                          Text(
                            DateFormat('EEEE, MMM d').format(value),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                        Text(
                          DateFormat('HH:mm').format(value),
                          style: AppTextStyles.titleMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Edit icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: effectiveAccentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      color: effectiveAccentColor,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTimePicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: value,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: accentColor ?? AppColors.coral,
              surface: AppColors.cardBackground,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(value),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: accentColor ?? AppColors.coral,
                surface: AppColors.cardBackground,
              ),
            ),
            child: child!,
          );
        },
      );
      
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
    }
  }
}

class EnhancedCommentRow extends StatefulWidget {
  final String label;
  final String value;
  final Function(String) onChanged;
  final IconData? icon;
  final Color? accentColor;
  final String? hint;

  const EnhancedCommentRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.icon,
    this.accentColor,
    this.hint,
  });

  @override
  State<EnhancedCommentRow> createState() => _EnhancedCommentRowState();
}

class _EnhancedCommentRowState extends State<EnhancedCommentRow> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(EnhancedCommentRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the text controller when the value changes
    if (oldWidget.value != widget.value) {
      _textController.text = widget.value;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveAccentColor = widget.accentColor ?? AppColors.coral;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            effectiveAccentColor.withValues(alpha: 0.05),
            effectiveAccentColor.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: effectiveAccentColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and label
          Row(
            children: [
              if (widget.icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: effectiveAccentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    widget.icon,
                    color: effectiveAccentColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Text(
                  widget.label.toUpperCase(),
                  style: AppTextStyles.captionMedium.copyWith(
                    color: effectiveAccentColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Text field
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: effectiveAccentColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _textController,
              onChanged: widget.onChanged,
              maxLines: 3,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: widget.hint ?? 'Add a note...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
