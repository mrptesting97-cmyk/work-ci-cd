import 'package:get/get.dart';
import '../../presentation/screens/property_form/property_form_screen.dart';
import '../../presentation/controllers/property_form_controller.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/controllers/onboarding_controller.dart';
import '../../presentation/screens/dashboard/dashboard_screen.dart';
import '../../presentation/controllers/dashboard_controller.dart';
import '../../data/repositories/property_repository_impl.dart';

class AppPages {
  // ignore: constant_identifier_names
  static const INITIAL = '/onboarding';

  static final routes = [
    GetPage(
      name: '/onboarding',
      page: () => const OnboardingScreen(),
      binding: BindingsBuilder(() {
        Get.put(OnboardingController());
      }),
    ),
    GetPage(
      name: '/dashboard',
      page: () => const DashboardScreen(),
      binding: BindingsBuilder(() {
        Get.put(DashboardController(repository: PropertyRepositoryImpl()));
      }),
    ),
    GetPage(
      name: '/property_form',
      page: () => const PropertyFormScreen(),
      binding: BindingsBuilder(() {
        Get.put(PropertyFormController());
      }),
    )
  ];
}
