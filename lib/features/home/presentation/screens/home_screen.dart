import 'package:chasingharmony_fluttere/app/controller/app_ground_controller.dart';
import 'package:chasingharmony_fluttere/features/messages/presentation/widget/mode_select_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                      Image(
                        image: AssetImage('assets/logo/Frame1.png'),
                        width: 40,
                        height: 40,
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xFF1B062D),
                          border: Border.all(
                            color: Color(0xFF342240),
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
                      width: 240,
                      height: 240,
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
                    height: 60,
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

                  /// Chat List
                  const ChatItem(title: 'Simplify how meditation works'),

                  const ChatItem(
                    title: 'Explore different meditation techniques',
                  ),

                  const ChatItem(
                    title: 'Incorporate mindfulness into daily routines',
                  ),

                  const ChatItem(
                    title: 'Learn breathing exercises for stress relief',
                  ),

                  const ChatItem(title: 'Build a better sleeping routine'),

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
  final String title;

  const ChatItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const Icon(Icons.more_vert, color: Colors.white, size: 20),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.title,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: isSelected
            ? const LinearGradient(
                colors: [Color(0xFF7A1BFF), Color(0xFF6D00D7)],
              )
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
