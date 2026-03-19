import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/property_form_controller.dart';

class PropertyFormScreen extends GetView<PropertyFormController> {
  const PropertyFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensuring the controller updates AI Context on build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.updateAiContext();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Add Property')),
      body: Obx(() => Stepper(
        currentStep: controller.currentStep.value,
        onStepContinue: controller.nextStep,
        onStepCancel: controller.previousStep,
        steps: [
          Step(
            title: const Text('Property Type & Location'),
            content: Column(
              children: [
                TextField(
                  controller: controller.titleController,
                  decoration: const InputDecoration(labelText: 'Property Title'),
                  onChanged: (v) => controller.title.value = v,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: controller.propertyType.value.isEmpty ? null : controller.propertyType.value,
                  items: ['Apartment', 'House', 'Villa'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => controller.propertyType.value = v ?? '',
                  decoration: const InputDecoration(labelText: 'Type'),
                )
              ],
            ),
            isActive: controller.currentStep.value >= 0,
          ),
          Step(
            title: const Text('Details & Amenities'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Rooms:'),
                    IconButton(icon: const Icon(Icons.remove), onPressed: () => controller.rooms.value--),
                    Text('${controller.rooms.value}'),
                    IconButton(icon: const Icon(Icons.add), onPressed: () => controller.rooms.value++),
                  ],
                ),
                TextField(
                  controller: controller.descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  onChanged: (v) => controller.description.value = v,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: controller.amenities.map((a) => Chip(label: Text(a))).toList(),
                )
              ],
            ),
            isActive: controller.currentStep.value >= 1,
          ),
          Step(
            title: const Text('Photos'),
            content: const Center(child: Text('Image Upload UI (Lazy loaded) - RepaintBoundary for optimization')),
            isActive: controller.currentStep.value >= 2,
          ),
          Step(
            title: const Text('Pricing'),
            content: TextField(
              controller: controller.priceController,
              decoration: const InputDecoration(labelText: 'Price per night (\$)'),
              keyboardType: TextInputType.number,
              onChanged: (v) => controller.price.value = double.tryParse(v) ?? 0,
            ),
            isActive: controller.currentStep.value >= 3,
          ),
          Step(
            title: const Text('Review'),
            content: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title: ${controller.title.value}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('Type: ${controller.propertyType.value}'),
                  const SizedBox(height: 4),
                  Text('Rooms: ${controller.rooms.value}'),
                  const SizedBox(height: 4),
                  Text('Price: \$${controller.price.value} / night'),
                  const SizedBox(height: 4),
                  Text('Amenities: ${controller.amenities.join(", ")}'),
                ],
              ),
            ),
            isActive: controller.currentStep.value >= 4,
          )
        ],
      )),
    );
  }
}
