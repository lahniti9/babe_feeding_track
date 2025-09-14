import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/colors.dart';
import '../models/breast_feeding_event.dart';
import '../widgets/event_sheet.dart';
import '../widgets/enhanced_time_row.dart';
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
    return EventSheet(
      title: 'Feeding',
      subtitle: 'Edit feeding session',
      icon: Icons.child_care_rounded,
      accentColor: AppColors.coral,
      onSubmit: _saveChanges,
      sections: [
        // Enhanced time selection
        EnhancedTimeRow(
          label: 'Start Time',
          value: _currentEvent.startAt,
          onChange: (newTime) {
            setState(() {
              _currentEvent = _currentEvent.copyWith(startAt: newTime);
            });
          },
          icon: Icons.access_time_rounded,
          accentColor: AppColors.coral,
        ),

        // Feeding duration section
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBackgroundSecondary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.coral.withValues(alpha: 0.2),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.coral.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.timer_rounded,
                      color: AppColors.coral,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'FEEDING DURATION',
                    style: TextStyle(
                      color: AppColors.coral,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Duration rows
              _buildEnhancedInfoRow(
                label: 'Right',
                value: prettySecs(_currentEvent.right.inSeconds),
                color: const Color(0xFF10B981),
                icon: Icons.arrow_forward_rounded,
              ),

              const SizedBox(height: 12),

              _buildEnhancedInfoRow(
                label: 'Left',
                value: prettySecs(_currentEvent.left.inSeconds),
                color: const Color(0xFF8B5CF6),
                icon: Icons.arrow_back_rounded,
              ),

              if (_currentEvent.volumeOz != null) ...[
                const SizedBox(height: 12),
                _buildEnhancedInfoRow(
                  label: 'Volume',
                  value: '${_currentEvent.volumeOz} US fl oz',
                  color: const Color(0xFF3B82F6),
                  icon: Icons.local_drink_rounded,
                ),
              ],
            ],
          ),
        ),

        // Enhanced comment section
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBackgroundSecondary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.coral.withValues(alpha: 0.2),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.coral.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.comment_rounded,
                      color: AppColors.coral,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'COMMENT',
                    style: TextStyle(
                      color: AppColors.coral,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _commentController,
                maxLines: 4,
                maxLength: 300,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'Here you can write your comment',
                  hintStyle: TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                  counterStyle: TextStyle(color: Colors.white60),
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (text) {
                  _currentEvent = _currentEvent.copyWith(comment: text.trim().isEmpty ? null : text.trim());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedInfoRow({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
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
