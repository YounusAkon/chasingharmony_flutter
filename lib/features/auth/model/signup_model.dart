class SignupModel {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;

  SignupModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName.trim(),
      'email': email.trim(),
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}

class SignupResponse {
  final bool success;
  final String message;
  final SignupResponseData? data;

  const SignupResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SignupResponse.fromMap(Map<String, dynamic> map) {
    final dataMap = map['data'] is Map
        ? Map<String, dynamic>.from(map['data'] as Map)
        : null;

    return SignupResponse(
      success: map['success'] == true,
      message: (map['message'] ?? '').toString(),
      data: dataMap == null ? null : SignupResponseData.fromMap(dataMap),
    );
  }
}

class SignupResponseData {
  final String accessToken;
  final String refreshToken;
  final String? expiresAt;
  final SignupUser? user;

  const SignupResponseData({
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
    this.user,
  });

  factory SignupResponseData.fromMap(Map<String, dynamic> map) {
    final userMap = map['user'] is Map
        ? Map<String, dynamic>.from(map['user'] as Map)
        : null;

    return SignupResponseData(
      accessToken: (map['accessToken'] ?? '').toString(),
      refreshToken: (map['refreshToken'] ?? '').toString(),
      expiresAt: map['expiresAt']?.toString(),
      user: userMap == null ? null : SignupUser.fromMap(userMap),
    );
  }
}

class SignupUser {
  final String id;
  final String role;
  final String username;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String preferredLanguage;
  final String avatarUrl;

  const SignupUser({
    required this.id,
    required this.role,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.preferredLanguage,
    required this.avatarUrl,
  });

  factory SignupUser.fromMap(Map<String, dynamic> map) {
    return SignupUser(
      id: (map['_id'] ?? map['id'] ?? '').toString(),
      role: (map['role'] ?? '').toString(),
      username: (map['username'] ?? '').toString(),
      firstName: (map['firstName'] ?? '').toString(),
      lastName: (map['lastName'] ?? '').toString(),
      fullName: (map['fullName'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      phoneNumber: (map['phoneNumber'] ?? '').toString(),
      preferredLanguage: (map['preferredLanguage'] ?? 'en').toString(),
      avatarUrl: (map['avatarUrl'] ?? '').toString(),
    );
  }
}
