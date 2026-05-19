import 'package:app_pigeon/app_pigeon.dart';
import 'package:chasingharmony_fluttere/core/localization/app_language_controller.dart';
import 'package:get/get.dart';
import '../../app/app_manager.dart';
import '../../app/controller/app_ground_controller.dart';
import '../../features/auth/repo/auth_interface.dart';
import '../../features/auth/repo/auth_interface_impl.dart';
import '../../features/home/controller/safety_tips_controller.dart';
import '../../features/home/services/home_sercices/home_interface.dart';
import '../../features/home/services/home_sercices/home_interface_impl.dart';
import '../../features/home/services/safety_services/safety_interface_impl.dart';
import '../../features/home/services/safety_services/saftey_interface.dart';
import '../../features/notification/controller/notification_controller.dart';
import '../../features/notification/services/notification_interface.dart';
import '../../features/notification/services/notification_interface_impl.dart';
import '../../features/profile/controller/edit_profile_controller.dart';
import '../../features/profile/controller/get_profile_controller.dart';
import '../../features/profile/repo/profile_interface.dart';
import '../../features/profile/repo/profile_interface_impl.dart';

Future<void> initServices() async {
  if (!Get.isRegistered<AppLanguageController>()) {
    final languageController = Get.put<AppLanguageController>(
      AppLanguageController(),
      permanent: true,
    );
    await languageController.load();
  }

  Get.lazyPut<AuthInterface>(
    () => AuthInterfaceImpl(Get.find<AuthorizedPigeon>()),
    fenix: true,
  );

  if (!Get.isRegistered<AppManager>()) {
    Get.put<AppManager>(AppManager(), permanent: true);
  }

  if (!Get.isRegistered<AppGroundController>()) {
    Get.put<AppGroundController>(AppGroundController(), permanent: true);
  }

  Get.lazyPut<ProfilInterface>(
    () => ProfileInterfaceImpl(appPigeon: Get.find()),
    fenix: true,
  );

  Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  Get.lazyPut<ProfileEditController>(
    () => ProfileEditController(),
    fenix: true,
  );

  Get.lazyPut<NotificationInterface>(
    () => NotificationInterfaceImpl(appPigeon: Get.find<AppPigeon>()),
    fenix: true,
  );
  Get.lazyPut<NotificationController>(
    () => NotificationController(notificationInterface: Get.find()),
    fenix: true,
  );


  Get.lazyPut<SafetyInterface>(
    () => SafetyInterfaceImpl(appPigeon: Get.find<AppPigeon>()),
    fenix: true,
  );
  Get.lazyPut<HomeInterface>(
    () => HomeInterfaceImpl(appPigeon: Get.find<AppPigeon>()),
    fenix: true,
  );
  Get.lazyPut<SafetyTipsController>(
    () => SafetyTipsController(safetyInterface: Get.find<SafetyInterface>()),
    fenix: true,
  );
}
