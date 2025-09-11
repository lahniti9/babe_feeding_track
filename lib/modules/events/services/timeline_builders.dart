import 'package:flutter/material.dart';
import '../models/event_record.dart';
import '../models/event.dart';
import '../widgets/timeline_entry.dart';

typedef TimelineBuilder = Widget Function(EventRecord event, String childName);

final Map<EventType, TimelineBuilder> timelineBuilders = {
  EventType.feedingBottle: (event, childName) {
    final feedType = event.data['feedType'] as String? ?? 'formula';
    final volume = event.data['volume'] as num? ?? 0;
    final unit = event.data['unit'] as String? ?? 'oz';
    
    return TimelineEntry(
      model: _createEventModel(
        event,
        icon: Icons.local_drink,
        iconColor: const Color(0xFFFFA629),
        title: '${feedType == 'formula' ? 'Formula' : 'Breast milk'} • $volume $unit',
        subtitle: childName,
      ),
      onTap: () {}, // TODO: Implement edit
    );
  },
  
  EventType.diaper: (event, childName) {
    final kind = event.data['kind'] as String? ?? 'pee';
    final colors = event.data['color'] as List? ?? [];
    final colorText = colors.isNotEmpty ? ' (${colors.join(', ').toLowerCase()})' : '';
    
    return TimelineEntry(
      model: _createEventModel(
        event,
        icon: Icons.baby_changing_station,
        iconColor: const Color(0xFF9C6F63),
        title: 'Diaper — ${kind.capitalize}$colorText',
        subtitle: childName,
      ),
      onTap: () {}, // TODO: Implement edit
    );
  },
  
  EventType.temperature: (event, childName) {
    final value = event.data['value'] as num? ?? 0;
    final unit = event.data['unit'] as String? ?? '°C';
    final methods = event.data['method'] as List? ?? [];
    final methodText = methods.isNotEmpty ? ' (${methods.first.toString().toLowerCase()})' : '';

    return TimelineEntry(
      model: _createEventModel(
        event,
        icon: Icons.thermostat,
        iconColor: const Color(0xFF3BB3C4),
        title: 'Temp $value $unit$methodText',
        subtitle: childName,
      ),
      onTap: () {}, // TODO: Implement edit
    );
  },

  EventType.doctor: (event, childName) {
    final outcomes = event.data['outcome'] as List? ?? [];
    final outcomeText = outcomes.isNotEmpty ? outcomes.first.toString().toLowerCase() : 'visit';

    return TimelineEntry(
      model: _createEventModel(
        event,
        icon: Icons.local_hospital,
        iconColor: const Color(0xFF6F86FF),
        title: 'Doctor visit — $outcomeText',
        subtitle: childName,
      ),
      onTap: () {},
    );
  },

  EventType.bathing: (event, childName) {
    final seconds = event.data['seconds'] as int? ?? 0;
    final timeText = _formatDuration(seconds);

    return TimelineEntry(
      model: _createEventModel(
        event,
        icon: Icons.bathtub_outlined,
        iconColor: const Color(0xFF2AC06A),
        title: 'Bath • $timeText',
        subtitle: childName,
      ),
      onTap: () {},
    );
  },

  EventType.walking: (event, childName) {
    final seconds = event.data['seconds'] as int? ?? 0;
    final modes = event.data['mode'] as List? ?? [];
    final timeText = _formatDuration(seconds);
    final modeText = modes.isNotEmpty ? ' (${modes.first.toString().toLowerCase()})' : '';

    return TimelineEntry(
      model: _createEventModel(
        event,
        icon: Icons.stroller_outlined,
        iconColor: const Color(0xFF2AC06A),
        title: 'Walked $timeText$modeText',
        subtitle: childName,
      ),
      onTap: () {},
    );
  },

  EventType.weight: (event, childName) {
    final displayUnit = event.data['displayUnit'] as String? ?? 'kg';
    String displayText;

    if (displayUnit == 'lb/oz') {
      final pounds = event.data['pounds'] as int? ?? 0;
      final ounces = event.data['ounces'] as int? ?? 0;
      displayText = '$pounds lb $ounces oz';
    } else {
      final value = event.data['value'] as num? ?? 0;
      displayText = '${value.toStringAsFixed(2)} kg';
    }

    return TimelineEntry(
      model: _createEventModel(
        event,
        icon: Icons.monitor_weight,
        iconColor: const Color(0xFF6F86FF),
        title: 'Weight $displayText',
        subtitle: childName,
      ),
      onTap: () {},
    );
  },

  EventType.medicine: (event, childName) {
    final name = event.data['name'] as String? ?? 'Medicine';
    final dose = event.data['dose'] as num? ?? 0;
    final unit = event.data['unit'] as String? ?? 'ml';

    return TimelineEntry(
      model: _createEventModel(
        event,
        icon: Icons.medication_outlined,
        iconColor: const Color(0xFF3BB3C4),
        title: '$name $dose$unit',
        subtitle: childName,
      ),
      onTap: () {},
    );
  },

  EventType.expressing: (event, childName) {
    final seconds = event.data['seconds'] as int? ?? 0;
    final volume = event.data['volume'] as int?;
    final unit = event.data['unit'] as String? ?? 'ml';
    final timeText = _formatDuration(seconds);

    String title;
    if (volume != null) {
      title = 'Expressed $volume $unit — $timeText';
    } else {
      title = 'Expressing — $timeText';
    }

    return TimelineEntry(
      model: _createEventModel(
        event,
        icon: Icons.pregnant_woman,
        iconColor: const Color(0xFFE14E63),
        title: title,
        subtitle: childName,
      ),
      onTap: () {},
    );
  },

  EventType.spitUp: (event, childName) {
    final amount = event.data['amount'] as String? ?? 'small';
    final type = event.data['type'] as String? ?? 'milk';

    return TimelineEntry(
      model: _createEventModel(
        event,
        icon: Icons.water_drop,
        iconColor: const Color(0xFFD4AF37),
        title: 'Spit-up ($amount, $type)',
        subtitle: childName,
      ),
      onTap: () {},
    );
  },

  EventType.food: (event, childName) {
    final food = event.data['food'] as String? ?? 'food';
    final amount = event.data['amount'] as String? ?? 'taste';
    final reactions = event.data['reaction'] as List? ?? [];

    String amountText = amount.replaceAll('_', ' ');
    String title = 'Ate $food — $amountText';

    if (reactions.isNotEmpty) {
      title += ' (${reactions.first})';
    }

    return TimelineEntry(
      model: _createEventModel(
        event,
        icon: Icons.restaurant,
        iconColor: const Color(0xFFFFB03A),
        title: title,
        subtitle: childName,
      ),
      onTap: () {},
    );
  },

  EventType.height: (event, childName) {
    final valueCm = event.data['valueCm'] as num? ?? 0;
    final unit = event.data['unit'] as String? ?? 'cm';
    final display = event.data['display'] as Map?;

    String displayText;
    if (unit == 'cm') {
      displayText = '${valueCm.toStringAsFixed(1)} cm';
    } else if (display != null) {
      final inches = display['in'] as num? ?? 0;
      displayText = '${inches.toStringAsFixed(1)} in';
    } else {
      displayText = '${valueCm.toStringAsFixed(1)} cm';
    }

    return TimelineEntry(
      model: _createEventModel(
        event,
        icon: Icons.straighten,
        iconColor: const Color(0xFF6F86FF),
        title: 'Height $displayText',
        subtitle: childName,
      ),
      onTap: () {},
    );
  },

  EventType.headCircumference: (event, childName) {
    final valueCm = event.data['valueCm'] as num? ?? 0;
    final unit = event.data['unit'] as String? ?? 'cm';
    final display = event.data['display'] as Map?;

    String displayText;
    if (unit == 'cm') {
      displayText = '${valueCm.toStringAsFixed(1)} cm';
    } else if (display != null) {
      final inches = display['in'] as num? ?? 0;
      displayText = '${inches.toStringAsFixed(1)} in';
    } else {
      displayText = '${valueCm.toStringAsFixed(1)} cm';
    }

    return TimelineEntry(
      model: _createEventModel(
        event,
        icon: Icons.child_care,
        iconColor: const Color(0xFF6F86FF),
        title: 'Head circumference $displayText',
        subtitle: childName,
      ),
      onTap: () {},
    );
  },

  EventType.activity: (event, childName) {
    final type = event.data['type'] as String? ?? 'activity';
    final seconds = event.data['seconds'] as int? ?? 0;
    final timeText = _formatDuration(seconds);

    String typeLabel = _formatActivityType(type);

    return TimelineEntry(
      model: _createEventModel(
        event,
        icon: Icons.toys,
        iconColor: const Color(0xFF2AC06A),
        title: '$typeLabel • $timeText',
        subtitle: childName,
      ),
      onTap: () {},
    );
  },

  EventType.condition: (event, childName) {
    final moods = event.data['moods'] as List? ?? [];
    final firstMood = moods.isNotEmpty ? moods.first.toString().capitalize : 'condition';

    return TimelineEntry(
      model: _createEventModel(
        event,
        icon: Icons.sentiment_satisfied,
        iconColor: const Color(0xFF3BB3C4),
        title: 'Condition — $firstMood',
        subtitle: childName,
      ),
      onTap: () {},
    );
  },
};

