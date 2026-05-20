import 'package:chasingharmony_fluttere/features/profile/controller/get_profile_controller.dart';
import 'package:chasingharmony_fluttere/features/profile/presentation/screens/change_password.dart';
import 'package:chasingharmony_fluttere/features/profile/presentation/screens/logout_screen.dart';
import 'package:chasingharmony_fluttere/features/profile/presentation/screens/my_profile_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late final ProfileController _profileController;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<ProfileController>()) {
      Get.put<ProfileController>(ProfileController(), permanent: true);
    }
    _profileController = Get.find<ProfileController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/image/Profile.png', fit: BoxFit.cover),
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
                  border: Border.all(color: const Color(0xFF0A0A0A), width: 2),
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
            style: const TextStyle(color: Color(0xFF888888), fontSize: 13),
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
                colors: [Color(0xFFCC9A7A), Color(0xFF84533D)],
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
            : const Icon(Icons.person_rounded, color: Colors.white, size: 40),
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
            onTap: () => Get.to(() => const MyDetailsScreen()),
          ),
        ),
        const SizedBox(height: 12),
        _menuTile(
          title: 'profile.changePassword'.tr,
          icon: Icons.lock_outline_rounded,
          onTap: () => Get.to(() => const ChangePasswordScreen()),
        ),
        const SizedBox(height: 12),

        _menuTile(
          title: 'Subscription',
          icon: Icons.auto_awesome_outlined,
          onTap: (){},
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                color: Color(0xFF4F0080),
                border: Border.all(color: Color(0xFF7600BF), width: 1),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
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

            SizedBox(
              width: 34,
              height: 34,
              child: const Icon(
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
            onTap: () => Get.to(() => const LogoutScreen()),
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
