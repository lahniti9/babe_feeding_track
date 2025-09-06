import 'package:get/get.dart';
import '../models/child_profile.dart';
import '../services/children_store.dart';

class EditChildController extends GetxController {
  final ChildProfile original;
  
  EditChildController(this.original) {
    name.value = original.name;
    gender.value = original.gender;
    birth.value = original.birthDate;
    avatar.value = original.avatar;
  }
  
  final name = ''.obs;
  final gender = BabyGender.girl.obs;
  final birth = DateTime.now().obs;
  final avatar = RxnString();

  void save() {
    Get.find<ChildrenStore>().update(
      ChildProfile(
        id: original.id,
        name: name.value.trim().isEmpty ? 'Baby' : name.value.trim(),
        gender: gender.value,
        birthDate: birth.value,
        avatar: avatar.value,
      ),
    );
    Get.back();
  }

  void deleteProfile() {
    Get.find<ChildrenStore>().remove(original.id);
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
