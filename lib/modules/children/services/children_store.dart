import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/child_profile.dart';
import '../../statistics/services/timezone_clock.dart';

class ChildrenStore extends GetxService {
  final _storage = GetStorage();
  final children = <ChildProfile>[].obs;
  final activeId = RxnString();

  // Computed getter for active child
  ChildProfile? get active => children.firstWhereOrNull((c) => c.id == activeId.value);

  // Helper to produce timezone clock from active child
  TimezoneClock clockFor(ChildProfile? child) =>
      TimezoneClock.fromName(child?.timezone ?? 'UTC');

  @override
  void onInit() {
    super.onInit();
    _loadChildren();
  }

  void setActive(String id) {
    activeId.value = id;
    _saveActiveId();
  }

  void add(ChildProfile c) {
    children.add(c);
    activeId.value ??= c.id; // first child becomes active
    _saveChildren();
    _saveActiveId();
  }

  void update(ChildProfile c) {
    final i = children.indexWhere((x) => x.id == c.id);
    if (i != -1) {
      children[i] = c;
      _saveChildren();
    }
  }

  void remove(String id) {
    children.removeWhere((x) => x.id == id);
    if (activeId.value == id) {
      activeId.value = children.isEmpty ? null : children.first.id;
    }
    _saveChildren();
    _saveActiveId();

    // Notify other services about child deletion for cleanup
    _notifyChildDeleted(id);
  }

  // Notify other services when a child is deleted
  void _notifyChildDeleted(String childId) {
    // This could trigger cleanup in EventsController and EventsStore
    // For now, we'll rely on the cleanup methods in EventsController
    debugPrint('Child $childId was deleted');
  }

  // Load children from storage
  void _loadChildren() {
    final childrenData = _storage.read('children_profiles');
    if (childrenData != null) {
      children.value = (childrenData as List)
          .map((child) => ChildProfile.fromJson(Map<String, dynamic>.from(child)))
          .toList();
    }

    final activeIdData = _storage.read('active_child_id');
    if (activeIdData != null && children.isNotEmpty) {
      activeId.value = activeIdData;
    } else if (children.isNotEmpty) {
      activeId.value = children.first.id;
    }
  }

  // Save children to storage
  void _saveChildren() {
    _storage.write('children_profiles', children.map((child) => child.toJson()).toList());
  }

  // Save active child ID to storage
  void _saveActiveId() {
    if (activeId.value != null) {
      _storage.write('active_child_id', activeId.value);
    }
  }

  // Get display name for active child
  String get activeChildDisplayName {
    return active?.name ?? 'Naji';
  }

  // Check if user has multiple children
  bool get hasMultipleChildren => children.length > 1;

  // Get child by ID
  ChildProfile? getChildById(String childId) {
    return children.firstWhereOrNull((child) => child.id == childId);
  }

  // Safely get active child ID with validation
  String? getValidActiveChildId() {
    final id = activeId.value;
    if (id == null || children.isEmpty) {
      return null;
    }

    // Verify the active child still exists
    final child = getChildById(id);
    if (child == null) {
      // Active child was deleted, set to first available child
      if (children.isNotEmpty) {
        setActive(children.first.id);
        return children.first.id;
      }
      return null;
    }

    return id;
  }

  // Check if we have a valid active child for event creation
  bool get canCreateEvents => getValidActiveChildId() != null;
}
