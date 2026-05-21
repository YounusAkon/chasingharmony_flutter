import 'package:chasingharmony_fluttere/app/controller/app_ground_controller.dart';
import 'package:chasingharmony_fluttere/features/home/presentation/screens/home_screen.dart';
import 'package:chasingharmony_fluttere/features/messages/presentation/screen/message_screen.dart';
import 'package:chasingharmony_fluttere/features/profile/presentation/screens/my_Profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppGround extends StatelessWidget {
  AppGround({super.key, int initialIndex = 0}) {
    final controller = Get.find<AppGroundController>();
    if (initialIndex != 0) {
      controller.currentIndex.value = initialIndex;
    }
  }

  final List<Widget> pages = [
    const HomeScreen(),
    const CelysChatScreen(),
    const MyProfileScreen(),
  ];

  final List<IconData> icons = [
    Icons.home_outlined,
    Icons.chat_bubble_outline_rounded,
    Icons.person_outline_rounded,
  ];

  final List<String> labels = const ['Home', 'Chat', 'Profile'];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppGroundController>();
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 234, 4, 4),
      body: Obx(() => pages[controller.currentIndex.value]),
      // backgroundColor: const Color.fromARGB(0, 234, 6, 6),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
          child: Container(
            height: 76,
            decoration: BoxDecoration(
              color: const Color(
                0xFF131525,
              ), //background color of the bottom navigation bar
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF7B809C),
                width: 1,
              ), //border color and width of the bottom navigation bar
            ),
            child: Obx(
              () => Row(
                children: List.generate(labels.length, (index) {
                  final isSelected = controller.currentIndex.value == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => controller.currentIndex.value = index,
                      behavior: HitTestBehavior.opaque,
                      child: isSelected
                          ? Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF600A8D),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    icons[index],
                                    size: 26,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    labels[index],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  icons[index],
                                  size: 26,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  labels[index],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
