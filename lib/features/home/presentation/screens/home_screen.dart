import 'package:chasingharmony_fluttere/app/controller/app_ground_controller.dart';
import 'package:chasingharmony_fluttere/core/theme/app_colors.dart';
import 'package:chasingharmony_fluttere/features/home/controller/safety_tips_controller.dart';
import 'package:chasingharmony_fluttere/features/home/model/safety_tips_model.dart';
import 'package:chasingharmony_fluttere/features/home/presentation/screens/safety_tips_details.dart';
import 'package:chasingharmony_fluttere/features/notification/presentation/notification_screen.dart';
import 'package:chasingharmony_fluttere/features/onbording/common/app_logo.dart';
import 'package:chasingharmony_fluttere/features/profile/controller/get_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  ProfileController _profileController() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.put<ProfileController>(ProfileController(), permanent: true);
    }
    return Get.find<ProfileController>();
  }

  // MessageController _messageController() {
  //   if (!Get.isRegistered<MessageController>()) {
  //     Get.put<MessageController>(
  //       MessageController(
  //         homeInterface: Get.find<HomeInterface>(),
  //         historyInt: Get.find<HistoryInt>(),
  //       ),
  //       permanent: true,
  //     );
  //   }
  //   return Get.find<MessageController>();
  // }

  @override
  Widget build(BuildContext context) {
    final profileController = _profileController();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(profileController),
              const SizedBox(height: 12),
              Obx(
                () => Text(
                  'home.greeting'.trParams(<String, String>{
                    'name': _resolveGreetingName(profileController),
                  }),
                  style: TextStyle(
                    color: Color(0xFF9A9A9A),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'home.subtitle'.tr,
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 12),
              // _buildStartChatCard(context),
              const SizedBox(height: 14),
              // _sectionTitle('home.emergencyType'.tr),
              // const SizedBox(height: 10),
              // _buildEmergencyButtons(context),
              // const SizedBox(height: 16),
              Row(
                children: [
                  _sectionTitle('home.safetyTips'.tr),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Get.find<AppGroundController>().changeTab(3);
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'home.viewAll'.tr,
                      style: TextStyle(
                        color: Color(0xFF0077D9),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildTipsList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ProfileController profileController) {
    return Row(
      children: [
        const AppLogo(height: 32, width: 100),
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            InkWell(
              onTap: () => Get.to(() => NotificationsScreen()),
              borderRadius: BorderRadius.circular(999),
              child: const SizedBox(
                width: 30,
                height: 30,
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.authPrimaryRed,
                  size: 28,
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF4BDA6A),
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
        InkWell(
          onTap: () => Get.find<AppGroundController>().changeTab(2),
          borderRadius: BorderRadius.circular(999),
          child: Obx(
            () => _buildProfileAvatar(
              imageUrl: profileController.profile.value?.avatar?.url,
              size: 40,
              iconSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  String _resolveGreetingName(ProfileController profileController) {
    final profile = profileController.profile.value;
    final candidates = [
      profile?.name,
      profile?.fullName,
      profile?.firstName,
      profile?.username,
    ];

    for (final candidate in candidates) {
      final value = candidate?.trim() ?? '';
      if (value.isNotEmpty) {
        return value;
      }
    }

    final email = profile?.email?.trim() ?? '';
    if (email.isNotEmpty) {
      return email.split('@').first;
    }

    return 'common.user'.tr;
  }

  Widget _buildProfileAvatar({
    required String? imageUrl,
    required double size,
    required double iconSize,
  }) {
    final trimmedUrl = imageUrl?.trim() ?? '';
    final hasImage = trimmedUrl.isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
        gradient: hasImage
            ? null
            : const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFCC9A7A), Color(0xFF84533D)],
              ),
        color: hasImage ? const Color(0xFFE7E7E7) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: hasImage
            ? Image.network(
                trimmedUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: iconSize,
                ),
              )
            : Icon(Icons.person_rounded, color: Colors.white, size: iconSize),
      ),
    );
  }

  // Future<void> _sendStartChatMessage(BuildContext context) async {
  //   final messenger = ScaffoldMessenger.of(context);
  //   final messageController = _messageController();
  //   final text = messageController.inputController.text.trim();

  //   if (text.isEmpty || messageController.isSending.value) {
  //     return;
  //   }

  //   FocusScope.of(context).unfocus();

  //   final isSuccess = await messageController.startEmergencyChat(
  //     emergencyType: 'General',
  //     initialMessage: text,
  //   );

  //   if (!isSuccess) {
  //     messenger.showSnackBar(
  //       SnackBar(content: Text(MessageController.friendlyDeliveryError)),
  //     );
  //     return;
  //   }

  //   messageController.inputController.clear();
  //   if (!context.mounted) return;
  //   if (!context.mounted) return;
  //   Get.find<AppGroundController>().changeTab(1);
  // }

  // Widget _buildStartChatCard(BuildContext context) {
  //   final messageController = _messageController();

  //   return Container(
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       gradient: const LinearGradient(
  //         begin: Alignment.centerLeft,
  //         end: Alignment.centerRight,
  //         colors: [Color(0xFFF1DADF), Color(0xFFD8E9F7)],
  //       ),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
  //     child: LayoutBuilder(
  //       builder: (context, constraints) {
  //         final robotSize = (constraints.maxWidth * 0.3).clamp(90.0, 116.0);

  //         return Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           Image.asset(
  //                             'assets/image/message.png',
  //                             width: 34,
  //                             height: 32,
  //                           ),
  //                           const SizedBox(width: 10),
  //                           Flexible(
  //                             child: Text(
  //                               'home.startChat'.tr,
  //                               maxLines: 1,
  //                               overflow: TextOverflow.ellipsis,
  //                               style: TextStyle(
  //                                 color: Color(0xFF232328),
  //                                 fontSize: 24,
  //                                 fontWeight: FontWeight.w500,
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       const SizedBox(height: 8),
  //                       Text(
  //                         'home.startChatBody'.tr,
  //                         style: TextStyle(
  //                           color: Color(0xFF5B5E63),
  //                           fontSize: 18,
  //                           height: 1.35,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 const SizedBox(width: 8),
  //                 SizedBox(
  //                   width: robotSize,
  //                   height: robotSize,
  //                   child: Image.asset(
  //                     'assets/image/image.png',
  //                     fit: BoxFit.contain,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 10),
  //             Obx(
  //               () => Container(
  //                 width: double.infinity,
  //                 height: 52,
  //                 padding: const EdgeInsets.fromLTRB(16, 4, 6, 4),
  //                 decoration: BoxDecoration(
  //                   color: const Color(0xFFFFFFFF),
  //                   borderRadius: BorderRadius.circular(32),
  //                   border: Border.all(color: Colors.red),
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     Expanded(
  //                       child: TextField(
  //                         controller: messageController.inputController,
  //                         enabled: !messageController.isSending.value,
  //                         textInputAction: TextInputAction.send,
  //                         onSubmitted: (_) => _sendStartChatMessage(context),
  //                         decoration: InputDecoration(
  //                           isDense: true,
  //                           border: InputBorder.none,
  //                           hintText: 'home.typeMessage'.tr,
  //                           hintStyle: const TextStyle(
  //                             color: Color.fromARGB(255, 101, 101, 101),
  //                             fontSize: 15,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     GestureDetector(
  //                       onTap: messageController.isSending.value
  //                           ? null
  //                           : () => _sendStartChatMessage(context),
  //                       child: Container(
  //                         width: 34,
  //                         height: 34,
  //                         alignment: Alignment.center,
  //                         decoration: BoxDecoration(
  //                           color: const Color(0xFFD7DBE1),
  //                           borderRadius: BorderRadius.circular(17),
  //                         ),
  //                         child: messageController.isSending.value
  //                             ? const SizedBox(
  //                                 width: 16,
  //                                 height: 16,
  //                                 child: CircularProgressIndicator(
  //                                   strokeWidth: 1.8,
  //                                   color: Color(0xFF5A6472),
  //                                 ),
  //                               )
  //                             : Transform.rotate(
  //                                 angle: -0.35,
  //                                 child: const Icon(
  //                                   Icons.near_me_rounded,
  //                                   color: Color(0xFF98A1AE),
  //                                   size: 20,
  //                                 ),
  //                               ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }

  // Widget _buildEmergencyButtons(BuildContext context) {
  //   final items = <_EmergencyItem>[
  //     _EmergencyItem(
  //       label: 'emergency.fire'.tr,
  //       assetPath: 'assets/image/fire.png',
  //       initialMessage: 'emergency.firePrompt'.tr,
  //       colors: [Color(0xFFE8292E), Color(0xFFCC1D24)],
  //     ),
  //     _EmergencyItem(
  //       label: 'emergency.earthquake'.tr,
  //       assetPath: 'assets/image/earthquake.png',
  //       initialMessage: 'emergency.earthquakePrompt'.tr,
  //       colors: [Color(0xFF0EA748), Color(0xFF098A3B)],
  //     ),
  //     _EmergencyItem(
  //       label: 'emergency.firstAid'.tr,
  //       assetPath: 'assets/image/firstaid.png',
  //       initialMessage: 'emergency.firstAidPrompt'.tr,
  //       colors: [Color(0xFF0E78D2), Color(0xFF0A63B7)],
  //     ),
  //     _EmergencyItem(
  //       label: 'emergency.blackout'.tr,
  //       assetPath: 'assets/image/blackout.png',
  //       initialMessage: 'emergency.blackoutPrompt'.tr,
  //       colors: [Color(0xFF2A2A2A), Color(0xFF121212)],
  //     ),
  //   ];

  //   final itemWidth = (MediaQuery.sizeOf(context).width - 28) / 2;

  //   return Wrap(
  //     spacing: 8,
  //     runSpacing: 8,
  //     children: items.map((item) {
  //       return SizedBox(
  //         width: itemWidth,
  //         child: InkWell(
  //           borderRadius: BorderRadius.circular(999),
  //           onTap: () async {
  //             final messenger = ScaffoldMessenger.of(context);
  //             final messageController = _messageController();

  //             showDialog<void>(
  //               context: context,
  //               barrierDismissible: false,
  //               builder: (_) =>
  //                   const Center(child: CircularProgressIndicator()),
  //             );

  //             final isSuccess = await messageController.startEmergencyChat(
  //               emergencyType: item.label,
  //               initialMessage: item.initialMessage,
  //             );

  //             if (context.mounted) {
  //               Navigator.of(context, rootNavigator: true).pop();
  //             }

  //             if (!isSuccess) {
  //               messenger.showSnackBar(
  //                 SnackBar(
  //                   content: Text(MessageController.friendlyDeliveryError),
  //                 ),
  //               );
  //             }

  //             if (!context.mounted) return;
  //             Get.find<AppGroundController>().changeTab(1);
  //           },
  //           child: Container(
  //             height: 44,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(999),
  //               gradient: LinearGradient(colors: item.colors),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.black.withValues(alpha: 0.14),
  //                   blurRadius: 9,
  //                   offset: const Offset(0, 4),
  //                 ),
  //               ],
  //             ),
  //             padding: const EdgeInsets.symmetric(horizontal: 8),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 if (item.assetPath != null) ...[
  //                   Image.asset(
  //                     item.assetPath!,
  //                     width: 28,
  //                     height: 28,
  //                     fit: BoxFit.contain,
  //                   ),
  //                   const SizedBox(width: 8),
  //                 ] else if (item.emoji != null) ...[
  //                   Text(item.emoji!, style: const TextStyle(fontSize: 16)),
  //                   const SizedBox(width: 8),
  //                 ],
  //                 Flexible(
  //                   child: FittedBox(
  //                     fit: BoxFit.scaleDown,
  //                     alignment: Alignment.center,
  //                     child: Text(
  //                       item.label,
  //                       maxLines: 1,
  //                       style: const TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }

  Widget _buildTipsList(BuildContext context) {
    final safetyController = Get.find<SafetyTipsController>();

    return Obx(() {
      if (safetyController.isLoading.value && safetyController.items.isEmpty) {
        return const SizedBox(
          height: 198,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      }

      if (safetyController.error.isNotEmpty && safetyController.items.isEmpty) {
        return SizedBox(
          height: 110,
          child: Center(
            child: Text(
              safetyController.error.value,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6C6C6C), fontSize: 12.5),
            ),
          ),
        );
      }

      if (safetyController.items.isEmpty) {
        return SizedBox(
          height: 110,
          child: Center(
            child: Text(
              'home.noSafetyTips'.tr,
              style: TextStyle(color: Color(0xFF6C6C6C), fontSize: 12.5),
            ),
          ),
        );
      }

      final items = safetyController.items.take(8).toList();

      return SizedBox(
        height: 198,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, index) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final item = items[index];

            return InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () async {
                final messenger = ScaffoldMessenger.of(context);
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );

                final tipDetails = await safetyController.getSafetyTipById(
                  item.id,
                );

                if (context.mounted) {
                  Navigator.of(context, rootNavigator: true).pop();
                }

                if (tipDetails == null) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('home.loadSafetyTipFailed'.tr)),
                  );
                  return;
                }

                Get.to(() => SafetyTipsDetailsScreen(tip: tipDetails));
              },
              child: Container(
                width: 146,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE3E3E3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          child: _buildSafetyTipImage(item, height: 102),
                        ),
                        if (item.featured)
                          Positioned(
                            left: 8,
                            bottom: 7,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.92),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'home.essential'.tr,
                                style: const TextStyle(
                                  color: AppColors.authPrimaryRed,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF222222),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
                        child: Text(
                          item.summary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF7A7A7A),
                            fontSize: 10.8,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildSafetyTipImage(SafetyTipModel item, {required double height}) {
    final source = item.displayImageUrl.trim();
    final isNetworkImage =
        source.startsWith('http://') || source.startsWith('https://');

    final isPlaceholder =
        source.contains('ui-avatars') ||
        source.contains('placehold') ||
        source.contains('dummyimage');

    if (source.isEmpty || isPlaceholder) {
      return Container(
        height: height,
        width: double.infinity,
        color: const Color(0xFFE8E8E8),
        alignment: Alignment.center,
        child: const Icon(Icons.auto_stories, size: 90, color: Colors.grey),
      );
    }

    if (isNetworkImage) {
      return Image.network(
        source,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: height,
          width: double.infinity,
          color: const Color(0xFFE8E8E8),
          alignment: Alignment.center,
          child: const Icon(Icons.auto_stories, size: 90, color: Colors.grey),
        ),
      );
    }

    return Image.asset(
      source,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        height: height,
        width: double.infinity,
        color: const Color(0xFFE8E8E8),
        alignment: Alignment.center,
        child: const Icon(Icons.auto_stories, size: 90, color: Colors.grey),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF202020),
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
