import 'dart:io';
import 'package:app_pigeon/app_pigeon.dart';
import 'package:chasingharmony_fluttere/app/app_manager.dart';
import 'package:chasingharmony_fluttere/core/helpers/auth_role.dart';
import 'package:chasingharmony_fluttere/core/localization/app_language_controller.dart';
import 'package:chasingharmony_fluttere/features/profile/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repo/profile_interface.dart';

class ProfileController extends GetxController {
  final ProfilInterface repo = Get.find<ProfilInterface>();

  Rxn<ProfileModel> profile = Rxn<ProfileModel>();
  RxBool isLoading = false.obs;
  Rx<File?> pickedImage = Rx<File?>(null);

  /// Form controllers
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  /// Dropdowns / pickers
  RxString gender = "Male".obs;
  RxString countryCode = "+880".obs;
  Rxn<DateTime> dob = Rxn<DateTime>();

  final genders = ["Male", "Female", "Other"];

  @override
  void onInit() {
    super.onInit();
    getCurrentUserProfile();
  }

  Future<void> getCurrentUserProfile() async {
    final app = Get.find<AppManager>();
    isLoading.value = true;

    if (app.currentAuthStatus is Authenticated) {
      final auth = app.currentAuthStatus as Authenticated;
      final result = await repo.getProfile(auth.auth.userId);

      result.fold((failure) => debugPrint("PROFILE ERROR: $failure"), (
        success,
      ) {
        if (isClosed) return;
        profile.value = success.data;
        nameCtrl.text = success.data?.name ?? "";
        emailCtrl.text = success.data?.email ?? "";
        if (Get.isRegistered<AppLanguageController>()) {
          Get.find<AppLanguageController>().syncFromBackendValue(
            success.data?.language,
          );
        }
      });
    }

    isLoading.value = false;
  }

  void pickDob(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dob.value = picked;
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    super.onClose();
  }
}
