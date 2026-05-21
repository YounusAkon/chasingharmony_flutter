import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/api_handler/failure.dart';
import '../../../core/helpers/handle_fold.dart';
import '../../../core/helpers/validation.dart';
import '../../../core/localization/app_language_controller.dart';
import '../../../core/notifiers/button_status_notifier.dart';
import '../../../core/notifiers/snackbar_notifier.dart';
import '../model/login_request_model.dart';
import '../repo/auth_interface.dart';

class LoginController extends GetxController {
  final ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier(
    initialStatus: DisabledStatus(),
  );
  final SnackbarNotifier snackbarNotifier;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final keepSignedIn = false.obs;
  final isSocialLoading = false.obs;

  String _email = '';
  String get email => _email;

  String _password = '';
  String get password => _password;

  LoginController(this.snackbarNotifier);

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      debugPrint("Email: ${emailController.text}");
      email = emailController.text.trim();
    });
    passwordController.addListener(() {
      debugPrint("password: ${passwordController.text}");
      password = passwordController.text.trim();
    });
  }

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   super.onClose();
  // }

  set email(String value) {
    if (value != _email) {
      _email = value;
      canLogin();
    }
  }

  set password(String value) {
    if (value != _password) {
      _password = value;
      canLogin();
    }
  }

  void canLogin() {
    if (_email.isNotEmpty && isEmail(_email) && _password.isNotEmpty) {
      processStatusNotifier.setEnabled();
    } else {
      processStatusNotifier.setDisabled();
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleKeepSignedIn(bool value) {
    keepSignedIn.value = value;
  }

  Future<void> login({
    required VoidCallback onSuccess,
    required VoidCallback needVerifyAccount,
  }) async {
    processStatusNotifier.setLoading();

    final result = await Get.find<AuthInterface>().login(
      LoginRequestModel(
        email: email,
        password: password,
        preferredLanguage: Get.find<AppLanguageController>().languageCode.value,
      ),
    );

    handleFold(
      either: result,
      processStatusNotifier: processStatusNotifier,
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      onError: (error) {
        if (error.failure == Failure.forbidden) {
          needVerifyAccount();
        }
      },
      onSuccess: (_) {
        onSuccess(); // ✅ NAVIGATE ONLY HERE
      },
    );
  }

  Future<void> googleLogin({required VoidCallback onSuccess}) async {
    if (isSocialLoading.value) return;

    try {
      isSocialLoading.value = true;
      final result = await Get.find<AuthInterface>().googleLogin();

      result.fold(
        (failure) {
          final message = failure.uiMessage.trim();
          if (message.isEmpty || message.toLowerCase().contains('cancel')) {
            return;
          }
          snackbarNotifier.notifyError(message: message);
        },
        (success) {
          snackbarNotifier.notifySuccess(message: success.message);
          onSuccess();
        },
      );
    } catch (_) {
      snackbarNotifier.notifyError(
        message: 'Google sign-in failed. Please try again.',
      );
    } finally {
      isSocialLoading.value = false;
    }
  }
}
