import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/onboarding_controller.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: controller.totalPages,
                onPageChanged: (index) => controller.currentPage.value = index,
                itemBuilder: (context, index) {
                  return RepaintBoundary(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.home_work, size: 100, color: Colors.blueAccent),
                          const SizedBox(height: 24),
                          Text(
                            'Welcome Host ${index + 1}',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          const Text('Earn money by hosting your property.'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: controller.skip, child: const Text('Skip')),
                  Obx(() => ElevatedButton(
                    onPressed: controller.nextPage,
                    child: Text(
                      controller.currentPage.value == controller.totalPages - 1
                          ? 'Start Hosting'
                          : 'Next',
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
