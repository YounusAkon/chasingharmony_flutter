import 'package:chasingharmony_fluttere/features/auth/presentation/screens/login_screen.dart';
import 'package:chasingharmony_fluttere/features/auth/repo/auth_interface.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  bool _isLoading = false;

  Future<void> _handleLogout() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final result = await Get.find<AuthInterface>().logout();

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() => _isLoading = false);
        Get.snackbar('common.error'.tr, failure.uiMessage);
      },
      (_) {
        Get.offAll(() => const LoginScreen());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F3),
        surfaceTintColor: const Color(0xFFF3F3F3),
        elevation: 0,
        scrolledUnderElevation: 0,

        title: Text(
          'profile.logout'.tr,
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFDADADA)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'profile.logoutConfirm'.tr,
                  style: const TextStyle(
                    color: Color(0xFF151515),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : Get.back,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFD12D2E)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            foregroundColor: const Color(0xFF1F1F1F),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'common.cancel'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogout,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFFD12D2E),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFFE18E8F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'profile.logout'.tr,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
