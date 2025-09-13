import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/event_record.dart';
import '../services/events_store.dart';
import '../../children/services/children_store.dart';

class FoodController extends GetxController {
  final time = DateTime.now().obs;
  final food = ''.obs;
  final amount = 'taste'.obs;
  final reaction = <String>{}.obs;

  void setTime(DateTime newTime) {
    time.value = newTime;
  }

  void setFood(String newFood) {
    food.value = newFood;
  }

  void setAmount(String newAmount) {
    amount.value = newAmount.toLowerCase().replaceAll(' ', '_');
  }

  void toggleReaction(String reactionOption) {
    if (reaction.contains(reactionOption.toLowerCase())) {
      reaction.remove(reactionOption.toLowerCase());
    } else {
      reaction.add(reactionOption.toLowerCase());
    }
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

    await Get.find<EventsStore>().add(EventRecord(
      id: const Uuid().v4(),
      childId: activeChildId,
      type: EventType.food,
      startAt: time.value,
      data: {
        'food': food.value,
        'amount': amount.value,
        'reaction': reaction.toList(),
      },
    ));

    Get.back();
  }
}
