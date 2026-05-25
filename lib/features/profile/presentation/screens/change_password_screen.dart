import 'package:chasingharmony_fluttere/core/notifiers/button_status_notifier.dart';
import 'package:chasingharmony_fluttere/core/notifiers/snackbar_notifier.dart';
import 'package:chasingharmony_fluttere/features/profile/controller/change_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({
    super.key,
    this.showAsDialog = false,
  });

  final bool showAsDialog;

  static Future<void> show() {
    return Get.dialog<void>(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const ChangePasswordScreen(showAsDialog: true),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.7),
    );
  }

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  static const LinearGradient _saveGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF45A5FF), Color(0xFFC026FF)],
  );

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late ChangePasswordController _controller;
  bool _didSetupController = false;
  bool _ownsController = false;
  bool _handledSuccess = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didSetupController) return;

    if (Get.isRegistered<ChangePasswordController>()) {
      _controller = Get.find<ChangePasswordController>();
    } else {
      _controller = Get.put(
        ChangePasswordController(SnackbarNotifier(context: context)),
      );
      _ownsController = true;
    }

    _controller.processNotifier.addListener(_handleProcessStatusChanged);
    _didSetupController = true;
  }

  @override
  void dispose() {
    if (_didSetupController) {
      _controller.processNotifier.removeListener(_handleProcessStatusChanged);
    }
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    if (_ownsController && Get.isRegistered<ChangePasswordController>()) {
      Get.delete<ChangePasswordController>();
    }
    super.dispose();
  }

  void _handleProcessStatusChanged() {
    final status = _controller.processNotifier.status;
    if (status is SuccessStatus && !_handledSuccess) {
      _handledSuccess = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (Navigator.of(context).canPop()) {
          Get.back<void>();
        }
      });
      return;
    }

    if (status is! SuccessStatus) {
      _handledSuccess = false;
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onCurrentPasswordChanged(String value) {
    _controller.currentPassword = value;
    setState(() {});
  }

  void _onNewPasswordChanged(String value) {
    _controller.newPassword = value;
    setState(() {});
  }

  void _onConfirmPasswordChanged(String value) {
    _controller.confirmPassword = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final confirmMismatch = _confirmPasswordController.text.isNotEmpty &&
        !_controller.passwordsMatch;
    final content = _buildContent(confirmMismatch: confirmMismatch);

    if (widget.showAsDialog) {
      return content;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(child: content),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent({required bool confirmMismatch}) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
            const SizedBox(height: 18),
            _PasswordField(
              label: 'Current Password',
              controller: _currentPasswordController,
              onChanged: _onCurrentPasswordChanged,
            ),
            const SizedBox(height: 16),
            _PasswordField(
              label: 'New Password',
              controller: _newPasswordController,
              onChanged: _onNewPasswordChanged,
            ),
            const SizedBox(height: 16),
            _PasswordField(
              label: 'Confirm Password',
              controller: _confirmPasswordController,
              onChanged: _onConfirmPasswordChanged,
            ),
            if (confirmMismatch) ...[
              const SizedBox(height: 2),
              const Text(
                'Passwords do not match.',
                style: TextStyle(
                  color: Color(0xFFFF2B55),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const SizedBox(height: 14),
            _RuleItem(
              passed: _controller.hasMinLength,
              text:
                  'Minimo de 8 a 12 caracteres (se recomienda 12+ para mayor seguridad).',
            ),
            _RuleItem(
              passed: _controller.hasUppercase,
              text:
                  'Debe haber al menos una letra mayuscula.',
            ),
            _RuleItem(
              passed: _controller.hasLowercase,
              text:
                  'Debe haber al menos una letra minuscula.',
            ),
            _RuleItem(
              passed: _controller.hasDigit,
              text: 'Al menos un numero debe (0-9).',
            ),
            _RuleItem(
              passed: _controller.hasSpecialCharacter,
              text:
                  'Al menos un caracter especial (! @ # \$ % ^ & * etc.).',
            ),
            _RuleItem(
              passed: _controller.hasNoSpaces,
              text: 'No se permiten espacios.',
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () => Get.back<void>(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFC026FF),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _controller.processNotifier,
                    builder: (context, _) {
                      final status = _controller.processNotifier.status;
                      final isLoading = status is LoadingStatus;
                      final isEnabled = status is EnabledStatus;

                      return SizedBox(
                        height: 54,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: _saveGradient,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap:
                                  isEnabled ? _controller.changePassword : null,
                              child: Opacity(
                                opacity: isEnabled || isLoading ? 1 : 0.45,
                                child: Center(
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.4,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Save',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Change Password',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        IconButton(
          onPressed: () => Get.back<void>(),
          icon: const Icon(Icons.close, color: Colors.white70),
        ),
      ],
    );
  }
}

class _PasswordField extends StatefulWidget {
  const _PasswordField({
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: widget.controller,
          obscureText: _obscureText,
          onChanged: widget.onChanged,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
          ),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: '********',
            hintStyle: const TextStyle(
              color: Color(0xFFD7D7D7),
              fontSize: 18,
              letterSpacing: 0.5,
            ),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 1.4,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: () => setState(() => _obscureText = !_obscureText),
              icon: Icon(
                _obscureText ? Icons.visibility_off_outlined : Icons.visibility,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RuleItem extends StatelessWidget {
  const _RuleItem({
    required this.passed,
    required this.text,
  });

  final bool passed;
  final String text;

  @override
  Widget build(BuildContext context) {
    final color = passed ? const Color(0xFF6D6DFF) : const Color(0xFFFF1648);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(
              passed ? Icons.check : Icons.close,
              size: 22,
              color: color,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
