import 'package:get/get.dart';
import '../models/event.dart';
import 'events_controller.dart';
import '../../children/services/children_store.dart';

class BedtimeRoutineController extends GetxController {
  // Time selection
  final Rx<DateTime> time = DateTime.now().obs;
  
  // Selected steps
  final RxSet<String> steps = <String>{}.obs;
  
  // Edit mode
  final RxBool isEditMode = false.obs;
  String? editingEventId;
  
  // Available bedtime routine steps
  final List<String> availableSteps = [
    'Bathing',
    'Massage',
    'Swaddling',
    'Rocking in arms',
    'Lullaby',
    'White noise',
    'Reading',
    'Feeding',
    'Diaper change',
    'Pajamas',
  ];

  // Toggle step selection
  void toggleStep(String step) {
    if (steps.contains(step)) {
      steps.remove(step);
    } else {
      steps.add(step);
    }
  }

  // Set time
  void setTime(DateTime newTime) {
    time.value = newTime;
  }

  // Save bedtime routine
  void save() {
    if (steps.isEmpty) return;

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

    final event = EventModel(
      id: editingEventId ?? 'event_${DateTime.now().millisecondsSinceEpoch}',
      childId: activeChildId,
      kind: EventKind.bedtimeRoutine,
      time: time.value,
      title: 'Bedtime routine',
      subtitle: steps.join(', '),
      tags: [],
      showPlus: true,
    );

    final eventsController = Get.find<EventsController>();

    if (isEditMode.value && editingEventId != null) {
      // Update existing event using the same pattern as comment updating
      final eventIndex = eventsController.events.indexWhere((e) =>
        (e is EventModel && e.id == editingEventId));

      if (eventIndex >= 0) {
        // Update the event in place (same pattern as updateComment method)
        eventsController.events[eventIndex] = event;
        // Manually trigger the save by calling the private method through reflection
        // or use the remove/add pattern that's already working
        eventsController.remove(editingEventId!, skipConfirmation: true);
        eventsController.addEvent(event);
      }
    } else {
      // Add new event
      eventsController.addEvent(event);
    }

    Get.back();
    _reset();
  }

  // Edit existing event
  void editEvent(EventModel event) {
    isEditMode.value = true;
    editingEventId = event.id;
    time.value = event.time;
    
    // Parse steps from subtitle
    if (event.subtitle != null) {
      final eventSteps = event.subtitle!.split(', ');
      steps.clear();
      steps.addAll(eventSteps);
    }
  }

  // Reset state
  void _reset() {
    isEditMode.value = false;
    editingEventId = null;
    time.value = DateTime.now();
    steps.clear();
  }

  // Public reset method for external use
  void reset() {
    _reset();
  }

  // Check if form is valid
  bool get isValid {
    return steps.isNotEmpty;
  }

  // Get selected steps count
  int get selectedCount {
    return steps.length;
  }
}
