import 'package:chasingharmony_fluttere/app/controller/app_ground_controller.dart';
import 'package:chasingharmony_fluttere/features/home/presentation/screens/all_chats_screen.dart';
import 'package:chasingharmony_fluttere/features/home/presentation/screens/crisis_support_screen.dart';
import 'package:chasingharmony_fluttere/features/home/presentation/widgets/chat_item.dart';
import 'package:chasingharmony_fluttere/features/messages/presentation/widget/mode_select_screen.dart';
import 'package:chasingharmony_fluttere/features/messages/controller/chat_flow_controller.dart';
import 'package:chasingharmony_fluttere/features/profile/presentation/screens/subscription_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ChatFlowController _chatController;

  @override
  void initState() {
    super.initState();
    // Retrieve the controller and trigger background sync of recent chats
    _chatController = Get.find<ChatFlowController>();
    _chatController.fetchRecentChats();
  }

  void _startChat() {
    Get.find<AppGroundController>().changeTab(1);
    MoodSelectionDialog.show();
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
      Get.find<AppGroundController>().changeTab(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      /// Bottom Navigation
      body: Stack(
        children: [
          /// Fixed Background Image gjg
          Positioned.fill(
            child: Image.asset(
              'assets/image/backgroundimage.png',
              fit: BoxFit.cover,
            ),
          ),

          /// Scrollable Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  /// Top Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => CrisisSupportScreen());
                        },
                        child: Image.asset(
                          'assets/logo/Frame1.png',
                          width: 40,
                          height: 40,
                        ),
                      ),

                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Get.to(() => const SubscriptionPlansScreen());
                        },
                        child: Container(
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
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  /// Center Image
                  Center(
                    child: Image.asset(
                      'assets/image/image 1.png',
                      width: 200,
                      height: 200,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Title
                  const Center(
                    child: Text(
                      'What can I help you with today?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Start Chat Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2AA8FF), Color(0xFFB100FF)],
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: _startChat,
                          child: const Center(
                            child: Text(
                              'Start Chat',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 34),

                  /// Recent Chat Title
                  Row(
                    children: [
                      Text(
                        'Recent Chat',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Get.to(() => const AllChatsScreen());
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 6,
                          ),
                          child: Text(
                            'See all',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  /// Chat List from Backend
                  Obx(() {
                    if (_chatController.isLoadingRecentChats.value) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF9D00FF),
                          ),
                        ),
                      );
                    }

                    if (_chatController.recentChats.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline_rounded,
                                color: Colors.white.withValues(alpha: 0.3),
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No recent chats yet.',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Start a new session above to begin your journey!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final recentChats = _chatController.recentChats
                        .take(5)
                        .toList(growable: false);

                    return ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentChats.length,
                      itemBuilder: (context, index) {
                        final chat = recentChats[index];
                        return ChatItem(
                          chat: chat,
                          onTap: () => _openChat(chat.id),
                        );
                      },
                    );
                  }),

                  /// Bottom Space
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
