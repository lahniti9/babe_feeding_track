import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/event_record.dart';
import '../../../core/theme/colors.dart';

/// Centralized color mapping for event types
/// Uses the exact same colors as the events header icons for consistency
class EventColors {

  // Header icon colors (from quick_actions_config.dart)
  static const _violet1 = Color(0xFF6B46FE);
  static const _violet2 = Color(0xFF7B5CFF);
  static const _coral   = AppColors.coral;        // FF6B6B
  static const _brown   = Color(0xFF9C6F63);
  static const _teal    = Color(0xFF3BB3C4);
  static const _red     = Color(0xFFE14E63);
  static const _sand    = Color(0xFFD7B690);
  static const _blue    = Color(0xFF6F86FF);
  static const _green   = Color(0xFF2AC06A);
  static const _lightPink = Color(0xFFF1B8AF);

  /// Get color for EventKind (used in new event system)
  /// These colors match exactly with the header icon colors
  static Color getEventKindColor(EventKind kind) {
    switch (kind) {
      case EventKind.sleeping:
        return _violet1; // Color(0xFF6B46FE)
      case EventKind.bedtimeRoutine:
        return _violet2; // Color(0xFF7B5CFF)
      case EventKind.bottle:
        return _coral; // AppColors.coral (FF6B6B)
      case EventKind.diaper:
        return _brown; // Color(0xFF9C6F63)
      case EventKind.condition:
        return _teal; // Color(0xFF3BB3C4)
      case EventKind.cry:
        return _coral; // AppColors.coral (FF6B6B)
      case EventKind.feeding:
        return _red; // Color(0xFFE14E63)
      case EventKind.expressing:
        return _red; // Color(0xFFE14E63)
      case EventKind.spitUp:
        return _sand; // Color(0xFFD7B690)
      case EventKind.food:
        return _lightPink; // Color(0xFFF1B8AF)
      case EventKind.weight:
        return _blue; // Color(0xFF6F86FF)
      case EventKind.height:
        return _blue; // Color(0xFF6F86FF)
      case EventKind.medicine:
        return _teal; // Color(0xFF3BB3C4)
      case EventKind.temperature:
        return _teal; // Color(0xFF3BB3C4)
      case EventKind.doctor:
        return _teal; // Color(0xFF3BB3C4)
      case EventKind.bathing:
        return _green; // Color(0xFF2AC06A)
      case EventKind.walking:
        return _green; // Color(0xFF2AC06A)
      case EventKind.activity:
        return _green; // Color(0xFF2AC06A)
    }
  }

  /// Get color for EventType (used in legacy event system)
  /// These colors match exactly with the header icon colors
  static Color getEventTypeColor(EventType type) {
    switch (type) {
      case EventType.sleeping:
        return _violet1; // Color(0xFF6B46FE)
      case EventType.bedtimeRoutine:
        return _violet2; // Color(0xFF7B5CFF)
      case EventType.cry:
        return _coral; // AppColors.coral (FF6B6B)
      case EventType.feedingBreast:
        return _red; // Color(0xFFE14E63)
      case EventType.feedingBottle:
        return _coral; // AppColors.coral (FF6B6B) - bottle uses coral in header
      case EventType.diaper:
        return _brown; // Color(0xFF9C6F63)
      case EventType.condition:
        return _teal; // Color(0xFF3BB3C4)
      case EventType.medicine:
        return _teal; // Color(0xFF3BB3C4)
      case EventType.temperature:
        return _teal; // Color(0xFF3BB3C4)
      case EventType.weight:
        return _blue; // Color(0xFF6F86FF)
      case EventType.height:
        return _blue; // Color(0xFF6F86FF)
      case EventType.expressing:
        return _red; // Color(0xFFE14E63)
      case EventType.food:
        return _lightPink; // Color(0xFFF1B8AF)
      case EventType.doctor:
        return _teal; // Color(0xFF3BB3C4)
      case EventType.bathing:
        return _green; // Color(0xFF2AC06A)
      case EventType.walking:
        return _green; // Color(0xFF2AC06A)
      case EventType.activity:
        return _green; // Color(0xFF2AC06A)
      case EventType.spitUp:
        return _sand; // Color(0xFFD7B690)
    }
  }

  /// Get icon for EventKind (matches header icons)
  static IconData getEventKindIcon(EventKind kind) {
    switch (kind) {
      case EventKind.sleeping:
        return Icons.nightlight_round;
      case EventKind.bedtimeRoutine:
        return Icons.bed_rounded;
      case EventKind.bottle:
        return Icons.local_drink;
      case EventKind.diaper:
        return Icons.baby_changing_station;
      case EventKind.condition:
        return Icons.emoji_emotions_outlined;
      case EventKind.cry:
        return Icons.sentiment_very_dissatisfied;
      case EventKind.feeding:
        return Icons.child_care;
      case EventKind.expressing:
        return Icons.pregnant_woman;
      case EventKind.spitUp:
        return Icons.masks_outlined;
      case EventKind.food:
        return Icons.restaurant_menu;
      case EventKind.weight:
        return Icons.monitor_weight;
      case EventKind.height:
        return Icons.straighten;
      case EventKind.medicine:
        return Icons.medication_outlined;
      case EventKind.temperature:
        return Icons.thermostat;
      case EventKind.doctor:
        return Icons.local_hospital;
      case EventKind.bathing:
        return Icons.bathtub_outlined;
      case EventKind.walking:
        return Icons.stroller_outlined;
      case EventKind.activity:
        return Icons.toys_outlined;
    }
  }

  /// Get icon for EventType (matches header icons exactly)
  static IconData getEventTypeIcon(EventType type) {
    switch (type) {
      case EventType.sleeping:
        return Icons.nightlight_round; // matches header
      case EventType.bedtimeRoutine:
        return Icons.bed_rounded; // matches header
      case EventType.cry:
        return Icons.sentiment_very_dissatisfied; // matches header
      case EventType.feedingBreast:
        return Icons.child_care; // matches header
      case EventType.feedingBottle:
        return Icons.local_drink; // matches header
      case EventType.diaper:
        return Icons.baby_changing_station; // matches header
      case EventType.condition:
        return Icons.emoji_emotions_outlined; // matches header
      case EventType.medicine:
        return Icons.medication_outlined; // matches header
      case EventType.temperature:
        return Icons.thermostat; // matches header
      case EventType.weight:
        return Icons.monitor_weight; // matches header
      case EventType.height:
        return Icons.straighten; // matches header
      case EventType.expressing:
        return Icons.pregnant_woman; // matches header
      case EventType.food:
        return Icons.restaurant_menu; // matches header
      case EventType.doctor:
        return Icons.local_hospital; // matches header
      case EventType.bathing:
        return Icons.bathtub_outlined; // matches header
      case EventType.walking:
        return Icons.stroller_outlined; // matches header
      case EventType.activity:
        return Icons.toys_outlined; // matches header
      case EventType.spitUp:
        return Icons.masks_outlined; // matches header
    }
  }

  /// Helper method to get color and icon for EventKind
  static ({Color color, IconData icon}) getEventKindStyle(EventKind kind) {
    return (
      color: getEventKindColor(kind),
      icon: getEventKindIcon(kind),
    );
  }

  /// Helper method to get color and icon for EventType
  static ({Color color, IconData icon}) getEventTypeStyle(EventType type) {
    return (
      color: getEventTypeColor(type),
      icon: getEventTypeIcon(type),
    );
  }
}
