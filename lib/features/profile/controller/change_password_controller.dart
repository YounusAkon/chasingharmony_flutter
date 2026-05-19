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
    if (_oldPass.isNotEmpty &&
        _newPass.isNotEmpty &&
        _newPass.length >= 6 &&
        _confirmPass == _newPass) {
      processNotifier.setEnabled();
    } else {
      processNotifier.setDisabled();
    }
  }

  Future<void> changePassword() async {
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
