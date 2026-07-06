// ignore_for_file: unused_element, unused_field

import 'package:flutter/foundation.dart';

base class ApiEndpoints {
  static const String socketUrl = _RemoteServer.socketUrl;
  static const String baseUrl = _RemoteServer.baseUrl;

  /// ### post
  static const String login = _Auth.login;
  static const String logout = _Auth.logout;
  static const String socialLogin = _Auth.socialLogin;
  static const String signup = _Auth.signup;
  static const String verifyCode = _Auth.verifyCode;
  static const String forgetPassword = _Auth.forgetPassword;
  static const String createNewPassword = _Auth.resetPassword;
  static const String refreshToken = _Auth.refreshToken;
  static const String changePassword = _Auth.changePassword;

  //---------------report----------------

  /// ### post
  static const String sendReport = _Report.sendReport;

  //------------notification----------------
  static const String getAllNotifications = _Notification.getAllNotifications;
  static const String readAllNotifications = _Notification.readAllNotifications;
  static String markNotificationAsRead({required String notificationId}) =>
      _Notification.markNotificationAsRead(notificationId);
  static const String markAllAsRead = _Notification.markAllAsRead;

  //---------------------- mode -----------------------------
  static const String getAllMode = _Mode.getAllMode;
  //----------------------chat----------------

  /// ### get
  ///
  static const String createMessage = _Chat.createMessage;
  static const String sendMessage = _Chat.sendMessage;
  static const String getRecentMessages = _Chat.getRecentMessages;
  static const String getExistingChat = _Chat.getExistingChat;
  // ---------------------- USER -----------------------------
  /// ### get
  static String getuserbyId = _User.getuserbyId;
  static String updateProfile = _User.updateProfile;
  static String uploadAvatar = _User.uploadAvatar;
  static String userPreferences = _User.preferences;

  /// ### delete
  static String deleteAccount = _User.deleteAccount;

  //---------------------- subscriptions -----------------------------
  static const String subscriptionPlans = _Subscription.plans;
  static const String mySubscription = _Subscription.me;
  static const String createSubscriptionCheckout = _Subscription.checkout;
  static const String confirmSubscriptionSuccess = _Subscription.success;
  static const String cancelSubscription = _Subscription.cancel;

  //------------------------- SelectMode --------------------------
  static const String selectMood = _SelectMode.selectMood;
}

//arrow360degree@gmail.com

class _LocalHostWifi {
  static const String socketUrl = 'https://jz1svmnq-5009.inc1.devtunnels.ms';

  static const String baseUrl =
      'https://jz1svmnq-5009.inc1.devtunnels.ms/api/v1';
}

class _RemoteServer {
  static const String socketUrl = 'http://187.77.187.56:5012';
  static const String baseUrl = 'http://187.77.187.56:5012/api/v1';
}

class _Auth {
  @protected
  static const String _authRoute = '${ApiEndpoints.baseUrl}/auth';
  static const String login = '$_authRoute/login';
  static const String logout = '$_authRoute/logout';
  static const String socialLogin = '$_authRoute/social-login';
  static const String signup = '$_authRoute/signup';
  static const String forgetPassword = '$_authRoute/forgot-password';
  static const String refreshToken = '$_authRoute/refresh';
  static const String verifyCode = '$_authRoute/verify-otp';
  static const String resetPassword = '$_authRoute/reset-password';
  static const String changePassword = '$_authRoute/change-password';
}

// ---------------------- Report -----------------------------
class _Report {
  static const String _reportRoute = '${ApiEndpoints.baseUrl}/reports';
  static const String sendReport = '$_reportRoute/';
}

// ---------------------- Notification -----------------------------
class _Notification {
  static const String _notificationRoute =
      '${ApiEndpoints.baseUrl}/notifications';
  static String markNotificationAsRead(String notificationId) =>
      '$_notificationRoute/$notificationId/read/';
  static const String readAllNotifications =
      '$_notificationRoute/mark-all-as-read';
  static const String markAllAsRead = '$_notificationRoute/mark-all-as-read';
  static const String getAllNotifications = '$_notificationRoute/';
}

class _Mode {
  static const String _modeRoute = '${ApiEndpoints.baseUrl}/mood';
  static const String getAllMode = '$_modeRoute/options';
}

// ---------------------- USER -----------------------------
class _User {
  static const String _userRoute = '${ApiEndpoints.baseUrl}/users';
  static String getuserbyId = '$_userRoute/me';
  static String updateProfile = '$_userRoute/me';
  static String uploadAvatar = '$_userRoute/me/avatar';
  static String preferences = '$_userRoute/me/preferences';
  static String deleteAccount = '$_userRoute/me';
}

// ---------------------- SUBSCRIPTIONS -----------------------------
class _Subscription {
  static const String _subscriptionRoute =
      '${ApiEndpoints.baseUrl}/subscriptions';
  static const String plans = '$_subscriptionRoute/plans';
  static const String me = '$_subscriptionRoute/me';
  static const String checkout = '$_subscriptionRoute/checkout';
  static const String success = '$_subscriptionRoute/success';
  static const String cancel = '$_subscriptionRoute/cancel';
}

//-----------------------chat----------------
class _Chat {
  static const String _chatRoute = '${ApiEndpoints.baseUrl}/chat';
  static const String createMessage = '$_chatRoute/messages';
  static const String sendMessage = '$_chatRoute/messages';
  static const String getRecentMessages = '$_chatRoute/sessions';
  static const String getExistingChat = '$_chatRoute/sessions';
}

//---------------------- SelectMode -----------------------------
class _SelectMode {
  static const String _selectMoodRoute = '${ApiEndpoints.baseUrl}/mood';
  static const String selectMood = '$_selectMoodRoute/check-in';
}
