import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/child_profile.dart';
import '../services/children_store.dart';

class AddChildController extends GetxController {
  final name = ''.obs;
  final gender = Rxn<BabyGender>(); // Changed to nullable to require selection
  final birth = DateTime.now().obs;
  final avatar = RxnString();

  // Enhanced validation requiring name and gender
  bool get canSubmit {
    final hasValidName = name.value.trim().isNotEmpty;
    final hasValidGender = gender.value != null;
    final hasValidBirth = birth.value.isBefore(DateTime.now().add(const Duration(days: 1)));

    return hasValidName && hasValidGender && hasValidBirth;
  }



  void submit() {
    if (!canSubmit) return;

    final child = ChildProfile(
      id: const Uuid().v4(),
      name: name.value.trim(),
      gender: gender.value!,
      birthDate: birth.value,
      avatar: avatar.value,
    );
    Get.find<ChildrenStore>().add(child);
    Get.back();
  }

  void updateName(String value) {
    name.value = value;
  }

  void updateGender(BabyGender value) {
    gender.value = value;
  }

  void updateBirth(DateTime value) {
    birth.value = value;
  }

  void updateAvatar(String? value) {
    avatar.value = value;
  }
}
