import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/event_record.dart';
import '../models/cry_event.dart';
import '../views/cry_sheet.dart';
import '../views/feeding_sheet.dart';
import '../views/diaper_sheet.dart';
import '../views/bottle_sheet.dart';
import '../views/temperature_sheet.dart';
import '../views/doctor_sheet.dart';
import '../views/bathing_sheet.dart';
import '../views/walking_sheet.dart';
import '../views/weight_sheet.dart';
import '../views/medicine_sheet.dart';
import '../views/expressing_sheet.dart';
import '../views/spit_up_sheet.dart';
import '../views/food_sheet.dart';
import '../views/height_sheet.dart';
import '../views/activity_sheet.dart';
import '../views/condition_sheet.dart';

class EventRouter {
  static void openEventSheet(EventType type, {EventRecord? existingEvent}) {
    Widget? sheet;

    // Show a message if trying to edit an event type that doesn't support editing yet
    if (existingEvent != null && !_supportsEditing(type)) {
      Get.snackbar(
        'Edit Not Available',
        'Editing for this event type is not yet implemented. You can delete and recreate the event.',
        backgroundColor: const Color(0xFF2E2E2E),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
    }

    switch (type) {
      case EventType.cry:
        // For cry events, we need to convert EventRecord back to CryEvent for editing
        CryEvent? cryEvent;
        if (existingEvent != null) {
          cryEvent = _convertEventRecordToCryEvent(existingEvent);
        }
        sheet = CrySheet(existingEvent: cryEvent);
        break;
      case EventType.feedingBreast:
        sheet = const FeedingSheet();
        break;
      case EventType.feedingBottle:
        sheet = BottleSheet(existingEvent: existingEvent);
        break;
      case EventType.diaper:
        sheet = DiaperSheet(existingEvent: existingEvent);
        break;
      case EventType.temperature:
        sheet = TemperatureSheet(existingEvent: existingEvent);
        break;
      case EventType.doctor:
        sheet = DoctorSheet(existingEvent: existingEvent);
        break;
      case EventType.bathing:
        sheet = const BathingSheet();
        break;
      case EventType.walking:
        sheet = const WalkingSheet();
        break;
      case EventType.weight:
        sheet = WeightSheet(existingEvent: existingEvent);
        break;
      case EventType.medicine:
        sheet = MedicineSheet(existingEvent: existingEvent);
        break;
      case EventType.expressing:
        sheet = const ExpressingSheet();
        break;
      case EventType.spitUp:
        sheet = SpitUpSheet(existingEvent: existingEvent);
        break;
      case EventType.food:
        sheet = FoodSheet(existingEvent: existingEvent);
        break;
      case EventType.height:
        sheet = HeightSheet(existingEvent: existingEvent);
        break;
      case EventType.activity:
        sheet = const ActivitySheet();
        break;
      case EventType.condition:
        sheet = ConditionSheet(existingEvent: existingEvent);
        break;
      default:
        Get.snackbar(
          'Not Available',
          'This event type is not yet implemented',
          backgroundColor: const Color(0xFF2E2E2E),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        return;
    }
    
    Get.bottomSheet(
      sheet,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
    );
  }

  // Helper method to check if an event type supports editing
  static bool _supportsEditing(EventType type) {
    switch (type) {
      case EventType.cry:
      case EventType.diaper:
      case EventType.condition:
      case EventType.feedingBottle:
      case EventType.spitUp:
      case EventType.food:
      case EventType.weight:
      case EventType.height:
      case EventType.temperature:
      case EventType.medicine:
      case EventType.doctor:
        return true;
      default:
        return false;
    }
  }

  // Convert EventRecord back to CryEvent for editing
  static CryEvent _convertEventRecordToCryEvent(EventRecord eventRecord) {
    final data = eventRecord.data;

    // Convert string lists back to enum sets
    final sounds = <CrySound>{};
    if (data['sounds'] != null) {
      for (final soundName in data['sounds'] as List) {
        final sound = CrySound.values.firstWhereOrNull(
          (s) => s.displayName == soundName,
        );
        if (sound != null) sounds.add(sound);
      }
    }

    final volume = <CryVolume>{};
    if (data['volume'] != null) {
      for (final volumeName in data['volume'] as List) {
        final vol = CryVolume.values.firstWhereOrNull(
          (v) => v.displayName == volumeName,
        );
        if (vol != null) volume.add(vol);
      }
    }

    final rhythm = <CryRhythm>{};
    if (data['rhythm'] != null) {
      for (final rhythmName in data['rhythm'] as List) {
        final rhy = CryRhythm.values.firstWhereOrNull(
          (r) => r.displayName == rhythmName,
        );
        if (rhy != null) rhythm.add(rhy);
      }
    }

    final duration = <CryDuration>{};
    if (data['duration'] != null) {
      for (final durationName in data['duration'] as List) {
        final dur = CryDuration.values.firstWhereOrNull(
          (d) => d.displayName == durationName,
        );
        if (dur != null) duration.add(dur);
      }
    }

    final behaviour = <CryBehaviour>{};
    if (data['behaviour'] != null) {
      for (final behaviourName in data['behaviour'] as List) {
        final beh = CryBehaviour.values.firstWhereOrNull(
          (b) => b.displayName == behaviourName,
        );
        if (beh != null) behaviour.add(beh);
      }
    }

    return CryEvent(
      id: eventRecord.id,
      childId: eventRecord.childId,
      time: eventRecord.startAt,
      sounds: sounds,
      volume: volume,
      rhythm: rhythm,
      duration: duration,
      behaviour: behaviour,
      comment: eventRecord.comment,
    );
  }
}
