import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/chat/chat_panel.dart';
import 'draggable_chat_head.dart';
import '../controllers/chat_controller.dart';

class GlobalChatWrapper extends StatelessWidget {
  final Widget child;
  const GlobalChatWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Initialize ChatController globally
    Get.put(ChatController(), permanent: true);

    return Material(
      color: Colors.transparent,
      child: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (context) => Stack(
              children: [
                child, // The Navigator/Main App
                const DraggableChatHead(),
                const ChatPanelOverlay(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
