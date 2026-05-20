import 'package:chasingharmony_fluttere/core/helpers/handle_fold.dart';
import 'package:chasingharmony_fluttere/core/notifiers/button_status_notifier.dart';
import 'package:chasingharmony_fluttere/core/notifiers/snackbar_notifier.dart';
import 'package:chasingharmony_fluttere/features/auth/model/verify_otp_param.dart';
import 'package:chasingharmony_fluttere/features/auth/repo/auth_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

abstract class VerifyOtpController extends ChangeNotifier {
  final AuthInterface authInterface = Get.find<AuthInterface>();
  final ProcessStatusNotifier prcessNotifier = ProcessStatusNotifier(
    initialStatus: DisabledStatus(),
  );

  final SnackbarNotifier snackbarNotifier;
  final String email;
  String resetToken = '';

  VerifyOtpController({required this.email, required this.snackbarNotifier});

  int otpLength = 4;
  String _otp = "";

  String get otp => _otp;

  set otp(String value) {
    _otp = value;
    debugPrint("Current OTP → $_otp");

    if (_otp.length == otpLength) {
      prcessNotifier.setEnabled();
    } else {
      prcessNotifier.setDisabled();
    }
  }

  void verify();
}

class VerifyForgetPasswordOtpController extends VerifyOtpController {
  VerifyForgetPasswordOtpController({
    required super.email,
    required super.snackbarNotifier,
  });

  @override
  void verify() async {
    if (prcessNotifier.status is LoadingStatus) return;

    debugPrint("Verifying OTP for email: $email");

    prcessNotifier.setLoading();

    final result = await authInterface.verifyCode(
      VerifyOtpParam(email: email, code: otp),
    );

    handleFold(
      either: result,
      processStatusNotifier: prcessNotifier,
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      onSuccess: (token) {
        resetToken = token;
      },
    );

    result.fold(
      (err) => prcessNotifier.setError(),
      (success) {},
    );
  }
}
