import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/child_profile.dart';
import '../services/children_store.dart';

class AddChildController extends GetxController {
  final name = ''.obs;
  final gender = Rxn<BabyGender>(); // Nullable to require selection
  final birth = DateTime.now().subtract(const Duration(days: 30)).obs; // Default to 1 month ago
  final avatar = RxnString();

  // Enhanced validation requiring name, gender, and valid birth date
  bool get canSubmit {
    final hasValidName = name.value.trim().isNotEmpty;
    final hasValidGender = gender.value != null;
    final hasValidBirth = birth.value.isBefore(DateTime.now().add(const Duration(hours: 1))); // Allow today but not future

    return hasValidName && hasValidGender && hasValidBirth;
  }

  // Individual validation getters for UI feedback
  bool get hasValidName => name.value.trim().isNotEmpty;
  bool get hasValidGender => gender.value != null;
  bool get hasValidBirth => birth.value.isBefore(DateTime.now().add(const Duration(hours: 1)));

  // Get validation message for submit button
  String get submitButtonText {
    if (!hasValidName && !hasValidGender) {
      return 'Please enter name and select gender';
    } else if (!hasValidName) {
      return 'Please enter baby\'s name';
    } else if (!hasValidGender) {
      return 'Please select gender';
    } else if (!hasValidBirth) {
      return 'Please select a valid birth date';
    } else {
      return 'Add Child';
    }
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
