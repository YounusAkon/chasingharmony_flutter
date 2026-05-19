import 'dart:async';
import 'package:app_pigeon/app_pigeon.dart';
import 'package:chasingharmony_fluttere/app/app_manager.dart';
import 'package:chasingharmony_fluttere/features/app_ground.dart';
import 'package:chasingharmony_fluttere/features/onbording/common/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/onbording/onboarding1.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
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
    return const Scaffold(body: Center(child: AppLogo()));
  }
}
