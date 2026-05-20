import 'package:chasingharmony_fluttere/core/common/widget/reactive_button/save_button.dart';
import 'package:chasingharmony_fluttere/core/notifiers/snackbar_notifier.dart';
import 'package:chasingharmony_fluttere/features/auth/controller/create_new_password_controller.dart';
import 'package:chasingharmony_fluttere/features/auth/presentation/screens/login_screen.dart';
import 'package:chasingharmony_fluttere/features/onbording/common/app_logo.dart';
import 'package:chasingharmony_fluttere/features/onbording/common/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPassword extends StatelessWidget {
  final String resetToken;

  const ResetPassword({super.key, required this.resetToken});

  static const LinearGradient _buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF45A5FF), Color(0xFFC026FF)],
  );
  static const Color _backgroundTop = Color(0xFF090113);
  static const Color _backgroundBottom = Color(0xFF040109);
  static const Color _fieldBorder = Color(0xFFFFFFFF);
  static const Color _hintText = Color(0xFFDAD4E6);
  static const Color _suffixIcon = Color(0xFFF2EFF7);

  @override
  Widget build(BuildContext context) {
    final ResetPasswordController controller = Get.put(
      ResetPasswordController(resetToken: resetToken),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/image/backgroundimage.png', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _backgroundTop.withValues(alpha: 0.9),
                  _backgroundBottom.withValues(alpha: 0.96),
                ],
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 34),
                        const Center(child: AppLogo(height: 86, width: 112)),
                        const SizedBox(height: 54),
                        const Center(
                          child: Text(
                            'Create New Password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        LabeledTextField(
                          title: 'New Password',
                          hintText: '********',
                          isPassword: true,
                          onChanged: (v) => controller.newPassword = v,
                          textSize: 15,
                          titleColor: Colors.white,
                          textColor: Colors.white,
                          hintTextColor: _hintText,
                          hintTextSize: 15,
                          borderColor: _fieldBorder,
                          focusedBorderColor: _fieldBorder,
                          backgroundColor: Colors.transparent,
                          borderRadius: 10,
                          height: 50,
                          passwordHiddenColor: _suffixIcon,
                          passwordVisibleColor: _suffixIcon,
                        ),
                        LabeledTextField(
                          title: 'Confirm Password',
                          hintText: '********',
                          isPassword: true,
                          onChanged: (v) => controller.confirmPassword = v,
                          textSize: 15,
                          titleColor: Colors.white,
                          textColor: Colors.white,
                          hintTextColor: _hintText,
                          hintTextSize: 15,
                          borderColor: _fieldBorder,
                          focusedBorderColor: _fieldBorder,
                          backgroundColor: Colors.transparent,
                          borderRadius: 10,
                          height: 50,
                          passwordHiddenColor: _suffixIcon,
                          passwordVisibleColor: _suffixIcon,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: RSaveButton(
                            key: const ValueKey('reset_password_button'),
                            saveText: 'Create New Password',
                            loadingText: 'Please wait...',
                            doneText: 'Password Reset',
                            errorText: 'Failed. Try Again',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            backgroundGradient: _buttonGradient,
                            borderRadius: BorderRadius.circular(12),
                            disabledBackgroundColor: Colors.white.withValues(
                              alpha: 0.1,
                            ),
                            buttonStatusNotifier: controller.processNotifier,
                            onSaveTap: () {
                              controller.resetPassword(
                                SnackbarNotifier(context: context),
                              );
                            },
                            onDone: () {
                              Get.offAll(() => const LoginScreen());
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
