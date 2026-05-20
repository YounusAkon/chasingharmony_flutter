import 'package:chasingharmony_fluttere/core/common/widget/reactive_buttons/save_button.dart';
import 'package:chasingharmony_fluttere/core/notifiers/button_status_notifier.dart';
import 'package:chasingharmony_fluttere/features/app_ground.dart';
import 'package:chasingharmony_fluttere/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late final ProcessStatusNotifier _loginButtonNotifier;

  @override
  void initState() {
    super.initState();
    _loginButtonNotifier = ProcessStatusNotifier(
      initialStatus: EnabledStatus(),
    );
  }

  @override
  void dispose() {
    _loginButtonNotifier.dispose();
    super.dispose();
  }

  static const LinearGradient _loginGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF45A5FF), Color(0xFFC026FF)],
  );

  static const Color _bgTop = Color(0xFF090113);
  static const Color _bgBottom = Color(0xFF1B082F);
  static const Color _glow = Color(0xFFA020F0);
  static const Color _body = Color(0xFFD3CBDD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  _bgTop.withValues(alpha: 0.88),
                  _bgBottom.withValues(alpha: 0.95),
                ],
              ),
            ),
          ),
          Positioned(
            top: 110,
            left: -20,
            child: _GlowOrb(size: 180, color: _glow.withValues(alpha: 0.22)),
          ),
          Positioned(
            right: -30,
            top: 34,
            child: _GlowOrb(
              size: 220,
              color: const Color(0xFF7C3AED).withValues(alpha: 0.18),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: _Sparkles(),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.14),
                        const _WelcomeLogoBadge(),
                        const SizedBox(height: 36),
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                            children: [
                              TextSpan(text: 'Welcome to '),
                              TextSpan(
                                text: 'CELY',
                                style: TextStyle(color: Color(0xFFC026FF)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        const SizedBox(
                          width: 310,
                          child: Text(
                            'Meet CELY, your AI companion designed to support you through stress, overwhelm, and emotional challenges with calm, accessible guidance.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _body,
                              fontSize: 14,
                              height: 1.7,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.18),
                        const SizedBox(height: 18),
                        RSaveButton(
                          key: const ValueKey('welcome_login_button'),
                          saveText: 'Login',
                          loadingText: 'Login',
                          errorText: 'Login',
                          doneText: 'Login',
                          height: 68,
                          borderRadius: BorderRadius.circular(26),
                          backgroundGradient: _loginGradient,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                          buttonStatusNotifier: _loginButtonNotifier,
                          onSaveTap: () {
                            Get.to(() => const LoginScreen());
                          },
                          onDone: () {},
                        ),
                        TextButton(
                          onPressed: () => Get.offAll(() => AppGround()),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Continue as a Guest',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
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

class _WelcomeLogoBadge extends StatelessWidget {
  const _WelcomeLogoBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 156,
      height: 156,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFF0F0618), Color(0xFF040109)],
          stops: [0.2, 1.0],
        ),
        border: Border.all(
          color: const Color(0xFFC026FF).withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA020F0).withValues(alpha: 0.38),
            blurRadius: 42,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: ClipOval(
          child: Image.asset(
            'assets/logo/logo.png',
            width: 116,
            height: 116,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _Sparkles extends StatelessWidget {
  const _Sparkles();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.auto_awesome, size: 16, color: Color(0xFFB85AFF)),
        SizedBox(width: 2),
        Icon(Icons.auto_awesome, size: 10, color: Color(0xFFD083FF)),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: size * 0.5,
              spreadRadius: size * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
