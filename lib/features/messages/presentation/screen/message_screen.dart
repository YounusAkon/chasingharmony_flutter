import 'package:chasingharmony_fluttere/features/messages/controller/chat_flow_controller.dart';
import 'package:chasingharmony_fluttere/features/messages/presentation/widget/mode_select_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CelysChatScreen extends StatelessWidget {
  const CelysChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatFlowController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/image/Profile.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => MoodSelectionDialog.show(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF56018A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add_reaction_outlined,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xFF1B062D),
                          border: Border.all(
                            color: const Color(0xFF342240),
                            width: 1,
                          ),
                        ),
                        child: const Text(
                          'Get CELYS +',
                          style: TextStyle(
                            color: Color(0xFF9D00FF),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Expanded(
                    child: Obx(() {
                      final messages = controller.messages;
                      if (messages.isEmpty) {
                        return const _EmptyChatState();
                      }

                      return ListView.separated(
                        controller: controller.scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: messages.length,
                        separatorBuilder: (_, index) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          return _MessageBubble(message: messages[index]);
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: TextField(
                                controller: controller.inputController,
                                decoration: const InputDecoration(
                                  hintText: 'Type a message...',
                                  hintStyle: TextStyle(color: Colors.black),
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(color: Colors.black),
                                textInputAction: TextInputAction.send,
                                onSubmitted: (_) => controller.sendTypedMessage(),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: controller.isSendingMessage.value
                                ? null
                                : controller.sendTypedMessage,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Color(0xFF6B4EFF),
                                shape: BoxShape.circle,
                              ),
                              child: controller.isSendingMessage.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.send_rounded,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyChatState extends StatelessWidget {
  const _EmptyChatState();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          "Hi! I'm CELYS AI. Start a mood check-in or type your situation to begin.",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatUiMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: isUser ? 72 : 0, right: isUser ? 0 : 72),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: isUser ? const Color(0xFF6B4EFF) : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            message.content,
            style: TextStyle(
              color: isUser ? Colors.white : Colors.black87,
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}
