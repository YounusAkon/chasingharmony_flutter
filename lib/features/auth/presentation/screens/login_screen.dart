import 'package:chasingharmony_fluttere/core/common/widget/reactive_button/save_button.dart';
import 'package:chasingharmony_fluttere/core/notifiers/snackbar_notifier.dart';
import 'package:chasingharmony_fluttere/core/theme/app_colors.dart';
import 'package:chasingharmony_fluttere/features/app_ground.dart';
import 'package:chasingharmony_fluttere/features/auth/controller/login_controller.dart';
import 'package:chasingharmony_fluttere/features/auth/presentation/screens/forget_password.dart';
import 'package:chasingharmony_fluttere/features/auth/presentation/screens/signup_screen.dart';
import 'package:chasingharmony_fluttere/features/onbording/common/app_logo.dart';
import 'package:chasingharmony_fluttere/features/onbording/common/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(
      LoginController(SnackbarNotifier(context: context)),
    );

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 72),
                          const Center(child: AppLogo(height: 44, width: 130)),
                          const SizedBox(height: 40),
                          LabeledTextField(
                            title: "auth.loginEmail".tr,
                            hintText: "auth.loginEmailHint".tr,
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
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            prefixIconColor: AppColors.authFieldHint,
                            prefixIconSize: 18,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "auth.pleaseEnterEmail".tr;
                              }
                              if (!GetUtils.isEmail(value)) {
                                return "auth.invalidEmail".tr;
                              }
                              return null;
                            },
                          ),
                          LabeledTextField(
                            title: "auth.password".tr,
                            hintText: "auth.passwordHint".tr,
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
                            controller: controller.passwordController,
                            prefixIcon: Icons.lock_outline,
                            prefixIconColor: AppColors.authFieldHint,
                            prefixIconSize: 18,
                            isPassword: true,
                            passwordHiddenColor: AppColors.authFieldHint,
                            passwordVisibleColor: AppColors.authFieldHint,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "auth.pleaseEnterPassword".tr;
                              }
                              if (value.length < 6) {
                                return "auth.passwordMin".tr;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Get.to(() => const ForgetPassword());
                              },
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                "auth.forgotPassword".tr,
                                style: TextStyle(
                                  color: AppColors.authLinkBlue,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 51,
                            child: RSaveButton(
                              key: null,
                              saveText: "auth.signIn".tr,
                              loadingText: "auth.signingIn".tr,
                              doneText: "auth.signedIn".tr,
                              errorText: "auth.signInFailed".tr,
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
                              disabledBackgroundColor:
                                  AppColors.authButtonDisabled,
                              buttonStatusNotifier:
                                  controller.processStatusNotifier,
                              onSaveTap: () {
                                if (!_formKey.currentState!.validate()) return;
                                controller.login(
                                  onSuccess: () {
                                    Get.offAll(() => AppGround());
                                  },
                                  needVerifyAccount: () {},
                                );
                              },
                              onDone: () {
                                Get.offAll(() => AppGround());
                              },
                            ),
                          ),
                          const SizedBox(height: 32),
                          Center(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  "auth.noAccount".tr,
                                  style: TextStyle(
                                    color: AppColors.authHeading,
                                    fontSize: 16,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.to(() => SignupScreen());
                                  },
                                  style: TextButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 0,
                                    ),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    "auth.signUpHere".tr,
                                    style: TextStyle(
                                      color: AppColors.authLinkBlue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          Obx(
                            () => _socialButton(
                              icon: Container(
                                width: 24,
                                height: 24,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.authFieldBorder,
                                  ),
                                ),
                                child: Image.asset(
                                  "assets/icon/google.png",
                                  width: 28,
                                  height: 28,
                                )
                              ),
                              text: controller.isSocialLoading.value
                                  ? "auth.signingIn".tr
                                  : "auth.continueGoogle".tr,
                              isLoading: controller.isSocialLoading.value,
                              enabled: !controller.isSocialLoading.value,
                              onTap: () {
                                controller.googleLogin(
                                  onSuccess: () {
                                    Get.offAll(() => AppGround());
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          // _socialButton(
                          //   icon: const Icon(
                          //     Icons.facebook,
                          //     color: AppColors.authFacebookBlue,
                          //     size: 20,
                          //   ),
                          //   text: "auth.continueFacebook".tr,
                          //   onTap: () {},
                          // ),
                          const Spacer(),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _socialButton({
    required Widget icon,
    required String text,
    required VoidCallback onTap,
    bool enabled = true,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          color: enabled ? Colors.white : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.authFieldBorder),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.authHeading,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isLoading) ...[
              const SizedBox(width: 10),
              const SizedBox(
                height: 14,
                width: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
