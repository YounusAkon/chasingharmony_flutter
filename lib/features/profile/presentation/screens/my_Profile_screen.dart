// import 'package:chasingharmony_fluttere/features/profile/controller/get_profile_controller.dart';
// import 'package:chasingharmony_fluttere/features/profile/presentation/screens/logout_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class MyProfileScreen extends StatefulWidget {
//   const MyProfileScreen({super.key});

//   @override
//   State<MyProfileScreen> createState() => _MyProfileScreenState();
// }

// class _MyProfileScreenState extends State<MyProfileScreen> {
//   late final ProfileController _profileController;

//   @override
//   void initState() {
//     super.initState();
//     if (!Get.isRegistered<ProfileController>()) {
//       Get.put<ProfileController>(ProfileController(), permanent: true);
//     }
//     _profileController = Get.find<ProfileController>();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0A),
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.asset('assets/image/Profile.png', fit: BoxFit.cover),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 48),
//                   _buildProfileHeader(),
//                   const SizedBox(height: 40),
//                   _buildMenuItems(),
//                   const SizedBox(height: 60),
//                   _buildLogoutButton(),
//                   const SizedBox(height: 28),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileHeader() {
//     return Column(
//       children: [
//         Stack(
//           children: [
//             Obx(
//               () => _buildAvatar(
//                 imageUrl: _profileController.profile.value?.avatar?.url,
//               ),
//             ),
//             Positioned(
//               bottom: 2,
//               right: 2,
//               child: Container(
//                 width: 28,
//                 height: 28,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFFFFFFF),
//                   shape: BoxShape.circle,
//                   border: Border.all(color: const Color(0xFF0A0A0A), width: 2),
//                 ),
//                 child: const Icon(
//                   Icons.camera_alt_rounded,
//                   size: 18,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 14),
//         Obx(
//           () => Text(
//             _displayName(),
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         const SizedBox(height: 4),
//         Obx(
//           () => Text(
//             _profileController.profile.value?.email?.trim() ?? '',
//             style: const TextStyle(color: Color(0xFF888888), fontSize: 13),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAvatar({required String? imageUrl}) {
//     final trimmedUrl = imageUrl?.trim() ?? '';
//     final hasImage = trimmedUrl.isNotEmpty;

//     return Container(
//       width: 120,
//       height: 120,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         gradient: hasImage
//             ? null
//             : const LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Color(0xFFCC9A7A), Color(0xFF84533D)],
//               ),
//         color: hasImage ? const Color(0xFFE7E7E7) : null,
//       ),
//       child: ClipOval(
//         child: hasImage
//             ? Image.network(
//                 trimmedUrl,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, _, _) => const Icon(
//                   Icons.person_rounded,
//                   color: Colors.white,
//                   size: 40,
//                 ),
//               )
//             : const Icon(Icons.person_rounded, color: Colors.white, size: 40),
//       ),
//     );
//   }

//   Widget _buildMenuItems() {
//     return Column(
//       children: [
//         Obx(
//           () => _menuTile(
//             title: _displayName(),
//             icon: Icons.person_outline_rounded,
//             onTap: () => Get.to(() => Scaffold()),
//           ),
//         ),
//         const SizedBox(height: 12),
//         _menuTile(
//           title: 'profile.changePassword'.tr,
//           icon: Icons.lock_outline_rounded,
//           onTap: () => Get.to(() => Scaffold()),
//         ),
//         const SizedBox(height: 12),

//         _menuTile(
//           title: 'Subscription',
//           icon: Icons.auto_awesome_outlined,
//           onTap: (){},
//         ),
//       ],
//     );
//   }

//   Widget _menuTile({
//     required String title,
//     required VoidCallback onTap,
//     required IconData icon,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(18),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: Colors.black,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 48,
//               height: 48,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 color: Color(0xFF4F0080),
//                 border: Border.all(color: Color(0xFF7600BF), width: 1),
//               ),
//               child: Icon(icon, color: Colors.white, size: 24),
//             ),

//             const SizedBox(width: 16),

//             Expanded(
//               child: Text(
//                 title,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 17,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),

//             SizedBox(
//               width: 34,
//               height: 34,
//               child: const Icon(
//                 Icons.edit_outlined,
//                 color: Colors.white,
//                 size: 28,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLogoutButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 52,
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           color: const Color(0xFFD6222A),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(28),
//             onTap: () => Get.to(() => const LogoutScreen()),
//             child: const Center(
//               child: Text(
//                 'Logout',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   String _displayName() {
//     final profile = _profileController.profile.value;
//     final value =
//         profile?.name?.trim() ??
//         profile?.username?.trim() ??
//         profile?.fullName?.trim() ??
//         profile?.firstName?.trim() ??
//         '';
//     return value.isEmpty ? 'common.user'.tr : value;
//   }
// }



