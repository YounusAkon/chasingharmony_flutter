import 'dart:async';
import 'package:chasingharmony_fluttere/core/common/widget/reactive_button/save_button.dart';
import 'package:chasingharmony_fluttere/features/auth/presentation/screens/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/notifiers/snackbar_notifier.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../onbording/common/app_logo.dart';
import '../../controller/verify_account_view_controller.dart';

class EnterOtp extends StatefulWidget {
  final String email;

  const EnterOtp({super.key, required this.email});

  @override
  State<EnterOtp> createState() => _EnterOtpState();
}

class _EnterOtpState extends State<EnterOtp> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  late final VerifyForgetPasswordOtpController controller;
  Timer? _timer;
  int _resendSeconds = 45;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      VerifyForgetPasswordOtpController(
        email: widget.email,
        snackbarNotifier: SnackbarNotifier(context: context),
      ),
    );
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otp => _otpControllers.map((c) => c.text).join();

  void _startTimer() {
    _timer?.cancel();
    _resendSeconds = 45;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_resendSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() {
          _resendSeconds--;
        });
      }
    });
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    controller.otp = _otp;
  }

  void _onBackspace(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _otpControllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const Spacer(),
              const AppLogo(height: 44, width: 130),
              const SizedBox(height: 20),
              const Text(
                "Enter OTP",
                style: TextStyle(
                  color: AppColors.authHeading,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 40,
                    height: 46,
                    child: Focus(
                      onKeyEvent: (_, event) {
                        _onBackspace(index, event);
                        return KeyEventResult.ignored;
                      },
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          color: AppColors.authHeading,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.authOtpFieldBorder,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.authPrimaryRed,
                              width: 1.5,
                            ),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) => _onChanged(index, value),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),
              Text(
                "Resend code in ${_resendSeconds}s",
                style: const TextStyle(
                  color: AppColors.authSubtitle,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn’t Receive OTP? ",
                    style: TextStyle(
                      color: AppColors.authHeading,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: _resendSeconds == 0
                        ? () {
                            controller.snackbarNotifier.notifySuccess(
                              message: "OTP sent again",
                            );
                            _startTimer();
                          }
                        : null,
                    child: Text(
                      "RESEND OTP",
                      style: TextStyle(
                        color: _resendSeconds == 0
                            ? AppColors.authLinkBlue
                            : AppColors.authSubtitle,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: RSaveButton(
                  key: null,
                  saveText: "Verify Now",
                  loadingText: "Verifying...",
                  doneText: "Verified",
                  errorText: "Invalid OTP",
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
                  buttonStatusNotifier: controller.prcessNotifier,
                  onSaveTap: () {
                    controller.verify();
                  },
                  onDone: () {
                    Get.to(
                      () => ResetPassword(
                        email: widget.email,
                        otp: controller.otp,
                      ),
                    );
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
