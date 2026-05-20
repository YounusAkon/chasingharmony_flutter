import 'dart:async';

import 'package:app_pigeon/app_pigeon.dart';
import 'package:chasingharmony_fluttere/app/app_manager.dart';
import 'package:chasingharmony_fluttere/features/app_ground.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/onbording/onboarding1.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  static const Color _bgTop = Color(0xFF090113);
  static const Color _bgBottom = Color(0xFF040109);

  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(milliseconds: 1000), _navigateNext);
  }

  void _navigateNext() {
    final appManager = Get.find<AppManager>();

    if (appManager.currentAuthStatus is Authenticated) {
      // User is logged in → go to AppGround
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AppGround()),
      );
    } else {
      // User not logged in → go to Login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Onboarding1Screen()),
      );
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/image/backgroundimage.png',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _bgTop.withValues(alpha: 0.94),
                  _bgBottom.withValues(alpha: 0.98),
                ],
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 48,
            right: 48,
            child: IgnorePointer(
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFA020F0).withValues(alpha: 0.25),
                      blurRadius: 70,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 240,
                    child: Image.asset(
                      'assets/logo/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 182,
                    height: 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.transparent,
                          Color(0xFFB87CFF),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
