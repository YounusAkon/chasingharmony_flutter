import 'package:chasingharmony_fluttere/core/api_handler/failure.dart';
import 'package:chasingharmony_fluttere/core/config/google_oauth_config.dart';
import 'package:chasingharmony_fluttere/core/localization/app_language_controller.dart';
import 'package:chasingharmony_fluttere/core/network/app_language_options.dart';
import 'package:chasingharmony_fluttere/core/utils/helpers/format_response_data.dart';
import 'package:chasingharmony_fluttere/features/auth/repo/auth_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:app_pigeon/app_pigeon.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart' hide FormData, Response;
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/api_handler/success.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/helpers/typedefs.dart';
import '../model/create_new_password_model.dart';
import '../model/forget_password_model.dart';
import '../model/login_request_model.dart';
import '../model/signup_model.dart';
import '../model/verify_account_param.dart';
import '../model/verify_otp_param.dart';

final class AuthInterfaceImpl extends AuthInterface {
  static const String googleLoginCancelledMessage =
      'Google sign-in was cancelled.';
  static const String googleWebClientIdMissingMessage =
      'Google Web OAuth client id is missing or misconfigured.';
  final AuthorizedPigeon appPigeon;
  static String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static String? get _googleClientId => kIsWeb
      ? _emptyToNull(googleWebServerClientId)
      : _emptyToNull(googleIosClientId);

  // final GoogleSignIn _googleSignIn = GoogleSignIn(
  //   scopes: <String>['openid', 'email', 'profile'],
  //   clientId: _googleClientId,
  //   serverClientId: _emptyToNull(googleWebServerClientId),
  // );

  AuthInterfaceImpl(this.appPigeon);

  Stream<AuthStatus> authStream() {
    return appPigeon.authStream;
  }

