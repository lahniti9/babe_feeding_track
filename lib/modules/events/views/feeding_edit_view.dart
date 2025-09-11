import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../models/breast_feeding_event.dart';
import '../widgets/modal_shell.dart';
import '../controllers/events_controller.dart';

class FeedingEditView extends StatefulWidget {
  final BreastFeedingEvent event;

  const FeedingEditView({
    super.key,
    required this.event,
  });

  @override
  State<FeedingEditView> createState() => _FeedingEditViewState();
}

class _FeedingEditViewState extends State<FeedingEditView> {
  late TextEditingController _commentController;
  late BreastFeedingEvent _currentEvent;

  @override
  void initState() {
    super.initState();
    _currentEvent = widget.event;
    _commentController = TextEditingController(text: _currentEvent.comment ?? '');
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalShell(
      title: 'Feeding',
      right: const Text(
        'edit event',
        style: TextStyle(
          color: Color(0xFFBDBDBD),
          fontSize: 14,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time row
          _buildEditableRow(
            label: 'Time',
            value: DateFormat('MMM d, HH:mm').format(_currentEvent.startAt),
            onTap: () => _showTimePicker(),
          ),

          const SizedBox(height: AppSpacing.md),

          // Right duration row
          _buildInfoRow(
            label: 'Right',
            value: prettySecs(_currentEvent.right.inSeconds),
            color: const Color(0xFFFF8A00),
          ),

          const SizedBox(height: AppSpacing.md),

          // Left duration row
          _buildInfoRow(
            label: 'Left',
            value: prettySecs(_currentEvent.left.inSeconds),
            color: const Color(0xFFFF8A00),
          ),

          const SizedBox(height: AppSpacing.md),

          // Volume row (if available)
          if (_currentEvent.volumeOz != null)
            _buildInfoRow(
              label: 'Volume',
              value: '${_currentEvent.volumeOz} US fl oz',
              color: const Color(0xFFFF8A00),
            ),

          const SizedBox(height: AppSpacing.lg),

          // Comment box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _commentController,
              maxLines: 4,
              maxLength: 300,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Here you can write your comment',
                hintStyle: TextStyle(color: Colors.white60),
                border: InputBorder.none,
                counterStyle: TextStyle(color: Colors.white60),
              ),
              onChanged: (text) {
                _currentEvent = _currentEvent.copyWith(comment: text.trim().isEmpty ? null : text.trim());
              },
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Done button
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: _save,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableRow({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFFFF8A00),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFBDBDBD),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showTimePicker() {
    showDatePicker(
      context: context,
      initialDate: _currentEvent.startAt,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(_currentEvent.startAt),
        ).then((time) {
          if (time != null) {
            final newDateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            setState(() {
              _currentEvent = _currentEvent.copyWith(startAt: newDateTime);
            });
          }
        });
      }
    });
  }

  void _save() {
    final finalEvent = _currentEvent.copyWith(
      comment: _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
    );
    
    // Update the event in the controller
    final eventsController = Get.find<EventsController>();
    final index = eventsController.events.indexWhere((e) => e is BreastFeedingEvent && e.id == finalEvent.id);
    if (index >= 0) {
      eventsController.events[index] = finalEvent;
      eventsController.events.refresh();
    }
    
    Get.back();
  }
}
