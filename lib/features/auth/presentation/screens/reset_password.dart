import 'package:chasingharmony_fluttere/core/common/widget/reactive_button/save_button.dart';
import 'package:chasingharmony_fluttere/core/notifiers/snackbar_notifier.dart';
import 'package:chasingharmony_fluttere/core/theme/app_colors.dart';
import 'package:chasingharmony_fluttere/features/auth/controller/create_new_password_controller.dart';
import 'package:chasingharmony_fluttere/features/auth/presentation/screens/login_screen.dart';
import 'package:chasingharmony_fluttere/features/onbording/common/app_logo.dart';
import 'package:chasingharmony_fluttere/features/onbording/common/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ResetPassword extends StatelessWidget {
  final String email;
  final String otp;

  const ResetPassword({super.key, required this.email, required this.otp});

  @override
  Widget build(BuildContext context) {
    final ResetPasswordController controller = Get.put(
      ResetPasswordController(email: email, otp: otp),
    );

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const Spacer(),
              const AppLogo(height: 44, width: 130),
              const SizedBox(height: 20),
              const Text(
                "Reset New password",
                style: TextStyle(
                  color: AppColors.authHeading,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Enter your new password and confirm password",
                style: TextStyle(color: AppColors.authSubtitle, fontSize: 14),
              ),
              const SizedBox(height: 14),
              LabeledTextField(
                title: "New Password",
                hintText: "Enter your Password",
                isPassword: true,
                onChanged: (v) => controller.newPassword = v,
                textSize: 14,
                titleColor: AppColors.authHeading,
                textColor: AppColors.authHeading,
                hintTextColor: AppColors.authFieldHint,
                hintTextSize: 13,
                borderColor: AppColors.authFieldBorder,
                focusedBorderColor: AppColors.authPrimaryRed,
                backgroundColor: Colors.white,
                borderRadius: 6,
                height: 46,
                prefixIcon: Icons.lock_outline,
                prefixIconColor: AppColors.authFieldHint,
                prefixIconSize: 18,
                passwordHiddenColor: AppColors.authFieldHint,
                passwordVisibleColor: AppColors.authFieldHint,
              ),
              LabeledTextField(
                title: "Confirm Password",
                hintText: "Enter Confirm Password",
                isPassword: true,
                onChanged: (v) => controller.confirmPassword = v,
                textSize: 14,
                titleColor: AppColors.authHeading,
                textColor: AppColors.authHeading,
                hintTextColor: AppColors.authFieldHint,
                hintTextSize: 13,
                borderColor: AppColors.authFieldBorder,
                focusedBorderColor: AppColors.authPrimaryRed,
                backgroundColor: Colors.white,
                borderRadius: 6,
                height: 46,
                prefixIcon: Icons.lock_outline,
                prefixIconColor: AppColors.authFieldHint,
                prefixIconSize: 18,
                passwordHiddenColor: AppColors.authFieldHint,
                passwordVisibleColor: AppColors.authFieldHint,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: RSaveButton(
                  key: null,
                  saveText: "Continue",
                  loadingText: "Please wait...",
                  doneText: "Password Reset",
                  errorText: "Failed. Try Again",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  enabledBackgroundColor: AppColors.authPrimaryRed,
                  loadingBackgroundColor: AppColors.authPrimaryRed,
                  errorBackgroundColor: AppColors.authPrimaryRed,
                  successBackgroundColor: AppColors.authPrimaryRed,
                  disabledBackgroundColor: AppColors.authButtonDisabled,
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
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
