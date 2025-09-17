import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text.dart';
import '../models/event_record.dart';
import '../../children/services/children_store.dart';
import 'timeline_container.dart';

class EventRecordTimelineEntry extends StatelessWidget {
  final EventRecord event;
  final VoidCallback? onTap;
  final VoidCallback? onPlusTap;

  const EventRecordTimelineEntry({
    super.key,
    required this.event,
    this.onTap,
    this.onPlusTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator with connecting line
        TimelineIndicator(
          backgroundColor: _getEventColor().withValues(alpha: 0.1),
          borderColor: _getEventColor(),
          isActive: true,
          child: Icon(
            _getEventIcon(),
            color: _getEventColor(),
            size: 24,
          ),
        ),

        const SizedBox(width: AppSpacing.lg),

        // Event content card
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(
                  color: _getEventColor().withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row with plus button and time
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getEventTitle(),
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      _buildTimeDisplay(),
                      const SizedBox(width: AppSpacing.sm),
                      _buildPlusButton(),
                    ],
                  ),

                  // Child name subtitle
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _getChildName(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  // Event details
                  const SizedBox(height: AppSpacing.sm),
                  _buildEventDetails(),

                  // Comment display
                  if (event.comment != null && event.comment!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _buildCommentDisplay(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }



  Widget _buildPlusButton() {
    if (onPlusTap == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onPlusTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.add,
          size: 14,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildEventDetails() {
    final details = _getEventDetails();
    if (details.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: details.map((detail) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: 4,
              margin: const EdgeInsets.only(top: 8, right: 8),
              decoration: BoxDecoration(
                color: _getEventColor().withOpacity(0.6),
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(
                detail,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildCommentDisplay() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.coral.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.coral.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.chat_bubble_outline,
            color: AppColors.coral,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              event.comment!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDisplay() {
    final timeFormat = DateFormat('HH:mm');
    String timeText = timeFormat.format(event.startAt);

    // Add duration if available (more compact)
    if (event.endAt != null) {
      final duration = event.endAt!.difference(event.startAt);
      if (duration.inHours > 0) {
        timeText += ' (${duration.inHours}h ${duration.inMinutes % 60}m)';
      } else if (duration.inMinutes > 0) {
        timeText += ' (${duration.inMinutes}m)';
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _getEventColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(
          color: _getEventColor().withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        timeText,
        style: AppTextStyles.caption.copyWith(
          color: _getEventColor(),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getEventTitle() {
    switch (event.type) {
      case EventType.sleeping:
        return 'Sleeping';
      case EventType.bedtimeRoutine:
        return 'Bedtime routine';
      case EventType.cry:
        return 'Crying';
      case EventType.feedingBreast:
        return 'Breast feeding';
      case EventType.feedingBottle:
        final feedType = event.data['feedType'] as String? ?? 'formula';
        return feedType == 'formula' ? 'Formula feeding' : 'Bottle feeding';
      case EventType.diaper:
        final kind = event.data['kind'] as String? ?? 'diaper';
        return '${kind.substring(0, 1).toUpperCase()}${kind.substring(1)} diaper';
      case EventType.condition:
        return 'Condition check';
      case EventType.medicine:
        final name = event.data['name'] as String? ?? 'Medicine';
        return name;
      case EventType.temperature:
        return 'Temperature reading';
      case EventType.weight:
        return 'Weight measurement';
      case EventType.height:
        return 'Height measurement';
      case EventType.expressing:
        return 'Breast milk expressing';
      case EventType.food:
        final food = event.data['food'] as String? ?? 'Food';
        return food;
      case EventType.doctor:
        return 'Doctor visit';
      case EventType.bathing:
        return 'Bath time';
      case EventType.walking:
        return 'Walk';
      case EventType.activity:
        final type = event.data['type'] as String? ?? 'Activity';
        return type.substring(0, 1).toUpperCase() + type.substring(1);
      case EventType.spitUp:
        return 'Spit-up';
    }
  }

  String _getChildName() {
    try {
      final childrenStore = Get.find<ChildrenStore>();
      final child = childrenStore.getChildById(event.childId);
      return child?.name ?? 'Baby';
    } catch (e) {
      return 'Baby';
    }
  }

  List<String> _getEventDetails() {
    final details = <String>[];

    switch (event.type) {
      case EventType.sleeping:
        if (event.endAt != null) {
          final duration = event.endAt!.difference(event.startAt);
          if (duration.inHours > 0) {
            details.add('Duration: ${duration.inHours}h ${duration.inMinutes % 60}m');
          } else {
            details.add('Duration: ${duration.inMinutes}m');
          }
        }
        break;

      case EventType.bedtimeRoutine:
        final activities = event.data['activities'] as List? ?? [];
        if (activities.isNotEmpty) {
          details.add('Activities: ${activities.join(', ').toLowerCase()}');
        }
        break;

      case EventType.cry:
        final sounds = event.data['sounds'] as List? ?? [];
        final volume = event.data['volume'] as List? ?? [];
        final rhythm = event.data['rhythm'] as List? ?? [];
        final duration = event.data['duration'] as List? ?? [];
        final behaviour = event.data['behaviour'] as List? ?? [];

        if (sounds.isNotEmpty) {
          details.add('Sound: ${sounds.join(', ').toLowerCase()}');
        }
        if (volume.isNotEmpty) {
          details.add('Volume: ${volume.join(', ').toLowerCase()}');
        }
        if (rhythm.isNotEmpty) {
          details.add('Rhythm: ${rhythm.join(', ').toLowerCase()}');
        }
        if (duration.isNotEmpty) {
          details.add('Duration: ${duration.join(', ').toLowerCase()}');
        }
        if (behaviour.isNotEmpty) {
          details.add('Behaviour: ${behaviour.join(', ').toLowerCase()}');
        }
        break;

      case EventType.feedingBreast:
        final leftMinutes = event.data['leftMinutes'] as int? ?? 0;
        final rightMinutes = event.data['rightMinutes'] as int? ?? 0;
        final totalMinutes = leftMinutes + rightMinutes;
        if (totalMinutes > 0) {
          details.add('Total: ${totalMinutes}m');
          if (leftMinutes > 0 || rightMinutes > 0) {
            details.add('Left: ${leftMinutes}m • Right: ${rightMinutes}m');
          }
        }
        break;

      case EventType.diaper:
        final colors = event.data['color'] as List? ?? [];
        final consistency = event.data['consistency'] as List? ?? [];
        if (colors.isNotEmpty) {
          details.add('Color: ${colors.join(', ').toLowerCase()}');
        }
        if (consistency.isNotEmpty) {
          details.add('Consistency: ${consistency.join(', ').toLowerCase()}');
        }
        break;


      case EventType.condition:
        // Handle both old format (moods array) and new format (single mood)
        final mood = event.data['mood'] as String? ?? '';
        final moods = event.data['moods'] as List? ?? [];
        final severity = event.data['severity'] as String? ?? '';

        // Display mood (prefer new single mood format)
        if (mood.isNotEmpty) {
          details.add('Mood: ${mood.toLowerCase()}');
        } else if (moods.isNotEmpty) {
          // Backward compatibility for old format
          details.add('Mood: ${moods.first.toString().toLowerCase()}');
        }

        if (severity.isNotEmpty) {
          details.add('Severity: $severity');
        }
        break;
        
      case EventType.medicine:
        final dose = event.data['dose'] as num? ?? 0;
        final unit = event.data['unit'] as String? ?? '';
        final reason = event.data['reason'] as List? ?? [];
        if (dose > 0) {
          details.add('Dosage: $dose $unit');
        }
        if (reason.isNotEmpty) {
          details.add('Reason: ${reason.join(', ').toLowerCase()}');
        }
        break;
        
      case EventType.temperature:
        final value = event.data['value'] as num? ?? 0;
        final unit = event.data['unit'] as String? ?? '°C';
        final method = event.data['method'] as List? ?? [];
        final condition = event.data['condition'] as List? ?? [];
        details.add('Temperature: ${value.toStringAsFixed(1)}$unit');
        if (method.isNotEmpty) {
          details.add('Method: ${method.join(', ').toLowerCase()}');
        }
        if (condition.isNotEmpty) {
          details.add('Condition: ${condition.join(', ').toLowerCase()}');
        }
        break;
        
      case EventType.weight:
        final pounds = event.data['pounds'] as num? ?? 0;
        final ounces = event.data['ounces'] as num? ?? 0;
        if (pounds > 0 || ounces > 0) {
          details.add('Weight: ${pounds}lb ${ounces}oz');
        } else {
          final value = event.data['value'] as num? ?? 0;
          final unit = event.data['unit'] as String? ?? 'lb';
          details.add('Weight: $value $unit');
        }
        break;
        
      case EventType.height:
        final valueCm = event.data['valueCm'] as num? ?? 0;
        final unit = event.data['unit'] as String? ?? 'cm';
        final display = event.data['display'] as Map<String, dynamic>?;

        String displayText;
        if (unit == 'cm') {
          final cmValue = display?['cm'] as num? ?? valueCm;
          displayText = '${cmValue.toStringAsFixed(1)} cm';
        } else {
          final inValue = display?['in'] as num? ?? (valueCm / 2.54);
          displayText = '${inValue.toStringAsFixed(1)} in';
        }

        details.add('Height: $displayText');
        break;

      case EventType.expressing:
        final volume = event.data['volume'] as num? ?? 0;
        final unit = event.data['unit'] as String? ?? 'ml';
        final method = event.data['method'] as String? ?? '';
        final side = event.data['side'] as String? ?? '';
        final seconds = event.data['seconds'] as num? ?? 0;
        details.add('Volume: $volume $unit');
        if (method.isNotEmpty) {
          details.add('Method: $method');
        }
        if (side.isNotEmpty) {
          details.add('Side: $side');
        }
        if (seconds > 0) {
          final minutes = (seconds / 60).round();
          details.add('Duration: ${minutes}min');
        }
        break;

      case EventType.food:
        final amount = event.data['amount'] as String? ?? '';
        final reaction = event.data['reaction'] as List? ?? [];
        if (amount.isNotEmpty) {
          details.add('Amount: ${amount.replaceAll('_', ' ')}');
        }
        if (reaction.isNotEmpty) {
          details.add('Reaction: ${reaction.join(', ').toLowerCase()}');
        }
        break;

      case EventType.doctor:
        final reason = event.data['reason'] as List? ?? [];
        final outcome = event.data['outcome'] as List? ?? [];
        if (reason.isNotEmpty) {
          details.add('Reason: ${reason.join(', ').toLowerCase()}');
        }
        if (outcome.isNotEmpty) {
          details.add('Outcome: ${outcome.join(', ').toLowerCase()}');
        }
        break;

      case EventType.bathing:
        final seconds = event.data['seconds'] as num? ?? 0;
        final aids = event.data['aids'] as List? ?? [];
        final mood = event.data['mood'] as List? ?? [];
        if (seconds > 0) {
          final minutes = (seconds / 60).round();
          details.add('Duration: ${minutes}min');
        }
        if (aids.isNotEmpty) {
          details.add('Used: ${aids.join(', ').toLowerCase()}');
        }
        if (mood.isNotEmpty) {
          details.add('Mood: ${mood.join(', ').toLowerCase()}');
        }
        break;

      case EventType.walking:
        final seconds = event.data['seconds'] as num? ?? 0;
        final mode = event.data['mode'] as List? ?? [];
        final place = event.data['place'] as List? ?? [];
        if (seconds > 0) {
          final minutes = (seconds / 60).round();
          details.add('Duration: ${minutes}min');
        }
        if (mode.isNotEmpty) {
          details.add('Mode: ${mode.join(', ').toLowerCase()}');
        }
        if (place.isNotEmpty) {
          details.add('Place: ${place.join(', ').toLowerCase()}');
        }
        break;

      case EventType.activity:
        final seconds = event.data['seconds'] as num? ?? 0;
        final intensity = event.data['intensity'] as String? ?? '';
        final note = event.data['note'] as String? ?? '';
        if (seconds > 0) {
          final minutes = (seconds / 60).round();
          details.add('Duration: ${minutes}min');
        }
        if (intensity.isNotEmpty) {
          details.add('Intensity: $intensity');
        }
        if (note.isNotEmpty) {
          details.add('Note: $note');
        }
        break;

      case EventType.feedingBottle:
        final volume = event.data['volume'] as num? ?? 0;
        final unit = event.data['unit'] as String? ?? 'oz';
        final feedType = event.data['feedType'] as String? ?? 'formula';
        details.add('Volume: $volume $unit');
        details.add('Type: $feedType');
        break;

      case EventType.spitUp:
        final amount = event.data['amount'] as String? ?? '';
        final type = event.data['type'] as String? ?? '';
        final note = event.data['note'] as String? ?? '';
        if (amount.isNotEmpty) {
          details.add('Amount: $amount');
        }
        if (type.isNotEmpty) {
          details.add('Type: $type');
        }
        if (note.isNotEmpty) {
          details.add('Note: $note');
        }
        break;
    }

    return details;
  }

  Color _getEventColor() {
    switch (event.type) {
      case EventType.sleeping:
        return Colors.purple;
      case EventType.bedtimeRoutine:
        return Colors.indigo;
      case EventType.cry:
        return Colors.orange;
      case EventType.feedingBreast:
        return Colors.green;
      case EventType.feedingBottle:
        return const Color(0xFF059669);
      case EventType.diaper:
        return const Color(0xFFDC2626);
      case EventType.condition:
        return const Color(0xFFF59E0B);
      case EventType.medicine:
        return const Color(0xFF059669);
      case EventType.temperature:
        return const Color(0xFFEF4444);
      case EventType.weight:
      case EventType.height:
        return const Color(0xFF0891B2);
      case EventType.expressing:
        return const Color(0xFF8B5CF6);
      case EventType.food:
        return const Color(0xFF10B981);
      case EventType.doctor:
        return const Color(0xFF3B82F6);
      case EventType.bathing:
        return const Color(0xFF06B6D4);
      case EventType.walking:
        return const Color(0xFF84CC16);
      case EventType.activity:
        return const Color(0xFFDB2777);
      case EventType.spitUp:
        return const Color(0xFFF97316);
    }
  }

  IconData _getEventIcon() {
    switch (event.type) {
      case EventType.sleeping:
        return Icons.bed;
      case EventType.bedtimeRoutine:
        return Icons.nightlight;
      case EventType.cry:
        return Icons.sentiment_very_dissatisfied;
      case EventType.feedingBreast:
        return Icons.child_care;
      case EventType.feedingBottle:
        return Icons.local_drink;
      case EventType.diaper:
        return Icons.baby_changing_station;
      case EventType.condition:
        return Icons.mood;
      case EventType.medicine:
        return Icons.medication;
      case EventType.temperature:
        return Icons.thermostat;
      case EventType.weight:
        return Icons.scale;
      case EventType.height:
        return Icons.height;
      case EventType.expressing:
        return Icons.water_drop;
      case EventType.food:
        return Icons.restaurant;
      case EventType.doctor:
        return Icons.local_hospital;
      case EventType.bathing:
        return Icons.bathtub;
      case EventType.walking:
        return Icons.directions_walk;
      case EventType.activity:
        return Icons.toys;
      case EventType.spitUp:
        return Icons.water_drop_outlined;
    }
  }
}
