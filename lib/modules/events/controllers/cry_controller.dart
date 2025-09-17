import 'package:get/get.dart';
import '../models/cry_event.dart';
import 'events_controller.dart';
import '../../children/services/children_store.dart';

class CryController extends GetxController {
  final time = DateTime.now().obs;
  final selectedSound = Rx<CrySound?>(null);
  final selectedVolume = Rx<CryVolume?>(null);
  final selectedRhythm = Rx<CryRhythm?>(null);
  final selectedDuration = Rx<CryDuration?>(null);
  final selectedBehaviour = Rx<CryBehaviour?>(null);
  final comment = ''.obs;

  // Editing state
  String? editingEventId;
  final isEditMode = false.obs;

  void selectSound(CrySound sound) {
    selectedSound.value = selectedSound.value == sound ? null : sound;
  }

  void selectVolume(CryVolume volume) {
    selectedVolume.value = selectedVolume.value == volume ? null : volume;
  }

  void selectRhythm(CryRhythm rhythm) {
    selectedRhythm.value = selectedRhythm.value == rhythm ? null : rhythm;
  }

  void selectDuration(CryDuration duration) {
    selectedDuration.value = selectedDuration.value == duration ? null : duration;
  }

  void selectBehaviour(CryBehaviour behaviour) {
    selectedBehaviour.value = selectedBehaviour.value == behaviour ? null : behaviour;
  }

  void setTime(DateTime newTime) {
    time.value = newTime;
  }

  Future<void> save() async {
    final childrenStore = Get.find<ChildrenStore>();
    final activeChildId = childrenStore.getValidActiveChildId();

    if (activeChildId == null) {
      Get.snackbar(
        'No Child Selected',
        'Please add a child profile before creating events.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final eventsController = Get.find<EventsController>();

    if (isEditMode.value && editingEventId != null) {
      // Update existing event
      final eventIndex = eventsController.events.indexWhere((e) =>
        (e is CryEvent && e.id == editingEventId));

      if (eventIndex >= 0) {
        final existingEvent = eventsController.events[eventIndex] as CryEvent;
        final updatedEvent = existingEvent.copyWith(
          time: time.value,
          sounds: selectedSound.value != null ? {selectedSound.value!} : <CrySound>{},
          volume: selectedVolume.value != null ? {selectedVolume.value!} : <CryVolume>{},
          rhythm: selectedRhythm.value != null ? {selectedRhythm.value!} : <CryRhythm>{},
          duration: selectedDuration.value != null ? {selectedDuration.value!} : <CryDuration>{},
          behaviour: selectedBehaviour.value != null ? {selectedBehaviour.value!} : <CryBehaviour>{},
          comment: comment.value.isEmpty ? null : comment.value,
        );

        // Update the event in place
        eventsController.events[eventIndex] = updatedEvent;
        // Use the remove/add pattern that properly triggers storage updates
        eventsController.remove(editingEventId!, skipConfirmation: true);
        eventsController.addCryEvent(updatedEvent);
      }
    } else {
      // Create new event
      final event = CryEvent(
        id: 'cry_${DateTime.now().millisecondsSinceEpoch}',
        childId: activeChildId,
        time: time.value,
        sounds: selectedSound.value != null ? {selectedSound.value!} : <CrySound>{},
        volume: selectedVolume.value != null ? {selectedVolume.value!} : <CryVolume>{},
        rhythm: selectedRhythm.value != null ? {selectedRhythm.value!} : <CryRhythm>{},
        duration: selectedDuration.value != null ? {selectedDuration.value!} : <CryDuration>{},
        behaviour: selectedBehaviour.value != null ? {selectedBehaviour.value!} : <CryBehaviour>{},
        comment: comment.value.isEmpty ? null : comment.value,
      );

      eventsController.addCryEvent(event);
    }

    Get.back();
    _reset();
  }

  // Edit existing event
  void editEvent(CryEvent event) {
    isEditMode.value = true;
    editingEventId = event.id;
    time.value = event.time;

    // Load data from event (single selections)
    selectedSound.value = event.sounds.isNotEmpty ? event.sounds.first : null;
    selectedVolume.value = event.volume.isNotEmpty ? event.volume.first : null;
    selectedRhythm.value = event.rhythm.isNotEmpty ? event.rhythm.first : null;
    selectedDuration.value = event.duration.isNotEmpty ? event.duration.first : null;
    selectedBehaviour.value = event.behaviour.isNotEmpty ? event.behaviour.first : null;

    comment.value = event.comment ?? '';
  }

  // Reset state
  void _reset() {
    isEditMode.value = false;
    editingEventId = null;
    time.value = DateTime.now();
    selectedSound.value = null;
    selectedVolume.value = null;
    selectedRhythm.value = null;
    selectedDuration.value = null;
    selectedBehaviour.value = null;
    comment.value = '';
  }

  // Public reset method for external use
  void reset() {
    _reset();
  }
}
