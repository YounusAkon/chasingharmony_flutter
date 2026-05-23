import 'dart:async';
import 'package:app_pigeon/app_pigeon.dart';
import 'package:chasingharmony_fluttere/core/constants/api_endpoints.dart';
import 'package:chasingharmony_fluttere/core/helpers/auth_role.dart';
import 'package:chasingharmony_fluttere/features/app_ground.dart';
import 'package:chasingharmony_fluttere/features/auth/controller/login_controller.dart';
import 'package:chasingharmony_fluttere/features/onbording/onboarding1.dart';
import 'package:chasingharmony_fluttere/features/profile/controller/get_profile_controller.dart';
import 'package:chasingharmony_fluttere/features/messages/controller/chat_flow_controller.dart';
import 'package:chasingharmony_fluttere/features/messages/controller/mode_select_controller.dart';
import 'package:chasingharmony_fluttere/features/profile/controller/edit_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';


class AppManager extends GetxController {
  AuthStatus _authStatus = AuthLoading();
  AuthStatus get currentAuthStatus => _authStatus;
  Debouncer authDebouncer = Debouncer(delay: const Duration(milliseconds: 100));
  String? _lastInitializedUserId;
  String? _socketInitializedUserId;
  String? _lastJoinedRoomsUserId;
  bool _isInitializingAuthenticatedUser = false;
  String? _initializingUserId;

  /// Socket connection status
  final RxBool socketConnected = false.obs;

  StreamSubscription<dynamic>? _socketConnectSub;
  StreamSubscription<dynamic>? _socketDisconnectSub;
  StreamSubscription<dynamic>? _socketErrorSub;
  StreamSubscription<dynamic>? _authSub;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  // listen to auth change
  void _init() async {
    debugPrint("AppManager: Initializing...");

    // Start listening to the auth status changes
    _authSub?.cancel();
    _authSub = Get.find<AuthorizedPigeon>().authStream.listen((authStatus) {
      _decideRoute(authStatus);
    });
  }

  void _decideRoute(AuthStatus? authStatus) async {
    if (authStatus == null) return;

    if (authStatus is UnAuthenticated) {
      _authStatus = authStatus;
      _lastInitializedUserId = null;
      _socketInitializedUserId = null;
      _lastJoinedRoomsUserId = null;
      _isInitializingAuthenticatedUser = false;
      _initializingUserId = null;
      if (Get.isRegistered<LoginController>()) {
        Get.delete<LoginController>(force: true);
      }
      if (Get.isRegistered<ChatFlowController>()) {
        Get.delete<ChatFlowController>(force: true);
      }
      if (Get.isRegistered<ProfileController>()) {
        Get.delete<ProfileController>(force: true);
      }
      if (Get.isRegistered<ProfileEditController>()) {
        Get.delete<ProfileEditController>(force: true);
      }
      if (Get.isRegistered<ModeSelectController>()) {
        Get.delete<ModeSelectController>(force: true);
      }

      final currentRoute = Get.currentRoute;
      if (currentRoute != '/Onboarding1Screen' &&
          currentRoute != '/LoginScreen' &&
          currentRoute != '/SignupScreen') {
        debugPrint("AppManager: Navigating to Onboarding (UnAuthenticated)");
        Get.offAll(() => Onboarding1Screen());
      }
    } else if (authStatus is Authenticated) {
      final previousStatus = _authStatus;
      final userId = authStatus.auth.userId;
      final isInitializingSameUser =
          _isInitializingAuthenticatedUser && _initializingUserId == userId;
      final isAlreadyInitialized = _lastInitializedUserId == userId;
      final isSameUserRefreshUpdate =
          previousStatus is Authenticated &&
          previousStatus.auth.userId == userId &&
          _lastInitializedUserId == userId;

      _authStatus = authStatus;

      // Token refresh emits Authenticated too; skip heavy re-init for same user.
      if (!isSameUserRefreshUpdate &&
          !isAlreadyInitialized &&
          !isInitializingSameUser) {
        _isInitializingAuthenticatedUser = true;
        _initializingUserId = userId;
        try {
          debugPrint("AppManager: Initializing user session for $userId");
          await _initializeControllers(userId: userId);
          _lastInitializedUserId = userId;

          if (Get.isRegistered<ProfileController>()) {
            Get.delete<ProfileController>();
          }
          Get.put(ProfileController());

          // Check if we are already on AppGround
          if (Get.currentRoute != '/AppGround') {
            debugPrint("AppManager: Navigating to AppGround (Authenticated)");
            Get.offAll(() => AppGround());
          }
        } finally {
          _isInitializingAuthenticatedUser = false;
          _initializingUserId = null;
        }
      } else {
        // Even if already initialized, ensure we are on the right screen if needed
        if (Get.currentRoute == '/' || Get.currentRoute == '/SplashView') {
          debugPrint("AppManager: Redirecting from Splash to AppGround");
          Get.offAll(() => AppGround());
        }
      }
    }
    update();
  }

