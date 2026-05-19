import 'package:chasingharmony_fluttere/app/controller/app_ground_controller.dart';
import 'package:chasingharmony_fluttere/core/theme/app_colors.dart';
import 'package:chasingharmony_fluttere/features/home/presentation/screens/home_screen.dart';
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
    const Scaffold(),
    const Scaffold(),
    const Scaffold(),
  ];

  final List<dynamic> icons = [
    Icons.home_outlined,
    Icons.chat_bubble_outline_rounded,
    Icons.checklist_rtl_rounded,
    'assets/image/safety.png',
  ];

  final List<String> labelKeys = const [
    'nav.home',
    'nav.chat',
    'nav.checklist',
    'nav.safetyTips',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppGroundController>();
    return Scaffold(
      body: Obx(() => pages[controller.currentIndex.value]),
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 84,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFD7D7D7), width: 1)),
          ),
          child: Obx(
            () => Row(
              children: List.generate(labelKeys.length, (index) {
                final isSelected = controller.currentIndex.value == index;
                final iconColor = isSelected
                    ?AppColors.authPrimaryRed
                    :Color(0xFF8B8B8B);
                
                return Expanded(
                  child: InkWell(
                    onTap: () => controller.currentIndex.value = index,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icons[index] is IconData)
                          Icon(
                            icons[index],
                            size: 30,
                            color: iconColor,
                          )
                        else
                          Image.asset(
                            icons[index],
                            height: 30,
                            width: 30,
                            color: iconColor,
                          ),
                        const SizedBox(height: 4),
                        Text(
                          labelKeys[index].tr,
                          style: TextStyle(
                            color: iconColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
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
    );
  }
}
