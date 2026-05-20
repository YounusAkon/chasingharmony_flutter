import 'package:chasingharmony_fluttere/core/common/widget/reactive_button/save_button.dart';
import 'package:chasingharmony_fluttere/core/notifiers/snackbar_notifier.dart';
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
  static const LinearGradient _loginGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF45A5FF), Color(0xFFC026FF)],
  );
  static const Color _bgTop = Color(0xFF090113);
  static const Color _bgBottom = Color(0xFF040109);

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(
      LoginController(SnackbarNotifier(context: context)),
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
                  _bgTop.withValues(alpha: 0.9),
                  _bgBottom.withValues(alpha: 0.96),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Form(
              key: _formKey,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(10, 14, 10, 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 28,
                            child: Row(
                              children: const [
                                Spacer(),
                                Icon(Icons.signal_cellular_alt, size: 14, color: Colors.white),
                                SizedBox(width: 4),
                                Icon(Icons.wifi, size: 14, color: Colors.white),
                                SizedBox(width: 4),
                                Icon(Icons.battery_full, size: 16, color: Colors.white),
                              ],
                            ),
                          ),
                          const SizedBox(height: 44),
                          const Center(child: AppLogo()),
                          const SizedBox(height: 38),
                          _buildField(
                            child: LabeledTextField(
                              title: "auth.loginEmail".tr,
                              hintText: "you@gmail.com",
                              textSize: 14,
                              titleColor: Colors.white,
                              textColor: Colors.white,
                              hintTextColor: const Color(0xFFA8A3B8),
                              hintTextSize: 13,
                              borderColor: const Color(0xFF8A809E),
                              focusedBorderColor: const Color(0xFFC16BFF),
                              backgroundColor: Colors.white.withValues(alpha: 0.02),
                              borderRadius: 6,
                              height: 46,
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
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
                          ),
                          _buildField(
                            child: LabeledTextField(
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
                              borderRadius: 6,
                              height: 46,
                              controller: controller.passwordController,
                              isPassword: true,
                              passwordHiddenColor: Colors.white70,
                              passwordVisibleColor: const Color(0xFFC16BFF),
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
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Get.to(() => const ForgetPassword()),
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: Color(0xFFC026FF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: RSaveButton(
                              key: const ValueKey('login_button'),
                              saveText: 'Login',
                              loadingText: 'Login',
                              doneText: 'Login',
                              errorText: 'Login',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              backgroundGradient: _loginGradient,
                              borderRadius: BorderRadius.circular(10),
                              disabledBackgroundColor: Colors.white.withValues(alpha: 0.1),
                              buttonStatusNotifier: controller.processStatusNotifier,
                              onSaveTap: () {
                                if (!_formKey.currentState!.validate()) return;
                                controller.login(
                                  onSuccess: () => Get.offAll(() => AppGround()),
                                  needVerifyAccount: () {},
                                );
                              },
                              onDone: () => Get.offAll(() => AppGround()),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                    color: Color(0xFFD8D3E5),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Get.to(() => SignupScreen()),
                                  style: TextButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: const EdgeInsets.symmetric(horizontal: 3),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Color(0xFFC026FF),
                                      fontSize: 12,
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

  Widget _buildField({required Widget child}) {
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
