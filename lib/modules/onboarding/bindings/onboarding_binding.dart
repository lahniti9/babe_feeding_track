import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../../survey/survey_controller.dart';
import '../../profile/profile_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(() => OnboardingController());
    Get.lazyPut<SurveyController>(() => SurveyController());
    Get.put<ProfileController>(ProfileController()); // Ensure ProfileController is available
  }
}