// Helper to create EventModel for timeline compatibility
EventModel _createEventModel(EventRecord event, {
  required IconData icon,
  required Color iconColor,
  required String title,
  required String subtitle,
}) {
  // Map EventRecord type to EventKind
  EventKind kind;
  switch (event.type) {
    case EventType.feedingBottle:
      kind = EventKind.bottle;
      break;
    case EventType.expressing:
      kind = EventKind.expressing;
      break;
    case EventType.spitUp:
      kind = EventKind.spitUp;
      break;
    case EventType.diaper:
      kind = EventKind.diaper;
      break;
    case EventType.temperature:
      kind = EventKind.temperature;
      break;
    case EventType.weight:
      kind = EventKind.weight;
      break;
    case EventType.height:
      kind = EventKind.height;
      break;
    case EventType.headCircumference:
      kind = EventKind.headCircumference;
      break;
    case EventType.medicine:
      kind = EventKind.medicine;
      break;
    case EventType.doctor:
      kind = EventKind.doctor;
      break;
    case EventType.bathing:
      kind = EventKind.bathing;
      break;
    case EventType.walking:
      kind = EventKind.walking;
      break;
    case EventType.food:
      kind = EventKind.food;
      break;
    default:
      kind = EventKind.activity;
  }

  return EventModel(
    id: event.id,
    childId: event.childId,
    kind: kind,
    time: event.startAt,
    endTime: event.endAt,
    title: title,
    subtitle: subtitle,
    comment: event.comment, // Use comment field
    showPlus: false,
    tags: [],
  );
}

extension StringExtension on String {
  String get capitalize => '${this[0].toUpperCase()}${substring(1)}';
}

// Helper function to format duration
String _formatDuration(int seconds) {
  return seconds >= 60
    ? '${(seconds~/60).toString().padLeft(2,'0')}:${(seconds%60).toString().padLeft(2,'0')}'
    : '$seconds secs';
}

// Helper function to format activity type
String _formatActivityType(String type) {
  switch (type) {
    case 'tummy_time': return 'Tummy time';
    case 'play_mat': return 'Play mat';
    case 'baby_gym': return 'Baby gym';
    case 'outdoor_walk': return 'Outdoor walk';
    case 'free_play': return 'Free play';
    default: return type.replaceAll('_', ' ').capitalize;
  }
}
