import 'package:chasingharmony_fluttere/core/common/widget/reactive_button/save_button.dart';
import 'package:chasingharmony_fluttere/core/notifiers/snackbar_notifier.dart';
import 'package:chasingharmony_fluttere/core/theme/app_colors.dart';
import 'package:chasingharmony_fluttere/features/auth/controller/sign_up_controller.dart';
import 'package:chasingharmony_fluttere/features/auth/presentation/screens/login_screen.dart';
import 'package:chasingharmony_fluttere/features/onbording/common/app_logo.dart';
import 'package:chasingharmony_fluttere/features/onbording/common/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final SignUpController controller = Get.put(SignUpController());
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  late final SnackbarNotifier snackbarNotifier;

  @override
  void initState() {
    super.initState();
    snackbarNotifier = SnackbarNotifier(context: context);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          const SizedBox(height: 24),
                          const Center(child: AppLogo(height: 44, width: 130)),
                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              "auth.signupHero".tr,
                              style: TextStyle(
                                color: AppColors.authHeading,
                                fontSize: 27,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Center(
                            child: Text(
                              "auth.createAccount".tr,
                              style: TextStyle(
                                color: AppColors.authSubtitle,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          LabeledTextField(
                            title: "auth.userName".tr,
                            hintText: "auth.userNameHint".tr,
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
                            prefixIcon: Icons.person_outline,
                            prefixIconColor: AppColors.authFieldHint,
                            prefixIconSize: 18,
                            onChanged: controller.setUsername,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "auth.enterName".tr;
                              }
                              return null;
                            },
                          ),
                          LabeledTextField(
                            title: "auth.yourEmail".tr,
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
                            prefixIcon: Icons.email_outlined,
                            prefixIconColor: AppColors.authFieldHint,
                            prefixIconSize: 18,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: controller.setEmail,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "auth.pleaseEnterEmail".tr;
                              }
                              if (!GetUtils.isEmail(value)) {
                                return "auth.invalidEmail".tr;
                              }
                              return null;
                            },
                          ),
                          LabeledTextField(
                            title: "auth.phoneNumber".tr,
                            hintText: "auth.phoneNumberHint".tr,
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
                            prefixIcon: Icons.phone_outlined,
                            prefixIconColor: AppColors.authFieldHint,
                            prefixIconSize: 18,
                            keyboardType: TextInputType.phone,
                            controller: _phoneController,
                            onChanged: controller.setPhoneNumber,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "auth.enterPhoneNumber".tr;
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
                            prefixIcon: Icons.lock_outline,
                            prefixIconColor: AppColors.authFieldHint,
                            prefixIconSize: 18,
                            isPassword: true,
                            passwordHiddenColor: AppColors.authFieldHint,
                            passwordVisibleColor: AppColors.authFieldHint,
                            controller: _passwordController,
                            onChanged: controller.setPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "auth.enterPassword".tr;
                              }
                              if (value.length < 6) {
                                return "auth.minimumSixCharacters".tr;
                              }
                              return null;
                            },
                          ),
                          LabeledTextField(
                            title: "auth.confirmPassword".tr,
                            hintText: "auth.confirmPasswordHint".tr,
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
                            isPassword: true,
                            passwordHiddenColor: AppColors.authFieldHint,
                            passwordVisibleColor: AppColors.authFieldHint,
                            controller: _confirmPasswordController,
                            onChanged: controller.setConfirmPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "auth.confirmYourPassword".tr;
                              }
                              if (value != _passwordController.text) {
                                return "auth.passwordsDoNotMatch".tr;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: RSaveButton(
                              key: null,
                              saveText: "auth.signUp".tr,
                              loadingText: "auth.creatingAccount".tr,
                              doneText: "auth.accountCreated".tr,
                              errorText: "auth.signupFailed".tr,
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
                              buttonStatusNotifier: controller.processNotifier,
                              onSaveTap: () {
                                if (!_formKey.currentState!.validate()) return;
                                FocusScope.of(context).unfocus();
                                controller.signup(
                                  buttonNotifier: controller.processNotifier,
                                  snackbarNotifier: snackbarNotifier,
                                  onDone: () {
                                    Get.offAll(() => const LoginScreen());
                                  },
                                );
                              },
                              onDone: () {
                                Get.offAll(() => const LoginScreen());
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  "auth.haveAccount".tr,
                                  style: TextStyle(
                                    color: AppColors.authHeading,
                                    fontSize: 14,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.off(() => const LoginScreen());
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
                                    "auth.signInHere".tr,
                                    style: TextStyle(
                                      color: AppColors.authLinkBlue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(height: 10),
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
}
