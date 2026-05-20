import 'package:get/get.dart';

import '../../../core/helpers/handle_fold.dart';
import '../../../core/notifiers/button_status_notifier.dart';
import '../../../core/notifiers/snackbar_notifier.dart';
import '../model/create_new_password_model.dart';
import '../repo/auth_interface.dart';

class ResetPasswordController extends GetxController {
  final String resetToken;

  ResetPasswordController({required this.resetToken});

  final ProcessStatusNotifier processNotifier = ProcessStatusNotifier(
    initialStatus: DisabledStatus(),
  );

  late SnackbarNotifier snackbarNotifier;

  String _newPassword = "";
  String _confirmPassword = "";

  RxBool matchOk = false.obs;

  set newPassword(String v) {
    _newPassword = v;
    _checkMatch();
  }

  set confirmPassword(String v) {
    _confirmPassword = v;
    _checkMatch();
  }

  void _checkMatch() {
    matchOk.value =
        _newPassword.isNotEmpty &&
        _confirmPassword.isNotEmpty &&
        _newPassword == _confirmPassword;

    matchOk.value
        ? processNotifier.setEnabled()
        : processNotifier.setDisabled();
  }

  Future<void> resetPassword(SnackbarNotifier snackbar) async {
    snackbarNotifier = snackbar;

    if (!matchOk.value) return;

    processNotifier.setLoading();

    final model = ResetPasswordModel(
      resetToken: resetToken,
      newPassword: _newPassword,
      confirmPassword: _confirmPassword,
    );

    final result = await Get.find<AuthInterface>().resetPassword(model);

    handleFold(
      either: result,
      processStatusNotifier: processNotifier,
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
    );

    result.fold(
      (l) => processNotifier.setError(),
      (r) {},
    );
  }
}
