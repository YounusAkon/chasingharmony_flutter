// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../core/helpers/handle_fold.dart';
// import '../../../core/notifiers/button_status_notifier.dart';
// import '../../../core/notifiers/snackbar_notifier.dart';
// import '../model/forget_password_model.dart';
// import '../repo/auth_interface.dart';

// class ForgetPasswordController extends GetxController {
//   final ProcessStatusNotifier processStatusNotifier =
//       ProcessStatusNotifier(initialStatus: EnabledStatus());

//   final SnackbarNotifier snackbarNotifier;

//   ForgetPasswordController(this.snackbarNotifier);

//   final TextEditingController emailController = TextEditingController();

//   String get email => emailController.text.trim();
//   RxInt resendSeconds = 0.obs;
//   Timer? _timer;

//   Future<void> forgetPassword() async {
//     if (!GetUtils.isEmail(email)) {
//       return;
//     }

//     processStatusNotifier.setLoading();

//     final result = await Get.find<AuthInterface>()
//         .forgetpassword(ForgetPasswordModel(email: email));

//     handleFold(
//       either: result,
//       processStatusNotifier: processStatusNotifier,
//       successSnackbarNotifier: snackbarNotifier,
//       errorSnackbarNotifier: snackbarNotifier,
//     );
//     startResendTimer();
//   }

//   void startResendTimer({int seconds = 0}) {
//     resendSeconds.value = seconds;
//     _timer?.cancel();

//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (resendSeconds.value > 0) {
//         resendSeconds.value--;
//       } else {
//         timer.cancel();
//         processStatusNotifier.setEnabled();
//       }
//     });
//   }
//   void resetButton() {
//     processStatusNotifier.setEnabled();
//     _timer?.cancel();
//     resendSeconds.value = 0;
//   }

//   @override
//   void onClose() {
//     _timer?.cancel();
//     emailController.dispose();
//     super.onClose();
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/helpers/handle_fold.dart';
import '../../../core/notifiers/button_status_notifier.dart';
import '../../../core/notifiers/snackbar_notifier.dart';
import '../model/forget_password_model.dart';
import '../repo/auth_interface.dart';

class ForgetPasswordController extends GetxController {
  final ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier(
    initialStatus: EnabledStatus(),
  );

  final SnackbarNotifier snackbarNotifier;

  ForgetPasswordController(this.snackbarNotifier);

  final TextEditingController emailController = TextEditingController();

  String get email => emailController.text.trim();

  Timer? _timer;

  Future<void> forgetPassword({required VoidCallback onSuccess}) async {
    if (!GetUtils.isEmail(email)) {
      snackbarNotifier.notifyError(message: "Please enter a valid email");
      return;
    }

    processStatusNotifier.setLoading();

    final result = await Get.find<AuthInterface>().forgetpassword(
      ForgetPasswordModel(email: email),
    );

    handleFold(
      either: result,
      processStatusNotifier: processStatusNotifier,
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      onSuccess: (_) {
        onSuccess(); // ✅ NAVIGATE ONLY ON SUCCESS
      },
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    emailController.dispose();
    super.onClose();
  }
}
