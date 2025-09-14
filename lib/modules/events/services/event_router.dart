import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/event_record.dart';
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
import '../views/head_circ_sheet.dart';
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
        sheet = const CrySheet();
        break;
      case EventType.feedingBreast:
        sheet = const FeedingSheet();
        break;
      case EventType.feedingBottle:
        sheet = const BottleSheet();
        break;
      case EventType.diaper:
        sheet = DiaperSheet(existingEvent: existingEvent);
        break;
      case EventType.temperature:
        sheet = const TemperatureSheet();
        break;
      case EventType.doctor:
        sheet = const DoctorSheet();
        break;
      case EventType.bathing:
        sheet = const BathingSheet();
        break;
      case EventType.walking:
        sheet = const WalkingSheet();
        break;
      case EventType.weight:
        sheet = const WeightSheet();
        break;
      case EventType.medicine:
        sheet = const MedicineSheet();
        break;
      case EventType.expressing:
        sheet = const ExpressingSheet();
        break;
      case EventType.spitUp:
        sheet = const SpitUpSheet();
        break;
      case EventType.food:
        sheet = const FoodSheet();
        break;
      case EventType.height:
        sheet = const HeightSheet();
        break;
      case EventType.headCircumference:
        sheet = const HeadCircSheet();
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
      case EventType.diaper:
      case EventType.condition:
        return true;
      default:
        return false;
    }
  }
}
