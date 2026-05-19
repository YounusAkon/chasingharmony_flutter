import 'dart:convert';
import 'package:app_pigeon/app_pigeon.dart';
import 'package:chasingharmony_fluttere/core/utils/helpers/format_response_data.dart';
import 'package:chasingharmony_fluttere/features/profile/repo/profile_interface.dart';
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
          data: param.toFormData(),
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
  FutureRequest<Success> changePassword(ChangePasswordModel param) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.patch(
          ApiEndpoints.changePassword,
          data: param.toJson(),
          options: appLanguageOptions(),
        );

        return Success(
          data: null,
          message:
              extractSuccessMessage(response) ??
              "Password changed successfully",
        );
      },
    );
  }

  @override
  FutureRequest<Success<void>> addReview(ReviewModel review) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.addReview,
          data: review.toJson(),
          options: appLanguageOptions(),
        );

        final body = _asMapBody(response.data);
        final message =
            body["message"]?.toString() ?? "Review added successfully";

        return Success(data: null, message: message);
      },
    );
  }
}
