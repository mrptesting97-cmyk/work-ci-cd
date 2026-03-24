import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/chat/chat_panel.dart';
import 'draggable_chat_head.dart';
import '../controllers/chat_controller.dart';
import 'icon_toggle_widget.dart';

class GlobalChatWrapper extends StatelessWidget {
  final Widget child;
  const GlobalChatWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Initialize ChatController globally
    Get.put(ChatController(), permanent: true);

    // Key to access the child (which contains the app's Navigator)
    final GlobalKey _childKey = GlobalKey();

    return Material(
      color: Colors.transparent,
      child: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (overlayContext) => Stack(
              children: [
                // Wrap the real app child with a KeyedSubtree so we can obtain its context
                KeyedSubtree(key: _childKey, child: child),
                const DraggableChatHead(),
                const ChatPanelOverlay(),
                // Global floating button to open the icon toggle from any screen
                Positioned(
                  right: 16,
                  bottom: 96,
                  child: SafeArea(
                    child: FloatingActionButton(
                      heroTag: 'iconToggle',
                      onPressed: () {
                        final ctx = _childKey.currentContext ?? overlayContext;
                        showModalBottomSheet(
                          context: ctx,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          builder: (_) => Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(ctx).viewInsets.bottom,
                            ),
                            child: const IconToggleWidget(),
                          ),
                        );
                      },
                      child: const Icon(Icons.color_lens),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
