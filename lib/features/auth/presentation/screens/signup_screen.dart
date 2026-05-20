import 'package:chasingharmony_fluttere/core/common/widget/reactive_button/save_button.dart';
import 'package:chasingharmony_fluttere/core/notifiers/snackbar_notifier.dart';
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
  final TextEditingController _fullNameController = TextEditingController();

  late final SnackbarNotifier snackbarNotifier;
  static const LinearGradient _signupGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF45A5FF), Color(0xFFC026FF)],
  );
  static const Color _bgTop = Color(0xFF090113);
  static const Color _bgBottom = Color(0xFF040109);

  @override
  void initState() {
    super.initState();
    snackbarNotifier = SnackbarNotifier(context: context);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/image/backgroundimage.png', fit: BoxFit.cover),
          SafeArea(
            child: Form(
              key: _formKey,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(
                          //   height: 28,
                          //   child: Row(
                          //     children: const [
                          //       Spacer(),
                          //       Icon(Icons.signal_cellular_alt, size: 14, color: Colors.white),
                          //       SizedBox(width: 4),
                          //       Icon(Icons.wifi, size: 14, color: Colors.white),
                          //       SizedBox(width: 4),
                          //       Icon(Icons.battery_full, size: 16, color: Colors.white),
                          //     ],
                          //   ),
                          // ),
                          const SizedBox(height: 44),
                          const Center(child: AppLogo()),
                          const SizedBox(height: 26),
                          _buildField(
                            LabeledTextField(
                              title: "auth.userName".tr,
                              hintText: "auth.userNameHint".tr,
                              textSize: 14,
                              titleColor: Colors.white,
                              textColor: Colors.white,
                              hintTextColor: const Color(0xFFA8A3B8),
                              hintTextSize: 13,
                              borderColor: const Color(0xFF8A809E),
                              focusedBorderColor: const Color(0xFFC16BFF),
                              backgroundColor: Colors.white.withValues(alpha: 0.02),
                              borderRadius: 8,
                              height: 46,
                              controller: _fullNameController,
                              onChanged: controller.setFullName,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "auth.enterName".tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          _buildField(
                            LabeledTextField(
                              title: "auth.yourEmail".tr,
                              hintText: "you@gmail.com",
                              textSize: 14,
                              titleColor: Colors.white,
                              textColor: Colors.white,
                              hintTextColor: const Color(0xFFA8A3B8),
                              hintTextSize: 13,
                              borderColor: const Color(0xFF8A809E),
                              focusedBorderColor: const Color(0xFFC16BFF),
                              backgroundColor: Colors.white.withValues(alpha: 0.02),
                              borderRadius: 8,
                              height: 46,
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
                          ),
                          _buildField(
                            LabeledTextField(
                              title: "auth.password".tr,
                              hintText: "********",
                              textSize: 14,
                              titleColor: Colors.white,
                              textColor: Colors.white,
                              hintTextColor: const Color(0xFFA8A3B8),
                              hintTextSize: 13,
                              borderColor: const Color(0xFF8A809E),
                              focusedBorderColor: const Color(0xFFC16BFF),
                              backgroundColor: Colors.white.withValues(alpha: 0.02),
                              borderRadius: 8,
                              height: 46,
                              isPassword: true,
                              passwordHiddenColor: Colors.white70,
                              passwordVisibleColor: const Color(0xFFC16BFF),
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
                          ),
                          _buildField(
                            LabeledTextField(
                              title: "auth.confirmPassword".tr,
                              hintText: "********",
                              textSize: 14,
                              titleColor: Colors.white,
                              textColor: Colors.white,
                              hintTextColor: const Color(0xFFA8A3B8),
                              hintTextSize: 13,
                              borderColor: const Color(0xFF8A809E),
                              focusedBorderColor: const Color(0xFFC16BFF),
                              backgroundColor: Colors.white.withValues(alpha: 0.02),
                              borderRadius: 8,
                              height: 46,
                              isPassword: true,
                              passwordHiddenColor: Colors.white70,
                              passwordVisibleColor: const Color(0xFFC16BFF),
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
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: RSaveButton(
                              key: const ValueKey('signup_button'),
                              saveText: "auth.signUp".tr,
                              loadingText: "auth.creatingAccount".tr,
                              doneText: "auth.accountCreated".tr,
                              errorText: "auth.signupFailed".tr,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              backgroundGradient: _signupGradient,
                              borderRadius: BorderRadius.circular(10),
                              disabledBackgroundColor: Colors.white.withValues(alpha: 0.1),
                              buttonStatusNotifier: controller.processNotifier,
                              onSaveTap: () {
                                if (!_formKey.currentState!.validate()) return;
                                FocusScope.of(context).unfocus();
                                controller.signup(
                                  buttonNotifier: controller.processNotifier,
                                  snackbarNotifier: snackbarNotifier,
                                );
                              },
                              onDone: () {
                                Get.offAll(() => const LoginScreen());
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.center,
                              children: [
                                const Text(
                                  'Already have an account?',
                                  style: TextStyle(
                                    color: Color(0xFFD8D3E5),
                                    fontSize: 13,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.off(() => const LoginScreen());
                                  },
                                  style: TextButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: Color(0xFFC026FF),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(Widget child) {
    return Theme(
      data: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          errorStyle: TextStyle(
            color: Color(0xFFFF9CC7),
            fontSize: 11,
          ),
        ),
      ),
      child: child,
    );
  }
}
