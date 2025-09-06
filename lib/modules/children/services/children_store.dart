import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:collection/collection.dart';
import '../models/child_profile.dart';

class ChildrenStore extends GetxService {
  final _storage = GetStorage();
  final children = <ChildProfile>[].obs;
  final activeId = RxnString();

  ChildProfile? get active =>
      children.firstWhereOrNull((c) => c.id == activeId.value);

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
}