import 'package:chasingharmony_fluttere/features/auth/presentation/screens/login_screen.dart';
import 'package:chasingharmony_fluttere/features/auth/repo/auth_interface.dart';
import 'package:chasingharmony_fluttere/features/profile/controller/get_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late final ProfileController _profileController;

  bool _isLogoutLoading = false;

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<ProfileController>()) {
      Get.put<ProfileController>(ProfileController(), permanent: true);
    }

    _profileController = Get.find<ProfileController>();
  }

  // Future<void> _handleLogout() async {
  //   if (_isLogoutLoading) return;

  //   setState(() => _isLogoutLoading = true);

  //   final result = await Get.find<AuthInterface>().logout();

  //   if (!mounted) return;

  //   result.fold(
  //     (failure) {
  //       setState(() => _isLogoutLoading = false);

  //       Get.snackbar(
  //         'common.error'.tr,
  //         failure.uiMessage,
  //       );
  //     },
  //     (_) {
  //       Get.offAll(() => const LoginScreen());
  //     },
  //   );
  // }

  void _showLogoutDialog() {
    Get.dialog(
      StatefulBuilder(
        builder: (context, setStateDialog) {
          return Dialog(
            backgroundColor: const Color(0xFFF8F8F8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'profile.logoutConfirm'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF151515),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: _isLogoutLoading
                                ? null
                                : () => Get.back(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xFFD12D2E),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'common.cancel'.tr,
                              style: const TextStyle(
                                color: Color(0xFF1F1F1F),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLogoutLoading
                                ? null
                                : () async {
                                    setState(() {
                                      _isLogoutLoading = true;
                                    });

                                    setStateDialog(() {});

                                    final result =
                                        await Get.find<AuthInterface>()
                                            .logout();

                                    if (!mounted) return;

                                    result.fold(
                                      (failure) {
                                        setState(() {
                                          _isLogoutLoading = false;
                                        });

                                        setStateDialog(() {});

                                        Get.snackbar(
                                          'common.error'.tr,
                                          failure.uiMessage,
                                        );
                                      },
                                      (_) {
                                        Get.offAll(
                                          () => const LoginScreen(),
                                        );
                                      },
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFFD12D2E),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  const Color(0xFFE18E8F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isLogoutLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'profile.logout'.tr,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      barrierDismissible: !_isLogoutLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/image/Profile.png',
            fit: BoxFit.cover,
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 48),
                  _buildProfileHeader(),
                  const SizedBox(height: 40),
                  _buildMenuItems(),
                  const SizedBox(height: 60),
                  _buildLogoutButton(),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            Obx(
              () => _buildAvatar(
                imageUrl: _profileController.profile.value?.avatar?.url,
              ),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF0A0A0A),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        Obx(
          () => Text(
            _displayName(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 4),

        Obx(
          () => Text(
            _profileController.profile.value?.email?.trim() ?? '',
            style: const TextStyle(
              color: Color(0xFF888888),
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar({required String? imageUrl}) {
    final trimmedUrl = imageUrl?.trim() ?? '';
    final hasImage = trimmedUrl.isNotEmpty;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: hasImage
            ? null
            : const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFCC9A7A),
                  Color(0xFF84533D),
                ],
              ),
        color: hasImage ? const Color(0xFFE7E7E7) : null,
      ),
      child: ClipOval(
        child: hasImage
            ? Image.network(
                trimmedUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              )
            : const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 40,
              ),
      ),
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        Obx(
          () => _menuTile(
            title: _displayName(),
            icon: Icons.person_outline_rounded,
            onTap: () => Get.to(() => const Scaffold()),
          ),
        ),

        const SizedBox(height: 12),

        _menuTile(
          title: 'profile.changePassword'.tr,
          icon: Icons.lock_outline_rounded,
          onTap: () => Get.to(() => const Scaffold()),
        ),

        const SizedBox(height: 12),

        _menuTile(
          title: 'Subscription',
          icon: Icons.auto_awesome_outlined,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _menuTile({
    required String title,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFF4F0080),
                border: Border.all(
                  color: const Color(0xFF7600BF),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(
              width: 34,
              height: 34,
              child: Icon(
                Icons.edit_outlined,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFD6222A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: _showLogoutDialog,
            child: const Center(
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _displayName() {
    final profile = _profileController.profile.value;

    final value =
        profile?.name?.trim() ??
        profile?.username?.trim() ??
        profile?.fullName?.trim() ??
        profile?.firstName?.trim() ??
        '';

    return value.isEmpty ? 'common.user'.tr : value;
  }
}