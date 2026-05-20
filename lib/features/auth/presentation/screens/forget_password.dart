import 'package:chasingharmony_fluttere/features/auth/presentation/screens/enter_otp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widget/reactive_button/save_button.dart';
import '../../../../core/notifiers/snackbar_notifier.dart';
import '../../../onbording/common/app_logo.dart';
import '../../../onbording/common/textfield.dart';
import '../../controller/forget_password_controller.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  static const LinearGradient _buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF45A5FF), Color(0xFFC026FF)],
  );
  static const Color _backgroundTop = Color(0xFF090113);
  static const Color _backgroundBottom = Color(0xFF040109);
  static const Color _fieldBorder = Color(0xFFFFFFFF);
  static const Color _hintText = Color(0xFFDAD4E6);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ForgetPasswordController(SnackbarNotifier(context: context)),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/image/backgroundimage.png', fit: BoxFit.cover),
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
                        const Center(child: AppLogo()),
                        const SizedBox(height: 54),
                        const Center(
                          child: Text(
                            'Forgot Password?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Center(
                          child: Text(
                            'Enter your email and we\'ll send you a\ncode to reset your password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _hintText,
                              fontSize: 16,
                              height: 1.45,
                            ),
                          ),
                        ),
                        const SizedBox(height: 34),
                        LabeledTextField(
                          title: 'Email',
                          hintText: 'you@gmail.com',
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
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
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: RSaveButton(
                            key: const ValueKey('forgot_password_button'),
                            saveText: 'Next',
                            loadingText: 'Sending...',
                            doneText: 'Sent',
                            errorText: 'Failed',
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
                            buttonStatusNotifier: controller.processStatusNotifier,
                            onSaveTap: () {
                              controller.forgetPassword(
                                onSuccess: () {
                                  Get.to(() => EnterOtp(email: controller.email));
                                },
                              );
                            },
                            onDone: () {},
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
