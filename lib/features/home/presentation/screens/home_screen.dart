import 'package:chasingharmony_fluttere/app/controller/app_ground_controller.dart';
import 'package:chasingharmony_fluttere/features/home/presentation/screens/crisis_support_screen.dart';
import 'package:chasingharmony_fluttere/features/messages/presentation/widget/mode_select_screen.dart';
import 'package:chasingharmony_fluttere/features/messages/controller/chat_flow_controller.dart';
import 'package:chasingharmony_fluttere/features/messages/model/recent_chat-model.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      /// Bottom Navigation
      body: Stack(
        children: [
          /// Fixed Background Image
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
                  const Text(
                    'Recent Chat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
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
                                color: Colors.white.withOpacity(0.3),
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No recent chats yet.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Start a new session above to begin your journey!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _chatController.recentChats.length,
                      itemBuilder: (context, index) {
                        final chat = _chatController.recentChats[index];
                        return ChatItem(
                          chat: chat,
                          onTap: () async {
                            // Show loading dialog while loading history
                            Get.dialog(
                              const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF9D00FF),
                                ),
                              ),
                              barrierDismissible: false,
                            );

                            final success = await _chatController.loadSession(chat.id);
                            Get.back(); // Dismiss loading dialog

                            if (success) {
                              Get.find<AppGroundController>().changeTab(1);
                            }
                          },
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

class ChatItem extends StatelessWidget {
  final RecentChatModel chat;
  final VoidCallback onTap;

  const ChatItem({
    super.key,
    required this.chat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedDate = _formatTimeAgo(chat.lastMessageAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                // Chat Icon / Indicator
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: chat.crisisFlagged
                          ? [Colors.red.shade400, Colors.red.shade700]
                          : [const Color(0xFF2AA8FF), const Color(0xFFB100FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    chat.crisisFlagged
                        ? Icons.warning_amber_rounded
                        : Icons.chat_bubble_outline_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),

                // Title & Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.title.isEmpty ? 'New Chat' : chat.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.message_outlined,
                            color: Colors.white.withOpacity(0.5),
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${chat.messageCount} messages',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.access_time_rounded,
                            color: Colors.white.withOpacity(0.5),
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Arrow indicator
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.3),
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
