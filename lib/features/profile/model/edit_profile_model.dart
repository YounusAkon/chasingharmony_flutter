import 'dart:io';
import 'package:app_pigeon/app_pigeon.dart';

class EditProfileModel {
  final String? username;
  final String? lastName;
  final String? phoneNumber;
  final File? avatarFile;

  EditProfileModel({
    this.username,
    this.lastName,
    this.phoneNumber,
    this.avatarFile,
  });

  Map<String, dynamic> toJson() {
    final normalizedUsername = _normalize(username);
    final normalizedLastName = _normalize(lastName);
    final normalizedPhoneNumber = _normalize(phoneNumber);

    final json = <String, dynamic>{};

    if (normalizedUsername != null) {
      json['username'] = normalizedUsername;
    }
    if (normalizedLastName != null) {
      json['lastName'] = normalizedLastName;
    }
    if (normalizedPhoneNumber != null) {
      json['phoneNumber'] = normalizedPhoneNumber;
    }

    return json;
  }

  FormData toFormData() {
    final normalizedUsername = _normalize(username);
    final normalizedLastName = _normalize(lastName);
    final normalizedPhoneNumber = _normalize(phoneNumber);

    final formData = FormData();

    if (normalizedUsername != null) {
      formData.fields.add(MapEntry('username', normalizedUsername));
    }
    if (normalizedLastName != null) {
      formData.fields.add(MapEntry('lastName', normalizedLastName));
    }
    if (normalizedPhoneNumber != null) {
      formData.fields.add(MapEntry('phoneNumber', normalizedPhoneNumber));
    }

    if (avatarFile != null) {
      formData.files.add(
        MapEntry(
          'avatar',
          MultipartFile.fromFileSync(
            avatarFile!.path,
            filename: avatarFile!.path.split('/').last,
          ),
        ),
      );
    }

    return formData;
  }
}

String? _normalize(String? value) {
  if (value == null) return null;
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
