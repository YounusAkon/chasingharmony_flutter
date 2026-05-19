import 'package:chasingharmony_fluttere/app/splash_view.dart';
import 'package:chasingharmony_fluttere/core/di/external_service_di.dart';
import 'package:chasingharmony_fluttere/core/di/internal_service_di.dart';
import 'package:chasingharmony_fluttere/core/localization/app_language_controller.dart';
import 'package:chasingharmony_fluttere/core/localization/app_translations.dart';
import 'package:chasingharmony_fluttere/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  externalServiceDI();
  await initServices();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<AppLanguageController>();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'app.title'.tr,
      theme: AppTheme.light,
      translations: AppTranslations(),
      locale: languageController.locale,
      fallbackLocale: AppTranslations.fallbackLocale,
      home: const SplashView(),
    );
  }
}
