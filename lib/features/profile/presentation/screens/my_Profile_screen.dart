import 'package:chasingharmony_fluttere/core/theme/app_colors.dart';
import 'package:chasingharmony_fluttere/features/onbording/language_screen.dart';
import 'package:chasingharmony_fluttere/features/profile/controller/get_profile_controller.dart';
import 'package:chasingharmony_fluttere/features/profile/presentation/screens/change_password.dart';
import 'package:chasingharmony_fluttere/features/profile/presentation/screens/faq_screen.dart';
import 'package:chasingharmony_fluttere/features/profile/presentation/screens/logout_screen.dart';
import 'package:chasingharmony_fluttere/features/profile/presentation/screens/my_profile_details.dart';
import 'package:chasingharmony_fluttere/features/profile/presentation/screens/privacy_policy.dart';
import 'package:chasingharmony_fluttere/features/profile/presentation/screens/terms_condition_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  bool _pushNotificationEnabled = true;
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            children: [
              _profileHeader(),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView(
                    children: [
                      _menuTile(
                        title: 'profile.editProfile'.tr,
                        icon: Icons.edit_outlined,
                        onTap: () => Get.to(() => const MyDetailsScreen()),
                      ),
                      _divider(),
                      _menuTile(
                        title: 'profile.changePassword'.tr,
                        icon: Icons.lock_outline_rounded,
                        onTap: () => Get.to(() => const ChangePasswordScreen()),
                      ),
                      _divider(),
                      _menuTile(
                        title: 'profile.aboutApp'.tr,
                        icon: Icons.info_outline_rounded,
                        onTap: () => Get.to(() => const FaqScreen()),
                      ),
                      _divider(),
                      _menuTile(
                        title: 'nav.history'.tr,
                        icon: Icons.history_rounded,
                        onTap: () => Get.to(() => const Scaffold()),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFF38AAE8),
                      ),
                      _menuTile(
                        title: 'profile.privacyPolicy'.tr,
                        icon: Icons.receipt_long_outlined,
                        onTap: () => Get.to(() => const PrivacyPolicy()),
                      ),
                      _divider(),
                      _menuTile(
                        title: 'profile.termsConditions'.tr,
                        icon: Icons.gpp_maybe_outlined,
                        onTap: () => Get.to(() => const TermsConditionScreen()),
                      ),
                      _divider(),
                      _menuTile(
                        title: 'profile.language'.tr,
                        icon: Icons.language_rounded,
                        onTap: () {
                          Get.to(() => const LanguageScreen(fromProfile: true));
                        },
                      ),
                      // _divider(),
                      // _switchTile(),
                      _divider(),
                      _menuTile(
                        title: 'profile.logout'.tr,
                        icon: Icons.logout,
                        iconColor: AppColors.authPrimaryRed,
                        textColor: AppColors.authPrimaryRed,
                        trailingColor: AppColors.authPrimaryRed,
                        onTap: () => Get.to(() => const LogoutScreen()),
                      ),
                      _divider(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileHeader() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.authHeading,
          onPressed: () => Navigator.of(context).pop(),
          splashRadius: 20,
        ),
        Obx(
          () => _buildProfileAvatar(
            imageUrl: _profileController.profile.value?.avatar?.url,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Obx(
            () => Text(
              _displayName(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.authHeading,
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
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

  Widget _buildProfileAvatar({required String? imageUrl}) {
    final trimmedUrl = imageUrl?.trim() ?? '';
    final hasImage = trimmedUrl.isNotEmpty;

    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: hasImage
            ? null
            : const LinearGradient(
                colors: [Color(0xFFC98A72), Color(0xFF9F5F4B)],
              ),
        color: hasImage ? const Color(0xFFE7E7E7) : null,
      ),
      child: ClipOval(
        child: hasImage
            ? Image.network(
                trimmedUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, color: Colors.white, size: 20),
              )
            : const Icon(Icons.person, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _switchTile() {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          const SizedBox(width: 4),
          const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFF1F1F1F),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'profile.pushNotifications'.tr,
              style: TextStyle(
                color: AppColors.authHeading,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: _pushNotificationEnabled,
            onChanged: (value) {
              setState(() {
                _pushNotificationEnabled = value;
              });
            },
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.authPrimaryRed,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFCDCDCD),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _menuTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF1F1F1F),
    Color textColor = AppColors.authHeading,
    Color trailingColor = const Color(0xFFB0B0B0),
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            const SizedBox(width: 4),
            Icon(icon, size: 21, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: trailingColor),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED));
  }
}
