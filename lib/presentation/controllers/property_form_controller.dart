import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_controller.dart';

class PropertyFormController extends GetxController {
  var currentStep = 0.obs;

  // Form Fields
  var propertyType = ''.obs;
  var title = ''.obs;
  var rooms = 1.obs;
  var description = ''.obs;
  var amenities = <String>[].obs;
  var price = 0.0.obs;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  void nextStep() {
    if (currentStep.value < 4) {
      currentStep.value++;
      updateAiContext();
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      updateAiContext();
    }
  }

  void updateAiContext() {
    String screen = 'step_${currentStep.value + 1}';
    if (currentStep.value == 3) screen = 'pricing';
    
    try {
      Get.find<ChatController>().updateContext(
        screen,
        {
          'title': title.value,
          'type': propertyType.value,
          'rooms': rooms.value,
        }
      );
    } catch (_) {}
  }

  void handleAutofill(Map<String, dynamic> data) {
    if (data.containsKey('title')) {
      title.value = data['title'];
      titleController.text = title.value;
    }
    if (data.containsKey('description')) {
      description.value = data['description'];
      descriptionController.text = description.value;
    }
    if (data.containsKey('rooms')) rooms.value = data['rooms'];
    if (data.containsKey('type')) propertyType.value = data['type'];
    if (data.containsKey('amenities')) {
      amenities.assignAll((data['amenities'] as List).map((e) => e.toString()));
    }
  }
}
