import 'dart:io';
import 'package:chasingharmony_fluttere/features/profile/controller/get_profile_controller.dart';
import 'package:chasingharmony_fluttere/features/profile/model/profile_model.dart';
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
  final ProfilInterface _repo = Get.find<ProfilInterface>();

  final TextEditingController fullNameController = TextEditingController();
  final Rx<File?> pickedImage = Rx<File?>(null);
  final RxBool isUploadingAvatar = false.obs;

  ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier(
    initialStatus: EnabledStatus(),
  );

  @override
  void onInit() {
    super.onInit();

    _syncFromProfile(profileController.profile.value);
    ever(profileController.profile, _syncFromProfile);

    fullNameController.addListener(_markAsEditable);
  }

  void _syncFromProfile(ProfileModel? profile) {
    if (profile == null) return;
    final name = profile.name ?? profile.fullName ?? profile.username ?? '';
    if (fullNameController.text != name) {
      fullNameController.text = name;
    }
  }

  Future<void> pickImageFromGallery() async {
    final XFile? picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      pickedImage.value = File(picked.path);
      processStatusNotifier.setEnabled();
    }
  }

  /// Picks an image from gallery and uploads it immediately.
  /// Returns a (success, message) pair; updates [pickedImage] so the UI can
  /// preview the file while the upload is in flight.
  Future<({bool ok, String message})> pickAndUploadAvatar() async {
    final XFile? picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) {
      return (ok: false, message: 'No image selected');
    }

    pickedImage.value = File(picked.path);
    return uploadPickedAvatar();
  }

  /// Uploads whatever is currently in [pickedImage] and refreshes the profile.
  Future<({bool ok, String message})> uploadPickedAvatar() async {
    final file = pickedImage.value;
    if (file == null) {
      return (ok: false, message: 'No image selected');
    }

    isUploadingAvatar.value = true;
    try {
      final result = await _repo.uploadAvatar(file);
      return result.fold(
        (failure) {
          return (ok: false, message: failure.uiMessage);
        },
        (success) async {
          final newAvatar = success.data;
          final current = profileController.profile.value;
          if (current != null) {
            current.avatar = newAvatar;
            profileController.profile.refresh();
          }
          await profileController.getCurrentUserProfile();
          pickedImage.value = null;
          return (ok: true, message: success.message);
        },
      );
    } finally {
      isUploadingAvatar.value = false;
    }
  }

  /// Updates only the full name. Returns a (success, message) pair.
  Future<({bool ok, String message})> updateFullName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return (ok: false, message: 'Name cannot be empty');
    }

    processStatusNotifier.setLoading();
    final result = await _repo.updateProfile(
      EditProfileModel(fullName: trimmed),
    );

    return result.fold(
      (failure) {
        processStatusNotifier.setEnabled();
        return (ok: false, message: failure.uiMessage);
      },
      (success) async {
        await profileController.getCurrentUserProfile();
        processStatusNotifier.setSuccess(message: success.message);
        return (ok: true, message: success.message);
      },
    );
  }

  /// Backwards-compatible combined save (name + optional avatar).
  Future<bool> saveChanges({SnackbarNotifier? snackbarNotifier}) async {
    processStatusNotifier.setLoading();

    if (pickedImage.value != null) {
      final avatarResult = await _repo.uploadAvatar(pickedImage.value!);
      final ok = avatarResult.isRight();
      if (!ok) {
        handleFold(
          either: avatarResult,
          errorSnackbarNotifier: snackbarNotifier,
          processStatusNotifier: processStatusNotifier,
        );
        return false;
      }
    }

    final result = await _repo.updateProfile(
      EditProfileModel(fullName: fullNameController.text),
    );

    handleFold(
      either: result,
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: processStatusNotifier,
    );

    if (processStatusNotifier.status is SuccessStatus) {
      await profileController.getCurrentUserProfile();
      pickedImage.value = null;
      return true;
    }
    return false;
  }

  @override
  void onClose() {
    fullNameController.dispose();
    super.onClose();
  }

  void _markAsEditable() {
    processStatusNotifier.setEnabled();
  }
}
