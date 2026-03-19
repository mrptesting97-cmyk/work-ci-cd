import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chat_controller.dart';

class ChatPanelOverlay extends StatefulWidget {
  const ChatPanelOverlay({super.key});

  @override
  State<ChatPanelOverlay> createState() => _ChatPanelOverlayState();
}

class _ChatPanelOverlayState extends State<ChatPanelOverlay> {
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  late ChatController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ChatController>();
    // Auto-scroll when messages change
    ever(_controller.messages, (_) => _scrollToBottom());
    ever(_controller.isTyping, (_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend() {
    if (_controller.textController.text.trim().isEmpty) return;
    _controller.sendMessage();
    _focusNode.requestFocus(); // Keep focus after sending
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!_controller.isPanelOpen.value) return const SizedBox.shrink();

      final bottomInset = MediaQuery.of(context).viewInsets.bottom;
      final screenWidth = MediaQuery.of(context).size.width;
      final panelWidth = screenWidth > 360 ? 320.0 : screenWidth - 40;

      return Positioned(
        right: 20,
        bottom: 80 + (bottomInset > 0 ? bottomInset + 5 : 0),
        width: panelWidth,
        height: 450,
        child: Material(
          elevation: 20,
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('AI Host Assistant', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 20),
                      onPressed: _controller.toggleChatPanel,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  ],
                ),
              ),

              // Chat Messages
              Expanded(
                child: Obx(() => ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: _controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = _controller.messages[index];
                    return Align(
                      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: msg.isUser ? Colors.blue[600] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          msg.text,
                          style: TextStyle(color: msg.isUser ? Colors.white : Colors.black87),
                        ),
                      ),
                    );
                  },
                )),
              ),

              // Typing status
              Obx(() => _controller.isTyping.value 
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('AI is thinking...', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    )
                  : const SizedBox.shrink()),

              // Input Field
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[200]!)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller.textController,
                        focusNode: _focusNode,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _handleSend(),
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white, size: 18),
                        onPressed: _handleSend,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
