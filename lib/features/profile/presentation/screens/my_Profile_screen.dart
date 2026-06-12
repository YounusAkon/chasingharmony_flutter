// ignore_for_file: file_names

import 'dart:io';

import 'package:app_pigeon/app_pigeon.dart';
import 'package:chasingharmony_fluttere/features/auth/presentation/screens/login_screen.dart';
import 'package:chasingharmony_fluttere/features/auth/repo/auth_interface.dart';
import 'package:chasingharmony_fluttere/features/profile/controller/edit_profile_controller.dart';
import 'package:chasingharmony_fluttere/features/profile/controller/get_profile_controller.dart';
import 'package:chasingharmony_fluttere/features/profile/presentation/screens/change_password_screen.dart';
import 'package:chasingharmony_fluttere/features/profile/presentation/screens/subscription_screen.dart';
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
  bool _isDeleteAccountLoading = false;

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<ProfileController>()) {
      Get.put<ProfileController>(ProfileController(), permanent: true);
    }
    _profileController = Get.find<ProfileController>();

    if (!Get.isRegistered<ProfileEditController>()) {
      Get.put<ProfileEditController>(ProfileEditController());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _profileController.getCurrentUserProfile();
    });
  }

  Future<void> _pickAndUploadAvatar() async {
    final editController = Get.find<ProfileEditController>();
    if (editController.isUploadingAvatar.value) return;

    final result = await editController.pickAndUploadAvatar();
    if (!mounted) return;
    if (result.message == 'No image selected') return;

    Get.snackbar(
      result.ok ? 'Success' : 'Error',
      result.ok ? 'Profile photo updated' : result.message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: result.ok ? Colors.green.shade700 : Colors.red.shade700,
      colorText: Colors.white,
    );
  }

  void _showEditNameDialog() {
    final editController = Get.find<ProfileEditController>();
    final currentName = _displayName();
    editController.fullNameController.text = currentName == 'common.user'.tr
        ? ''
        : currentName;

    final isSaving = false.obs;

    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Full Name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: editController.fullNameController,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: isSaving.value ? null : () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFF7600BF),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                      () => SizedBox(
                        height: 50,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFF4F8DF7), Color(0xFF7600BF)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ElevatedButton(
                            onPressed: isSaving.value
                                ? null
                                : () async {
                                    final name = editController
                                        .fullNameController.text;
                                    isSaving.value = true;
                                    final result = await editController
                                        .updateFullName(name);
                                    isSaving.value = false;
                                    if (result.ok) {
                                      Get.back();
                                    }
                                    Get.snackbar(
                                      result.ok ? 'Success' : 'Error',
                                      result.ok
                                          ? 'Profile updated'
                                          : result.message,
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: result.ok
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                      colorText: Colors.white,
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: isSaving.value
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Save',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
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
      ),
    );
  }

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
                            onPressed:
                                _isLogoutLoading ? null : () => Get.back(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFD12D2E)),
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
                                    setState(() => _isLogoutLoading = true);
                                    setStateDialog(() {});
                                    final result =
                                        await Get.find<AuthInterface>()
                                            .logout();
                                    if (!mounted) return;
                                    result.fold(
                                      (failure) {
                                        setState(
                                          () => _isLogoutLoading = false,
                                        );
                                        setStateDialog(() {});
                                        Get.snackbar(
                                          'common.error'.tr,
                                          failure.uiMessage,
                                        );
                                      },
                                      (_) {
                                        Get.offAll(() => const LoginScreen());
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

  void _showDeleteAccountDialog() {
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
                    'profile.deleteAccount'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF151515),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'profile.deleteAccountConfirm'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: _isDeleteAccountLoading
                                ? null
                                : () => Get.back(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFD12D2E)),
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
                            onPressed: _isDeleteAccountLoading
                                ? null
                                : () async {
                                    setState(
                                      () => _isDeleteAccountLoading = true,
                                    );
                                    setStateDialog(() {});

                                    final result = await _profileController
                                        .deleteAccount();

                                    if (!mounted) return;

                                    if (result.ok) {
                                      await Get.find<AuthorizedPigeon>()
                                          .logOut();
                                      Get.offAll(() => const LoginScreen());
                                    } else {
                                      setState(
                                        () =>
                                            _isDeleteAccountLoading = false,
                                      );
                                      setStateDialog(() {});
                                      Get.snackbar(
                                        'common.error'.tr,
                                        result.message,
                                      );
                                    }
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
                            child: _isDeleteAccountLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'common.delete'.tr,
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
      barrierDismissible: !_isDeleteAccountLoading,
    );
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
              child: Obx(() {
                if (_profileController.isLoading.value &&
                    _profileController.profile.value == null) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 48),
                      _buildProfileHeader(),
                      const SizedBox(height: 40),
                      _buildMenuItems(),
                      const SizedBox(height: 60),
                      _buildLogoutButton(),
                      const SizedBox(height: 16),
                      _buildDeleteAccountButton(),
                      const SizedBox(height: 28),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    final editController = Get.find<ProfileEditController>();
    return Column(
      children: [
        GestureDetector(
          onTap: _pickAndUploadAvatar,
          child: Stack(
            children: [
              Obx(
                () => _buildAvatar(
                  imageUrl: _profileController.profile.value?.avatar?.url,
                  pickedFile: editController.pickedImage.value,
                ),
              ),
              Obx(
                () => editController.isUploadingAvatar.value
                    ? Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
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

  Widget _buildAvatar({required String? imageUrl, File? pickedFile}) {
    final trimmedUrl = imageUrl?.trim() ?? '';
    final hasNetworkImage = trimmedUrl.isNotEmpty;
    final hasLocalImage = pickedFile != null;
    final hasImage = hasLocalImage || hasNetworkImage;

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
        child: hasLocalImage
            ? Image.file(
                pickedFile,
                fit: BoxFit.cover,
                width: 120,
                height: 120,
              )
            : hasNetworkImage
                ? Image.network(
                    trimmedUrl,
                    fit: BoxFit.cover,
                    width: 120,
                    height: 120,
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
            onTap: _showEditNameDialog,
          ),
        ),
        const SizedBox(height: 12),
        _menuTile(
          title: 'profile.changePassword'.tr,
          icon: Icons.lock_outline_rounded,
          onTap: ChangePasswordScreen.show,
        ),
        const SizedBox(height: 12),
        _menuTile(
          title: 'Subscription',
          icon: Icons.auto_awesome_outlined,
          onTap: () {
            Get.to(() => const SubscriptionPlansScreen());
          },
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
                color: const Color(0xFF4F0080),
                border: Border.all(color: const Color(0xFF7600BF), width: 1),
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

  Widget _buildDeleteAccountButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _showDeleteAccountDialog,
          child: Center(
            child: Text(
              'profile.deleteAccount'.tr,
              style: const TextStyle(
                color: Color(0xFFD12D2E),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _displayName() {
    final profile = _profileController.profile.value;
    final value = profile?.name?.trim() ??
        profile?.fullName?.trim() ??
        profile?.username?.trim() ??
        profile?.firstName?.trim() ??
        '';
    return value.isEmpty ? 'common.user'.tr : value;
  }
}
