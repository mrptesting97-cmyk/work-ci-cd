import 'package:get/get.dart';
import '../../domain/entities/property.dart';
import '../../domain/repositories/property_repository.dart';

class DashboardController extends GetxController {
  final PropertyRepository repository;

  var isLoading = true.obs;
  var properties = <Property>[].obs;

  var totalProperties = 0.obs;
  var activeBookings = 12.obs;
  var totalEarnings = 4500.0.obs;

  DashboardController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    fetchProperties();
  }

  void fetchProperties() async {
    isLoading.value = true;
    final result = await repository.getProperties();
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (data) {
        properties.value = data;
        totalProperties.value = data.length;
      }
    );
    isLoading.value = false;
  }

  void goToCreateProperty() {
    Get.toNamed('/property_form');
  }
}
