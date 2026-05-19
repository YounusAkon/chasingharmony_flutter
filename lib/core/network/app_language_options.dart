import 'package:chasingharmony_fluttere/core/localization/app_language_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

Options? appLanguageOptions() {
  if (!Get.isRegistered<AppLanguageController>()) {
    return null;
  }

  return Options(headers: Get.find<AppLanguageController>().headers);
}

Map<String, dynamic>? appLanguageQueryParameters() {
  if (!Get.isRegistered<AppLanguageController>()) {
    return null;
  }

  return <String, dynamic>{
    'language': Get.find<AppLanguageController>().languageCode.value,
  };
}