  // initiate controllers on auth change[Authenticated]
  Future<void> _initializeControllers({required String userId}) async {
    if (userId.isEmpty) return;

    if (_socketInitializedUserId != userId) {
      await Get.find<AppPigeon>().socketInit(
        SocketConnetParamX(
          token: null,
          socketUrl: ApiEndpoints.socketUrl,
          joinId: userId,
        ),
      );
      _socketInitializedUserId = userId;
    }

    _bindSocketStatus();
    _joinRealtimeRooms(userId, force: true);
  }

  void _joinRealtimeRooms(String userId, {bool force = false}) {
    if (userId.isEmpty) return;
    if (!force && _lastJoinedRoomsUserId == userId) return;

    final appPigeon = Get.find<AppPigeon>();
    appPigeon.emit("joinChatRoom", userId);
    appPigeon.emit("joinNotificationRoom", userId);
    appPigeon.emit("joinNotification", userId);
    _lastJoinedRoomsUserId = userId;
  }

  void _bindSocketStatus() {
    _socketConnectSub?.cancel();
    _socketDisconnectSub?.cancel();
    _socketErrorSub?.cancel();

    final appPigeon = Get.find<AppPigeon>();
    _socketConnectSub = appPigeon.listen("connect").listen((_) {
      socketConnected.value = true;
      final authStatus = currentAuthStatus;
      if (authStatus is Authenticated) {
        final userId = authStatus.auth.userId;
        if (userId.isNotEmpty) {
          // Rejoin rooms on every reconnect to keep realtime reliable.
          _joinRealtimeRooms(userId, force: true);
        }
      }
    });
    _socketDisconnectSub = appPigeon.listen("disconnect").listen((_) {
      socketConnected.value = false;
    });
    _socketErrorSub = appPigeon.listen("connect_error").listen((_) {
      socketConnected.value = false;
    });
  }

  @override
  void onClose() {
    _socketConnectSub?.cancel();
    _socketDisconnectSub?.cancel();
    _socketErrorSub?.cancel();
    super.onClose();
  }
}
// class AppManager extends GetxController {
//   AuthStatus _authStatus = AuthLoading();
//   AuthStatus get currentAuthStatus => _authStatus;

//   final Debouncer authDebouncer =
//       Debouncer(delay: const Duration(milliseconds: 100));

//   @override
//   void onInit() {
//     super.onInit();
//     _init();
//   }

//   Future<void> _init() async {
//     debugPrint("AppManager initialized");

//     final initialAuthStatus =
//         await Get.find<AppPigeon>().currentAuth();

//     // ✅ WAIT until UI is ready
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _decideRoute(initialAuthStatus);
//     });
//   }

//   Future<void> _decideRoute(AuthStatus? authStatus) async {
//     if (authStatus is UnAuthenticated) {
//       _authStatus = authStatus;

//       Get.offAll(() => SignupScreen());

//     } else if (authStatus is Authenticated) {
//       _authStatus = authStatus;

//       await _initializeControllers();

//       if (Get.isRegistered<ProfileController>()) {
//         Get.delete<ProfileController>();
//       }

//       Get.put(ProfileController());

//       Get.offAll(() => AppGround());
//     }

//     update();
//   }

//   Future<void> _initializeControllers() async {
//     if (_authStatus is! Authenticated) return;

//     final userId =
//         (_authStatus as Authenticated).auth.userId;

//     if (userId.isEmpty) return;

//     await Get.find<AppPigeon>().socketInit(
//       SocketConnetParamX(
//         token: null,
//         socketUrl: ApiEndpoints.socketUrl,
//         joinId: userId,
//       ),
//     );

//     Get.find<AppPigeon>().emit("join", userId);
//   }
// }
