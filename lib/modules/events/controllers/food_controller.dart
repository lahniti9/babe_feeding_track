import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/event_record.dart';
import '../services/events_store.dart';
import '../../children/services/children_store.dart';

class FoodController extends GetxController {
  final time = DateTime.now().obs;
  final food = ''.obs; // Empty by default for text input
  final amount = 'taste'.obs;
  final reaction = ''.obs; // Changed to single selection

  // Track if we're editing an existing event
  String? editingEventId;

  void setTime(DateTime newTime) {
    time.value = newTime;
  }

  void setFood(String newFood) {
    food.value = newFood; // Keep original case for text input
  }

  void setAmount(String newAmount) {
    amount.value = newAmount.toLowerCase().replaceAll(' ', '_');
  }

  void setReaction(String reactionOption) {
    // Single selection - if same option is selected, deselect it
    if (reaction.value == reactionOption.toLowerCase()) {
      reaction.value = '';
    } else {
      reaction.value = reactionOption.toLowerCase();
    }
  }

  // Edit an existing food event
  void editEvent(EventRecord event) {
    print('FoodController.editEvent called');
    print('Event data: ${event.data}');

    editingEventId = event.id;
    time.value = event.startAt;

    // Load data from event
    final data = event.data;
    food.value = data['food'] as String? ?? '';
    amount.value = data['amount'] as String? ?? 'taste';

    // Handle reaction - convert from list to single selection (take first item if available)
    final reactionData = data['reaction'];
    if (reactionData is List && reactionData.isNotEmpty) {
      reaction.value = reactionData.first.toString();
    } else if (reactionData is String) {
      reaction.value = reactionData;
    } else {
      reaction.value = '';
    }

    print('Setting food to: "${food.value}"');
    print('Setting amount to: "${amount.value}"');
    print('Setting reaction to: "${reaction.value}"');
  }

  // Reset controller to default state
  void reset() {
    editingEventId = null;
    time.value = DateTime.now();
    food.value = '';
    amount.value = 'taste';
    reaction.value = '';
  }

  Future<void> save() async {
    final childrenStore = Get.find<ChildrenStore>();
    final activeChildId = childrenStore.getValidActiveChildId();
    final eventsStore = Get.find<EventsStore>();

    if (activeChildId == null) {
      Get.snackbar(
        'No Child Selected',
        'Please add a child profile before creating events.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final eventRecord = EventRecord(
      id: editingEventId ?? const Uuid().v4(),
      childId: activeChildId,
      type: EventType.food,
      startAt: time.value,
      data: {
        'food': food.value,
        'amount': amount.value,
        'reaction': reaction.value.isEmpty ? [] : [reaction.value], // Store as list for backward compatibility
      },
    );

    if (editingEventId != null) {
      // Update existing event
      await eventsStore.update(eventRecord);
    } else {
      // Create new event
      await eventsStore.add(eventRecord);
    }

    Get.back();
  }
}
