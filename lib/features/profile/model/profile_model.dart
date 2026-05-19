class ProfileModel {
  Avatar? avatar;
  String? sId;
  String? username;
  String? firstName;
  String? lastName;
  String? fullName;
  String? name;
  String? email;
  bool? notifications;
  String? language;
  String? role;
  bool? isEmailVerified;
  String? createdAt;
  String? updatedAt;
  String? phone;
  String? address;
  DateTime? dob;

  ProfileModel({
    this.avatar,
    this.sId,
    this.username,
    this.firstName,
    this.lastName,
    this.fullName,
    this.name,
    this.email,
    this.notifications,
    this.language,
    this.role,
    this.isEmailVerified,
    this.createdAt,
    this.updatedAt,
    this.phone,
    this.address,
    this.dob,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final avatarJson = json['avatar'];
    Avatar? parsedAvatar;
    if (avatarJson is Map<String, dynamic>) {
      parsedAvatar = Avatar.fromJson(avatarJson);
    } else if (json['avatarUrl'] != null) {
      parsedAvatar = Avatar(url: json['avatarUrl'].toString());
    }

    final username = _asString(json['username']) ?? _asString(json['userName']);
    final firstName = _asString(json['firstName']);
    final lastName = _asString(json['lastName']);
    final fullName = _asString(json['fullName']);
    final explicitName = _asString(json['name']);
    final nameFromParts = [
      if (firstName != null && firstName.trim().isNotEmpty) firstName.trim(),
      if (lastName != null && lastName.trim().isNotEmpty) lastName.trim(),
    ].join(' ');
    final duplicateComposedName =
        fullName != null &&
        username != null &&
        lastName != null &&
        username.contains(' ') &&
        fullName.toLowerCase() ==
            '${username.toLowerCase()} ${lastName.toLowerCase()}';

    final parsedName =
        explicitName ??
        (duplicateComposedName ? username : null) ??
        fullName ??
        username ??
        (nameFromParts.isNotEmpty ? nameFromParts : null);

    return ProfileModel(
      avatar: parsedAvatar,
      sId: _asString(json['_id']) ?? _asString(json['id']),
      username: username,
      firstName: firstName,
      lastName: lastName,
      fullName: fullName,
      name: parsedName,
      email: _asString(json['email']),
      notifications:
          _asBool(json['notifications']) ??
          _asBool(json['notificationsEnabled']),
      language:
          _asString(json['language']) ?? _asString(json['preferredLanguage']),
      role: _asString(json['role']),
      isEmailVerified: _asBool(json['isEmailVerified']),
      createdAt: _asString(json['createdAt']),
      updatedAt: _asString(json['updatedAt']),
      phone: _asString(json['phone']) ?? _asString(json['phoneNumber']),
      address: _asString(json['address']),
      dob: _asDateTime(json['dob']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar?.toJson(),
      'avatarUrl': avatar?.url,
      '_id': sId,
      'id': sId,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'name': name,
      'email': email,
      'notifications': notifications,
      'notificationsEnabled': notifications,
      'language': language,
      'preferredLanguage': language,
      'role': role,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'phone': phone,
      'phoneNumber': phone,
      'address': address,
      'dob': dob?.toIso8601String(),
    };
  }
}

class Avatar {
  String? publicId;
  String? url;

  Avatar({this.publicId, this.url});

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      publicId: _asString(json['public_id']) ?? _asString(json['publicId']),
      url: _asString(json['url']) ?? _asString(json['avatarUrl']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'public_id': publicId, 'url': url, 'avatarUrl': url};
  }
}

String? _asString(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

bool? _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'true' || normalized == '1') return true;
    if (normalized == 'false' || normalized == '0') return false;
  }
  return null;
}

DateTime? _asDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}
