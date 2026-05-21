import 'package:get/get.dart';
import '../../../core/helpers/handle_fold.dart';
import '../../../core/notifiers/button_status_notifier.dart';
import '../../../core/notifiers/snackbar_notifier.dart';
import '../model/signup_model.dart';
import '../repo/auth_interface.dart';

class SignUpController extends GetxController {
  final ProcessStatusNotifier processNotifier = ProcessStatusNotifier(
    initialStatus: EnabledStatus(),
  );

  final fullName = ''.obs;
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;

  void setFullName(String value) {
    fullName.value = value;
    // processNotifier.setEnabled();
  }

  void setEmail(String value) {
    email.value = value;
    // processNotifier.setEnabled();
  }

  void setPassword(String value) {
    password.value = value;
    // processNotifier.setEnabled();
  }

  void setConfirmPassword(String value) {
    confirmPassword.value = value;
    // processNotifier.setEnabled();
  }

  SignupModel get signupModel => SignupModel(
    fullName: fullName.value,
    email: email.value,
    password: password.value,
    confirmPassword: confirmPassword.value,
  );

  Future<void> signup({
    ProcessStatusNotifier? buttonNotifier,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    buttonNotifier?.setLoading();

    final result = await Get.find<AuthInterface>().signup(signupModel);

    handleFold(
      either: result,
      errorSnackbarNotifier: snackbarNotifier,
      successSnackbarNotifier: snackbarNotifier,
      onError: (failure) {
        buttonNotifier?.setError();
      },
      processStatusNotifier: buttonNotifier,
    );
  }
}
