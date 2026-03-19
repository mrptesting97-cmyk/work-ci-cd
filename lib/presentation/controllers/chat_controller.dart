import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/datasources/ai_remote_datasource.dart';
import 'property_form_controller.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class ChatController extends GetxController {
  var isPanelOpen = false.obs;
  var isTyping = false.obs;
  var messages = <ChatMessage>[].obs;
  final textController = TextEditingController();

  final AIRemoteDataSource _aiRemoteDataSource = AIRemoteDataSource();

  // Current screen context to send to AI
  var currentScreenContext = 'home'.obs;
  var currentFormData = {}.obs;

  void toggleChatPanel() {
    isPanelOpen.value = !isPanelOpen.value;
    if (isPanelOpen.value && messages.isEmpty) {
      messages.add(ChatMessage(text: "Hi! I'm your AI assistant. How can I help you set up your property?", isUser: false));
    }
  }

  void updateContext(String screenName, Map<String, dynamic> formData) {
    currentScreenContext.value = screenName;
    currentFormData.value = formData;
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    messages.add(ChatMessage(text: text, isUser: true));
    textController.clear();
    isTyping.value = true;

    try {
      final response = await _aiRemoteDataSource.getAiResponse(
        query: text,
        screenContext: currentScreenContext.value,
        formData: currentFormData,
      );
      
      // Try to parse command and trigger auto-fill if necessary
      _handleAiCommand(response);

      messages.add(ChatMessage(text: response['message'], isUser: false));
    } catch (e) {
      messages.add(ChatMessage(text: "Sorry, I encountered an error linking to my AI brain.", isUser: false));
    } finally {
      isTyping.value = false;
    }
  }

  void _handleAiCommand(Map<String, dynamic> response) {
    if (response.containsKey('action') && response['action'] == 'autofill') {
      final fillData = response['data'];
      try {
        final formCtrl = Get.find<PropertyFormController>();
        formCtrl.handleAutofill(fillData);
      } catch (e) {
        debugPrint("Form controller not active");
      }
    }
  }
}
