import 'package:chasingharmony_fluttere/core/notifiers/snackbar_notifier.dart';
import 'package:chasingharmony_fluttere/features/profile/controller/change_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/widget/reactive_button/save_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late final ChangePasswordController _changePasswordController;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _changePasswordController = ChangePasswordController(
      SnackbarNotifier(context: context),
    );

    currentPasswordController.addListener(() {
      _changePasswordController.currentPassword = currentPasswordController.text
          .trim();
    });

    newPasswordController.addListener(() {
      _changePasswordController.newPassword = newPasswordController.text.trim();
    });

    confirmNewPasswordController.addListener(() {
      _changePasswordController.confirmPassword = confirmNewPasswordController
          .text
          .trim();
    });
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: const Color(0xFFF3F3F3),
        elevation: 0,
        scrolledUnderElevation: 0,

        title: Text(
          'profile.changePassword'.tr,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF191919),
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _passwordField(
                  controller: currentPasswordController,
                  hintText: "profile.currentPassword".tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "profile.enterCurrentPassword".tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                _passwordField(
                  controller: newPasswordController,
                  hintText: "profile.newPassword".tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "profile.enterNewPassword".tr;
                    }
                    if (value.length < 6) {
                      return "profile.passwordMin".tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                _passwordField(
                  controller: confirmNewPasswordController,
                  hintText: "profile.confirmNewPassword".tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "profile.confirmPassword".tr;
                    }
                    if (value != newPasswordController.text) {
                      return "profile.passwordsNotMatch".tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 46,
                  child: RSaveButton(
                    width: double.infinity,
                    height: 46,
                    borderRadius: BorderRadius.circular(6),
                    buttonStatusNotifier:
                        _changePasswordController.processNotifier,
                    saveText: "common.save".tr,
                    loadingText: "language.saving".tr,
                    doneText: "language.saved".tr,
                    errorText: "language.saveFailed".tr,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    disabledBackgroundColor: const Color(0xFFFFC7C7),
                    onSaveTap: () {
                      if (!_formKey.currentState!.validate()) return;
                      FocusScope.of(context).unfocus();
                      _changePasswordController.changePassword();
                    },
                    onDone: () {
                      Get.back();
                    },
                    key: null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: validator,
      style: const TextStyle(
        color: Color(0xFF1A1A1A),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF787878),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFCDCDCD), width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.2),
        ),
      ),
    );
  }
}
