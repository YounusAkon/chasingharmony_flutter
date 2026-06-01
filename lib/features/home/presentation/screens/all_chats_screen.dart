import 'package:chasingharmony_fluttere/app/controller/app_ground_controller.dart';
import 'package:chasingharmony_fluttere/features/home/presentation/widgets/chat_item.dart';
import 'package:chasingharmony_fluttere/features/messages/controller/chat_flow_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllChatsScreen extends StatefulWidget {
  const AllChatsScreen({super.key});

  @override
  State<AllChatsScreen> createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> {
  late final ChatFlowController _chatController;

  @override
  void initState() {
    super.initState();
    _chatController = Get.find<ChatFlowController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _chatController.fetchRecentChats();
    });
  }

  Future<void> _openChat(String chatId) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Color(0xFF9D00FF))),
      barrierDismissible: false,
    );

    final success = await _chatController.loadSession(chatId);
    if (Get.isDialogOpen == true) {
      Get.back();
    }

    if (success) {
      Get.back();
      Get.find<AppGroundController>().changeTab(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/backgroundimage.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: Get.back,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B062D),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF342240),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'All Chats',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Obx(() {
                      if (_chatController.isLoadingRecentChats.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF9D00FF),
                          ),
                        );
                      }

                      if (_chatController.recentChats.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline_rounded,
                                color: Colors.white.withValues(alpha: 0.3),
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No chats yet.',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _chatController.recentChats.length,
                        itemBuilder: (context, index) {
                          final chat = _chatController.recentChats[index];
                          return ChatItem(
                            chat: chat,
                            onTap: () => _openChat(chat.id),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
