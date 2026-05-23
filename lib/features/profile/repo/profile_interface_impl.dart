import 'dart:convert';
import 'dart:io';
import 'package:app_pigeon/app_pigeon.dart';
import 'package:chasingharmony_fluttere/core/localization/app_language_controller.dart';
import 'package:chasingharmony_fluttere/core/utils/helpers/format_response_data.dart';
import 'package:chasingharmony_fluttere/features/profile/repo/profile_interface.dart';
import 'package:get/get.dart' hide FormData, Response, MultipartFile;
import '../../../core/api_handler/success.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/helpers/typedefs.dart';
import '../../../core/network/app_language_options.dart';
import '../model/chnage_password_model.dart';
import '../model/edit_profile_model.dart';
import '../model/profile_model.dart';
import '../model/review_model.dart';

final class ProfileInterfaceImpl extends ProfilInterface {
  ProfileInterfaceImpl({required this.appPigeon});
  final AppPigeon appPigeon;

  Map<String, dynamic> _asMapBody(dynamic body) {
    if (body is Map<String, dynamic>) return body;
    if (body is Map) return Map<String, dynamic>.from(body);
    if (body is String) {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    }
    throw Exception('Unexpected response format');
  }

  Map<String, dynamic> _extractProfilePayload(dynamic body) {
    final bodyMap = _asMapBody(body);
    final rawData = bodyMap['data'];

    if (rawData == null) {
      throw Exception('No data in response');
    }

    if (rawData is Map && rawData['user'] is Map) {
      return Map<String, dynamic>.from(rawData['user'] as Map);
    }

    if (rawData is Map && rawData['publicUser'] is Map) {
      return Map<String, dynamic>.from(rawData['publicUser'] as Map);
    }

    if (rawData is Map<String, dynamic>) {
      return rawData;
    }

    if (rawData is Map) {
      return Map<String, dynamic>.from(rawData);
    }

    throw Exception('Invalid profile payload');
  }

  @override
  FutureRequest<Success<ProfileModel>> getProfile(String id) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(ApiEndpoints.getuserbyId);
        final body = _asMapBody(response.data);
        final data = _extractProfilePayload(body);

        final ProfileModel profileModel = ProfileModel.fromJson(data);
        final message = body["message"]?.toString() ?? "Success";
        return Success(data: profileModel, message: message);
      },
    );
  }

  @override
  FutureRequest<Success<ProfileModel>> updateProfile(
    EditProfileModel param,
  ) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.patch(
          ApiEndpoints.updateProfile,
          data: param.toJson(),
          options: appLanguageOptions(),
        );

        final updatedData = _extractProfilePayload(response.data);
        final updatedProfile = ProfileModel.fromJson(updatedData);

        return Success(
          data: updatedProfile,
          message:
              extractSuccessMessage(response) ?? "Profile updated successfully",
        );
      },
    );
  }

  @override
  FutureRequest<Success<Avatar>> uploadAvatar(File imageFile) async {
    return await asyncTryCatch(
      tryFunc: () async {
        // Multipart uploads do NOT go through AuthorizedPigeon. Reason:
        // FormData is a one-shot stream — if the pigeon's interceptor catches
        // a 401 and retries after refresh, the FormData body is already
        // consumed, the retried request becomes empty, and (worse) a failed
        // refresh clears auth and logs the user out. We instead read the
        // current access token, attach it manually, and use a fresh Dio.
        final authorizedPigeon = Get.find<AuthorizedPigeon>();
        final auth = await authorizedPigeon.getCurrentAuthRecord();
        final accessToken = auth?.toJson()['access_token']?.toString();
        if (accessToken == null || accessToken.isEmpty) {
          throw Exception('Not authenticated');
        }

        final filename = imageFile.path.split('/').last;
        final extension = filename.contains('.')
            ? filename.split('.').last.toLowerCase()
            : 'jpg';
        final mimeType = switch (extension) {
          'png' => 'image/png',
          'webp' => 'image/webp',
          'heic' => 'image/heic',
          'gif' => 'image/gif',
          _ => 'image/jpeg',
        };

        final formData = FormData.fromMap({
          'avatar': await MultipartFile.fromFile(
            imageFile.path,
            filename: filename,
            contentType: DioMediaType.parse(mimeType),
          ),
        });

        final headers = <String, dynamic>{
          'Authorization': 'Bearer $accessToken',
        };
        final languageHeaders = appLanguageOptions()?.headers;
        if (languageHeaders != null) headers.addAll(languageHeaders);

        final uploadDio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 60),
            receiveTimeout: const Duration(seconds: 60),
            sendTimeout: const Duration(seconds: 60),
            validateStatus: (status) => status != null && status < 500,
          ),
        );

        final response = await uploadDio.post(
          ApiEndpoints.uploadAvatar,
          data: formData,
          options: Options(headers: headers),
        );

        if (response.statusCode == null || response.statusCode! >= 400) {
          final body = response.data;
          final message = body is Map
              ? (body['message']?.toString() ?? 'Upload failed')
              : 'Upload failed (status ${response.statusCode})';
          throw Exception(message);
        }

        final body = _asMapBody(response.data);
        final rawData = body['data'];
        Avatar parsedAvatar = Avatar();
        if (rawData is Map && rawData['avatar'] is Map) {
          parsedAvatar = Avatar.fromJson(
            Map<String, dynamic>.from(rawData['avatar'] as Map),
          );
        }

        return Success(
          data: parsedAvatar,
          message: body['message']?.toString() ?? 'Avatar uploaded successfully',
        );
      },
    );
  }

  @override
  FutureRequest<Success> changePassword(ChangePasswordModel param) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.changePassword,
          data: param.toJson(),
          options: appLanguageOptions(),
        );
        final body = _asMapBody(response.data);
        final rawData = body['data'];

        if (rawData is Map) {
          final data = Map<String, dynamic>.from(rawData);
          final userData = data['user'] is Map
              ? Map<String, dynamic>.from(data['user'] as Map)
              : const <String, dynamic>{};
          final accessToken = data['accessToken']?.toString() ?? '';
          final refreshToken = data['refreshToken']?.toString() ?? '';
          final userId =
              userData['_id']?.toString() ??
              userData['id']?.toString() ??
              '';

          if (userId.isNotEmpty &&
              accessToken.isNotEmpty &&
              refreshToken.isNotEmpty &&
              Get.isRegistered<AuthorizedPigeon>()) {
            final preferredLanguage =
                userData['preferredLanguage']?.toString() ??
                userData['language']?.toString();

            if (preferredLanguage != null &&
                preferredLanguage.trim().isNotEmpty &&
                Get.isRegistered<AppLanguageController>()) {
              await Get.find<AppLanguageController>().syncFromBackendValue(
                preferredLanguage,
              );
            }

            await Get.find<AuthorizedPigeon>().saveNewAuth(
              saveAuthParams: SaveNewAuthParams(
                uid: userId,
                accessToken: accessToken,
                refreshToken: refreshToken,
                data: {
                  'userId': userId,
                  'name': userData['fullName']?.toString() ?? '',
                  'email': userData['email']?.toString() ?? '',
                  'role': userData['role']?.toString() ?? 'user',
                  'preferredLanguage': preferredLanguage,
                },
              ),
            );
          }
        }

        return Success(
          data: null,
          message:
              extractSuccessMessage(response) ??
              "Password changed successfully",
        );
      },
    );
  }

}
