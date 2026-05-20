import 'package:chasingharmony_fluttere/core/common/widget/reactive_button/save_button.dart';
import 'package:chasingharmony_fluttere/features/auth/presentation/screens/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/notifiers/snackbar_notifier.dart';
import '../../../onbording/common/app_logo.dart';
import '../../controller/verify_account_view_controller.dart';

class EnterOtp extends StatefulWidget {
  final String email;

  const EnterOtp({super.key, required this.email});

  @override
  State<EnterOtp> createState() => _EnterOtpState();
}

class _EnterOtpState extends State<EnterOtp> {
  static const int _otpLength = 4;
  static const LinearGradient _buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF45A5FF), Color(0xFFC026FF)],
  );
  static const Color _backgroundTop = Color(0xFF090113);
  static const Color _backgroundBottom = Color(0xFF040109);
  static const Color _fieldBorder = Color(0xFF8F00FF);
  static const Color _hintText = Color(0xFFDAD4E6);

  final List<TextEditingController> _otpControllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _otpLength,
    (_) => FocusNode(),
  );

  late final VerifyForgetPasswordOtpController controller;

  String get _otp => _otpControllers.map((c) => c.text).join();

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      VerifyForgetPasswordOtpController(
        email: widget.email,
        snackbarNotifier: SnackbarNotifier(context: context),
      ),
    );
  }

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _syncOtp() {
    controller.otp = _otp;
  }

  void _setDigit(int index, String digit) {
    _otpControllers[index].text = digit;
    _otpControllers[index].selection = TextSelection.collapsed(
      offset: _otpControllers[index].text.length,
    );
  }

  void _applyOtpInput(int index, String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      _setDigit(index, '');
      _syncOtp();
      return;
    }

    if (digits.length == 1) {
      _setDigit(index, digits);
      if (index < _otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
      _syncOtp();
      return;
    }

    var cursor = index;
    for (final digit in digits.split('')) {
      if (cursor >= _otpLength) break;
      _setDigit(cursor, digit);
      cursor++;
    }

    if (cursor >= _otpLength) {
      _focusNodes[_otpLength - 1].unfocus();
    } else {
      _focusNodes[cursor].requestFocus();
    }

    _syncOtp();
  }

  void _handleBackspace(int index, KeyEvent event) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.backspace) {
      return;
    }

    if (_otpControllers[index].text.isNotEmpty) {
      _setDigit(index, '');
      _syncOtp();
      return;
    }

    if (index == 0) return;

    _focusNodes[index - 1].requestFocus();
    _setDigit(index - 1, '');
    _syncOtp();
  }

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.fromLTRB(14, 18, 14, 28),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 34),
                        const AppLogo(height: 86, width: 112),
                        const SizedBox(height: 54),
                        const Text(
                          'Code',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Enter the 4-digit code sent to your\nemail',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _hintText,
                            fontSize: 16,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_otpLength, (index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index == _otpLength - 1 ? 0 : 12,
                              ),
                              child: SizedBox(
                                width: 48,
                                height: 48,
                                child: Focus(
                                  onKeyEvent: (_, event) {
                                    _handleBackspace(index, event);
                                    return KeyEventResult.ignored;
                                  },
                                  child: TextField(
                                    controller: _otpControllers[index],
                                    focusNode: _focusNodes[index],
                                    autofocus: index == 0,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    textInputAction: index == _otpLength - 1
                                        ? TextInputAction.done
                                        : TextInputAction.next,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    cursorColor: Colors.white,
                                    maxLength: _otpLength,
                                    decoration: InputDecoration(
                                      counterText: '',
                                      contentPadding: EdgeInsets.zero,
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: _fieldBorder,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: _fieldBorder,
                                          width: 1.4,
                                        ),
                                      ),
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    onChanged: (value) {
                                      _applyOtpInput(index, value);
                                    },
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: RSaveButton(
                            key: const ValueKey('verify_otp_button'),
                            saveText: 'Verify',
                            loadingText: 'Verifying...',
                            doneText: 'Verified',
                            errorText: 'Invalid code',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            backgroundGradient: _buttonGradient,
                            borderRadius: BorderRadius.circular(10),
                            disabledBackgroundColor: Colors.white.withValues(
                              alpha: 0.1,
                            ),
                            buttonStatusNotifier: controller.prcessNotifier,
                            onSaveTap: controller.verify,
                            onDone: () {
                              if (controller.resetToken.isEmpty) return;
                              Get.to(
                                () => ResetPassword(
                                  resetToken: controller.resetToken,
                                ),
                              );
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
