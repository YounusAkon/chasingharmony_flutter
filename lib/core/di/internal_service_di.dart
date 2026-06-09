import 'package:app_pigeon/app_pigeon.dart';
import 'package:chasingharmony_fluttere/core/localization/app_language_controller.dart';
import 'package:get/get.dart';
import '../../app/app_manager.dart';
import '../../app/controller/app_ground_controller.dart';
import '../../features/auth/repo/auth_interface.dart';
import '../../features/auth/repo/auth_interface_impl.dart';
import '../../features/home/controller/safety_tips_controller.dart';
import '../../features/messages/controller/chat_flow_controller.dart';
import '../../features/messages/controller/mode_select_controller.dart';
import '../../features/messages/services/message_int.dart';
import '../../features/messages/services/message_interface_impl.dart';
import '../../features/home/services/safety_services/saftey_interface.dart';
import '../../features/notification/controller/notification_controller.dart';
import '../../features/notification/services/notification_interface.dart';
import '../../features/notification/services/notification_interface_impl.dart';
import '../../features/profile/controller/edit_profile_controller.dart';
import '../../features/profile/controller/get_profile_controller.dart';
import '../../features/profile/repo/profile_interface.dart';
import '../../features/profile/repo/profile_interface_impl.dart';
import '../../features/subscription/controller/subscription_controller.dart';
import '../../features/subscription/repo/subscription_interface.dart';
import '../../features/subscription/repo/subscription_interface_impl.dart';
import '../../features/subscription/services/subscription_deep_link_service.dart';

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
  Get.lazyPut<MessageInt>(
    () => MessageInterfaceImpl(appPigeon: Get.find<AppPigeon>()),
    fenix: true,
  );
  Get.lazyPut<ModeSelectController>(
    () => ModeSelectController(messageInt: Get.find<MessageInt>()),
    fenix: true,
  );
  Get.lazyPut<ChatFlowController>(
    () => ChatFlowController(messageInt: Get.find<MessageInt>()),
    fenix: true,
  );
  Get.lazyPut<SafetyTipsController>(
    () => SafetyTipsController(safetyInterface: Get.find<SafetyInterface>()),
    fenix: true,
  );

  Get.lazyPut<SubscriptionInterface>(
    () => SubscriptionInterfaceImpl(appPigeon: Get.find<AppPigeon>()),
    fenix: true,
  );
  if (!Get.isRegistered<SubscriptionController>()) {
    Get.put<SubscriptionController>(
      SubscriptionController(repo: Get.find<SubscriptionInterface>()),
      permanent: true,
    );
  }
  if (!Get.isRegistered<SubscriptionDeepLinkService>()) {
    await Get.putAsync<SubscriptionDeepLinkService>(
      () => SubscriptionDeepLinkService().init(),
      permanent: true,
    );
  }
}
