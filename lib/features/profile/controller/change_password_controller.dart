import 'package:chasingharmony_fluttere/features/profile/repo/profile_interface.dart';
import 'package:get/get.dart';
import '../../../core/notifiers/button_status_notifier.dart';
import '../../../core/notifiers/snackbar_notifier.dart';
import '../model/chnage_password_model.dart';

class ChangePasswordController extends GetxController {
  final ProcessStatusNotifier processNotifier = ProcessStatusNotifier(
    initialStatus: DisabledStatus(),
  );
  final SnackbarNotifier snackbarNotifier;

  ChangePasswordController(this.snackbarNotifier);

  String _oldPass = '';
  String _newPass = '';
  String _confirmPass = '';

  bool get hasCurrentPassword => _oldPass.trim().isNotEmpty;
  bool get hasMinLength => _newPass.length >= 8;
  bool get hasUppercase => RegExp(r'[A-Z]').hasMatch(_newPass);
  bool get hasLowercase => RegExp(r'[a-z]').hasMatch(_newPass);
  bool get hasDigit => RegExp(r'\d').hasMatch(_newPass);
  bool get hasSpecialCharacter =>
      RegExp(r'[^A-Za-z0-9\s]').hasMatch(_newPass);
  bool get hasNoSpaces => !RegExp(r'\s').hasMatch(_newPass);
  bool get passwordsMatch =>
      _confirmPass.isNotEmpty && _confirmPass == _newPass;
  bool get canSubmit =>
      hasCurrentPassword &&
      hasMinLength &&
      hasUppercase &&
      hasLowercase &&
      hasDigit &&
      hasSpecialCharacter &&
      hasNoSpaces &&
      passwordsMatch;

  set currentPassword(String value) {
    _oldPass = value;
    _validate();
  }

  set newPassword(String value) {
    _newPass = value;
    _validate();
  }

  set confirmPassword(String value) {
    _confirmPass = value;
    _validate();
  }

  void _validate() {
    if (canSubmit) {
      processNotifier.setEnabled();
    } else {
      processNotifier.setDisabled();
    }
  }

  Future<void> changePassword() async {
    if (processNotifier.status is LoadingStatus || !canSubmit) return;
    processNotifier.setLoading();

    final param = ChangePasswordModel(
      currentPassword: _oldPass,
      newPassword: _newPass,
      confirmPassword: _confirmPass,
    );

    final result = await Get.find<ProfilInterface>().changePassword(param);

    result.fold(
      (failure) {
        processNotifier.setError();
        snackbarNotifier.notifyError(message: failure.uiMessage);
      },
      (success) {
        processNotifier.setSuccess(message: success.message);
        snackbarNotifier.notifySuccess(message: success.message);
      },
    );
  }
}
