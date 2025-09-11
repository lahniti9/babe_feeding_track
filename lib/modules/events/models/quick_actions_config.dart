import 'package:flutter/material.dart';
import 'event.dart';
import 'quick_action.dart';
import '../../../core/theme/colors.dart';

const _violet1 = Color(0xFF6B46FE);
const _violet2 = Color(0xFF7B5CFF);
const _coral   = AppColors.coral;        // Updated to use coral
const _brown   = Color(0xFF9C6F63);
const _teal    = Color(0xFF3BB3C4);
const _red     = Color(0xFFE14E63);
const _sand    = Color(0xFFD7B690);
const _blue    = Color(0xFF6F86FF);
const _green   = Color(0xFF2AC06A);

const allRoles = {UserRole.mom, UserRole.coParent, UserRole.caregiver};

const quickActions = <QuickAction>[
  QuickAction(
    kind: EventKind.sleeping, 
    label: 'Sleeping', 
    icon: Icons.nightlight_round, 
    bgColor: _violet1, 
    roles: allRoles
  ),
  QuickAction(
    kind: EventKind.bedtimeRoutine, 
    label: 'Bedtime routi…', 
    icon: Icons.bed_rounded, 
    bgColor: _violet2, 
    roles: allRoles
  ),
  QuickAction(
    kind: EventKind.bottle,
    label: 'Bottle',
    icon: Icons.local_drink,
    bgColor: _coral,
    roles: allRoles
  ),
  QuickAction(
    kind: EventKind.diaper, 
    label: 'Diaper', 
    icon: Icons.baby_changing_station, 
    bgColor: _brown, 
    roles: allRoles
  ),

  QuickAction(
    kind: EventKind.condition, 
    label: 'Condition', 
    icon: Icons.emoji_emotions_outlined, 
    bgColor: _teal, 
    roles: allRoles
  ),
  QuickAction(
    kind: EventKind.cry,
    label: 'Cry',
    icon: Icons.sick_outlined,
    bgColor: _teal,
    roles: allRoles
  ),
  QuickAction(
    kind: EventKind.feeding,
    label: 'Feeding',
    icon: Icons.child_care,
    bgColor: _red,
    roles: {UserRole.mom}
  ), // mom only
  QuickAction(
    kind: EventKind.expressing,
    label: 'Expressing',
    icon: Icons.pregnant_woman,
    bgColor: _red,
    roles: {UserRole.mom}
  ), // mom only
  QuickAction(
    kind: EventKind.spitUp, 
    label: 'Spit-up', 
    icon: Icons.masks_outlined, 
    bgColor: _sand, 
    roles: allRoles
  ),

  QuickAction(
    kind: EventKind.food, 
    label: 'Food', 
    icon: Icons.restaurant_menu, 
    bgColor: Color(0xFFF1B8AF), 
    roles: allRoles
  ),
  QuickAction(
    kind: EventKind.weight, 
    label: 'Weight', 
    icon: Icons.monitor_weight, 
    bgColor: _blue, 
    roles: allRoles
  ),
  QuickAction(
    kind: EventKind.height, 
    label: 'Height', 
    icon: Icons.straighten, 
    bgColor: _blue, 
    roles: allRoles
  ),
  QuickAction(
    kind: EventKind.headCircumference, 
    label: 'Head circumf…', 
    icon: Icons.child_care, 
    bgColor: _blue, 
    roles: allRoles
  ),

  QuickAction(
    kind: EventKind.medicine, 
    label: 'Medicine', 
    icon: Icons.medication_outlined, 
    bgColor: _teal, 
    roles: allRoles
  ),
  QuickAction(
    kind: EventKind.temperature, 
    label: 'Temperature', 
    icon: Icons.thermostat, 
    bgColor: _teal, 
    roles: allRoles
  ),
  QuickAction(
    kind: EventKind.doctor,
    label: 'Doctor',
    icon: Icons.local_hospital,
    bgColor: _teal,
    roles: allRoles
  ),

  QuickAction(
    kind: EventKind.bathing, 
    label: 'Bathing', 
    icon: Icons.bathtub_outlined, 
    bgColor: _green, 
    roles: allRoles
  ),
  QuickAction(
    kind: EventKind.walking, 
    label: 'Walking', 
    icon: Icons.stroller_outlined, 
    bgColor: _green, 
    roles: allRoles
  ),
  QuickAction(
    kind: EventKind.activity, 
    label: 'Activity', 
    icon: Icons.toys_outlined, 
    bgColor: _green, 
    roles: allRoles
  ),
];
