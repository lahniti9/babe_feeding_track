import 'package:get/get.dart';
import '../models/event.dart';
import 'events_controller.dart';

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
    
    final event = EventModel(
      id: editingEventId ?? 'event_${DateTime.now().millisecondsSinceEpoch}',
      kind: EventKind.bedtimeRoutine,
      time: time.value,
      title: 'Bedtime routine',
      subtitle: steps.join(', '),
      tags: [],
      showPlus: true,
    );
    
    final eventsController = Get.find<EventsController>();
    if (isEditMode.value && editingEventId != null) {
      // Update existing event
      eventsController.remove(editingEventId!);
    }
    eventsController.addEvent(event);
    
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

  // Check if form is valid
  bool get isValid {
    return steps.isNotEmpty;
  }

  // Get selected steps count
  int get selectedCount {
    return steps.length;
  }
}
