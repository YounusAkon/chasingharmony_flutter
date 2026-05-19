import 'dart:io';
import 'package:chasingharmony_fluttere/features/profile/controller/get_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/helpers/handle_fold.dart';
import '../../../core/notifiers/button_status_notifier.dart';
import '../../../core/notifiers/snackbar_notifier.dart';
import '../model/edit_profile_model.dart';
import '../repo/profile_interface.dart';

class ProfileEditController extends GetxController {
  ProfileEditController();

  final ProfileController profileController = Get.find<ProfileController>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final Rx<File?> pickedImage = Rx<File?>(null);

  ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier(
    initialStatus: EnabledStatus(),
  );

  @override
  void onInit() {
    super.onInit();

    ever(profileController.profile, (profile) {
      if (profile != null) {
        usernameController.text = profile.username ?? profile.name ?? '';
        lastNameController.text =
            profile.lastName ?? _lastNameFromName(profile.name);
        phoneController.text = profile.phone ?? '';
      }
    });

    final profile = profileController.profile.value;
    if (profile != null) {
      usernameController.text = profile.username ?? profile.name ?? '';
      lastNameController.text =
          profile.lastName ?? _lastNameFromName(profile.name);
      phoneController.text = profile.phone ?? '';
    }

    usernameController.addListener(_markAsEditable);
    lastNameController.addListener(_markAsEditable);
    phoneController.addListener(_markAsEditable);
  }

  Future<void> pickImageFromGallery() async {
    final XFile? picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (picked != null) {
      pickedImage.value = File(picked.path);
      processStatusNotifier.setEnabled();
    }
  }

  Future<void> updateProfile({SnackbarNotifier? snackbarNotifier}) async {
    processStatusNotifier.setLoading();

    final result = await Get.find<ProfilInterface>().updateProfile(
      EditProfileModel(
        username: _nullIfBlank(usernameController.text),
        // The screen currently edits a single full-name field.
        // Avoid sending stale hidden lastName that can duplicate the display name.
        lastName: null,
        phoneNumber: _nullIfBlank(phoneController.text),
        avatarFile: pickedImage.value,
      ),
    );

    handleFold(
      either: result,
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: processStatusNotifier,
    );

    if (processStatusNotifier.status is SuccessStatus) {
      await profileController.getCurrentUserProfile();
      Get.back();
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void _markAsEditable() {
    processStatusNotifier.setEnabled();
  }

  String? _nullIfBlank(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String _lastNameFromName(String? value) {
    if (value == null || value.trim().isEmpty) return '';
    final parts = value.trim().split(RegExp(r'\s+'));
    if (parts.length <= 1) return '';
    return parts.sublist(1).join(' ');
  }
}
