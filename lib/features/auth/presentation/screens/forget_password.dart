import 'package:chasingharmony_fluttere/features/auth/presentation/screens/enter_otp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widget/reactive_button/save_button.dart';
import '../../../../core/notifiers/snackbar_notifier.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../onbording/common/app_logo.dart';
import '../../../onbording/common/textfield.dart';
import '../../controller/forget_password_controller.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ForgetPasswordController(SnackbarNotifier(context: context)),
    );

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              const Spacer(),
              const AppLogo(height: 44, width: 130),
              const SizedBox(height: 26),
              const Text(
                "Reset password",
                style: TextStyle(
                  color: AppColors.authHeading,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Enter your email to receive the OTP",
                style: TextStyle(color: AppColors.authSubtitle, fontSize: 14),
              ),
              const SizedBox(height: 14),
              LabeledTextField(
                title: "Your Email",
                hintText: "Enter your Email",
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
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
                prefixIcon: Icons.email_outlined,
                prefixIconColor: AppColors.authFieldHint,
                prefixIconSize: 18,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: RSaveButton(
                  key: null,
                  saveText: "Send OTP",
                  loadingText: "Sending OTP...",
                  doneText: "OTP sent",
                  errorText: "Failed",
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
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