  @override
  FutureRequest<Success> login(LoginRequestModel params) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.login,
          data: params.toJson(),
          options: appLanguageOptions(),
        );

        debugPrint("login response: ${response.data}");

        final body = response.data is Map
            ? Map<String, dynamic>.from(response.data as Map)
            : <String, dynamic>{};
        final loginResponse = LoginResponse.fromMap(body);
        if (Get.isRegistered<AppLanguageController>()) {
          await Get.find<AppLanguageController>().syncFromBackendValue(
            loginResponse.preferredLanguage,
          );
        }

        await appPigeon.saveNewAuth(
          saveAuthParams: SaveNewAuthParams(
            uid: loginResponse.userId,
            accessToken: loginResponse.accessToken,
            refreshToken: loginResponse.refreshToken,
            data: {
              "userId": loginResponse.userId,
              "name": loginResponse.name,
              "email": loginResponse.email,
              "role": loginResponse.role,
              "preferredLanguage": loginResponse.preferredLanguage,
            },
          ),
        );

        return Success(message: body['message'] ?? 'Login successful');
      },
    );
  }

  @override
  FutureRequest<Success> signup(SignupModel params) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.signup,
          data: params.toMap(),
          options: appLanguageOptions(),
        );

        debugPrint("Signup response: ${response.data}");

        final body = response.data;
        final signupResponse = SignupResponse.fromMap(
          body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{},
        );

        final signupUser = signupResponse.data?.user;
        final accessToken = signupResponse.data?.accessToken ?? '';
        final refreshToken = signupResponse.data?.refreshToken ?? '';
        if (signupUser != null && accessToken.isNotEmpty) {
          if (Get.isRegistered<AppLanguageController>()) {
            await Get.find<AppLanguageController>().syncFromBackendValue(
              signupUser.preferredLanguage,
            );
          }
          await appPigeon.saveNewAuth(
            saveAuthParams: SaveNewAuthParams(
              uid: signupUser.id,
              accessToken: accessToken,
              refreshToken: refreshToken,
              data: {
                "userId": signupUser.id,
                "name": signupUser.fullName.isNotEmpty
                    ? signupUser.fullName
                    : signupUser.firstName,
                "email": signupUser.email,
                "role": signupUser.role,
                "preferredLanguage": signupUser.preferredLanguage,
              },
            ),
          );
        }

        // success returned from server
        return Success(
          message: signupResponse.message.isNotEmpty
              ? signupResponse.message
              : 'Signup successful',
        );
      },
    );
  }

  @override
  FutureRequest<Success> forgetpassword(ForgetPasswordModel email) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.forgetPassword,
          data: email.toJson(),
          options: appLanguageOptions(),
        );
        debugPrint("Forget password response: ${response.data}");
        return Success(message: extractSuccessMessage(response));
      },
    );
  }

  @override
  FutureRequest<Success> resetPassword(ResetPasswordModel params) async {
    return await asyncTryCatch(
      tryFunc: () async {
        debugPrint("Reset password params: ${params.toJson()}");
        final response = await appPigeon.post(
          ApiEndpoints.createNewPassword,
          data: params.toJson(),
          options: appLanguageOptions(),
        );
        return Success(message: extractSuccessMessage(response));
      },
    );
  }

  @override
  FutureRequest<Success> verifyAccount(VerifyAccountParam params) {
    throw UnimplementedError();
  }

  @override
  FutureRequest<Success<String>> verifyCode(VerifyOtpParam param) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.verifyCode,
          data: param.toJson(),
          options: appLanguageOptions(),
        );
        final body = response.data;
        final data = body is Map && body['data'] is Map
            ? Map<String, dynamic>.from(body['data'] as Map)
            : <String, dynamic>{};

        return Success<String>(
          message: body['message'] ?? 'OTP verified',
          data: (data['resetToken'] ?? '').toString(),
        );
      },
    );
  }

  @override
  FutureRequest<Success> appleLogin() async {
    throw UnimplementedError();
  }

  @override
  FutureRequest<Success> facebookLogin() async {
    throw UnimplementedError();
  }

  @override
  FutureRequest<Success> googleLogin() async {
    if (googleWebServerClientId.trim().isEmpty ||
        (googleAndroidClientId.trim().isNotEmpty &&
            googleWebServerClientId == googleAndroidClientId)) {
      return Left(
        DataCRUDFailure(
          failure: Failure.authFailure,
          uiMessage: googleWebClientIdMissingMessage,
          fullError: googleWebClientIdMissingMessage,
        ),
      );
    }

    GoogleSignInAccount? googleUser;
    GoogleSignInAuthentication googleAuth;
    try {
      // Reset previous Google session so users can pick a different account.
      await _clearGoogleSessionSilently();
      // googleUser = await _googleSignIn.signIn();
    } on PlatformException catch (e) {
      return Left(_mapGoogleSignInPlatformException(e));
    } catch (e) {
      return Left(
        DataCRUDFailure(
          failure: Failure.unknownFailure,
          uiMessage: 'Google sign-in failed. Please try again.',
          fullError: e.toString(),
        ),
      );
    }

    if (googleUser == null) {
      return Left(
        DataCRUDFailure(
          failure: Failure.unknownFailure,
          uiMessage: googleLoginCancelledMessage,
          fullError: googleLoginCancelledMessage,
        ),
      );
    }

    try {
      googleAuth = await googleUser.authentication;
    } on PlatformException catch (e) {
      return Left(_mapGoogleSignInPlatformException(e));
    } catch (e) {
      return Left(
        DataCRUDFailure(
          failure: Failure.unknownFailure,
          uiMessage: 'Google sign-in failed. Please try again.',
          fullError: e.toString(),
        ),
      );
    }

    final idToken = googleAuth.idToken?.trim() ?? '';
    if (idToken.isEmpty) {
      return Left(
        DataCRUDFailure(
          failure: Failure.authFailure,
          uiMessage:
              'Google did not return an ID token. Check the Web OAuth client id configuration.',
          fullError: 'Missing Google ID token',
        ),
      );
    }

    final socialParams = SocialLoginRequestModel(
      provider: 'google',
      email: googleUser.email,
      fullName: _safeSocialName(
        displayName: googleUser.displayName,
        email: googleUser.email,
      ),
      idToken: idToken,
      // accessToken: googleAuth.accessToken,
      avatarUrl: googleUser.photoUrl,
      preferredLanguage: Get.find<AppLanguageController>().languageCode.value,
    );

    return await asyncTryCatch(
      tryFunc: () async {
        debugPrint("=== Google Login: calling backend ===");
        debugPrint("URL: ${ApiEndpoints.socialLogin}");
        debugPrint("Email: ${socialParams.email}");
        debugPrint("idToken (first 30): ${socialParams.idToken.substring(0, socialParams.idToken.length.clamp(0, 30))}...");

        final response = await _postWithRetryOn503(
          ApiEndpoints.socialLogin,
          data: socialParams.toJson(),
          options: appLanguageOptions(),
        );

        debugPrint("=== Google Login: backend responded ===");
        debugPrint("Google social login response: ${response.data}");

        final body = response.data is Map
            ? Map<String, dynamic>.from(response.data as Map)
            : <String, dynamic>{};
        final loginResponse = LoginResponse.fromMap(body);

        if (Get.isRegistered<AppLanguageController>()) {
          await Get.find<AppLanguageController>().syncFromBackendValue(
            loginResponse.preferredLanguage,
          );
        }

        await appPigeon.saveNewAuth(
          saveAuthParams: SaveNewAuthParams(
            uid: loginResponse.userId,
            accessToken: loginResponse.accessToken,
            refreshToken: loginResponse.refreshToken,
            data: {
              "userId": loginResponse.userId,
              "name": loginResponse.name,
              "email": loginResponse.email,
              "role": loginResponse.role,
              "preferredLanguage": loginResponse.preferredLanguage,
            },
          ),
        );

        return Success(
          message: (body['message'] ?? 'Social login completed successfully')
              .toString(),
        );
      },
    );
  }

  @override
  FutureRequest<Success> logout() async {
    return await asyncTryCatch(
      tryFunc: () async {
        // Keep GoogleSignIn cache in sync with app logout so next login can
        // show account selection instead of reusing stale account state.
        await _clearGoogleSessionSilently();
        final response = await appPigeon.post(
          ApiEndpoints.logout,
          options: appLanguageOptions(),
        );
        debugPrint('LOGOUT RESPONSE => ${response.data}');
        await appPigeon.logOut();
        return Success(message: extractSuccessMessage(response));
      },
    );
  }

  Future<void> _clearGoogleSessionSilently() async {
    try {
      // await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('Google signOut skipped: $e');
    }
  }

  String _safeSocialName({String? displayName, required String email}) {
    final cleanedDisplayName = (displayName ?? '').trim();
    if (cleanedDisplayName.isNotEmpty) return cleanedDisplayName;

    final localPart = email.split('@').first.trim();
    if (localPart.isNotEmpty) return localPart;
    return 'Google User';
  }

  Future<Response> _postWithRetryOn503(
    String path, {
    dynamic data,
    Options? options,
    int maxRetries = 3,
  }) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        return await appPigeon.post(path, data: data, options: options);
      } on DioException catch (e) {
        if (e.response?.statusCode == 503 && attempt < maxRetries) {
          debugPrint('=== Server unavailable (503), retry $attempt/$maxRetries in 5s ===');
          await Future.delayed(const Duration(seconds: 5));
          continue;
        }
        rethrow;
      }
    }
    throw StateError('unreachable');
  }

  DataCRUDFailure _mapGoogleSignInPlatformException(PlatformException error) {
    final raw = '${error.code} ${error.message ?? ''} ${error.details ?? ''}'
        .toLowerCase();

    if (raw.contains('sign_in_canceled') || raw.contains('canceled')) {
      return DataCRUDFailure(
        failure: Failure.unknownFailure,
        uiMessage: googleLoginCancelledMessage,
        fullError: error.toString(),
      );
    }

    if (raw.contains('apiexception: 10') || raw.contains('developer_error')) {
      return DataCRUDFailure(
        failure: Failure.authFailure,
        uiMessage:
            'Google sign-in configuration error (code 10). Use Web OAuth client id as serverClientId, and verify Android package + SHA-1/SHA-256.',
        fullError: error.toString(),
      );
    }

    return DataCRUDFailure(
      failure: Failure.unknownFailure,
      uiMessage: error.message?.trim().isNotEmpty == true
          ? error.message!.trim()
          : 'Google sign-in failed. Please try again.',
      fullError: error.toString(),
    );
  }
}
