import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;
  final int totalPages = 3;

  void nextPage() {
    if (currentPage.value < totalPages - 1) {
      currentPage.value++;
    } else {
      // Create new host id (simulated) and go to dashboard
      Get.offNamed('/dashboard');
    }
  }

  void skip() {
    Get.offNamed('/dashboard');
  }
}
