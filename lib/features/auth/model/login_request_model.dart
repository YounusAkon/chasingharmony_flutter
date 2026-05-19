class LoginRequestModel {
  final String email;
  final String password;
  final String preferredLanguage;

  LoginRequestModel({
    required this.email,
    required this.password,
    this.preferredLanguage = 'en',
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'preferredLanguage': preferredLanguage,
  };
}

class SocialLoginRequestModel {
  final String provider;
  final String email;
  final String fullName;
  final String idToken;
  final String? accessToken;
  final String? avatarUrl;
  final String preferredLanguage;

  SocialLoginRequestModel({
    required this.provider,
    required this.email,
    required this.fullName,
    required this.idToken,
    this.accessToken,
    this.avatarUrl,
    this.preferredLanguage = 'en',
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'provider': provider.trim(),
      'email': email.trim(),
      'fullName': fullName.trim(),
      'idToken': idToken.trim(),
      'id_token': idToken.trim(),
      'preferredLanguage': preferredLanguage.trim(),
    };

    final cleanedAccessToken = accessToken?.trim();
    if (cleanedAccessToken != null && cleanedAccessToken.isNotEmpty) {
      map['accessToken'] = cleanedAccessToken;
      map['access_token'] = cleanedAccessToken;
    }

    final cleanedAvatarUrl = avatarUrl?.trim();
    if (cleanedAvatarUrl != null && cleanedAvatarUrl.isNotEmpty) {
      map['avatarUrl'] = cleanedAvatarUrl;
    }

    return map;
  }
}

class LoginResponse {
  final String userId;
  final String accessToken;
  final String refreshToken;
  final String name;
  final String email;
  final String role;
  final String preferredLanguage;

  LoginResponse({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.name,
    required this.email,
    required this.role,
    required this.preferredLanguage,
  });

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    final data = map['data'] is Map
        ? Map<String, dynamic>.from(map['data'] as Map)
        : <String, dynamic>{};
    final user = data['user'] is Map
        ? Map<String, dynamic>.from(data['user'] as Map)
        : data;

    return LoginResponse(
      userId: (user['_id'] ?? user['id'] ?? '').toString(),
      accessToken: (data['accessToken'] ?? '').toString(),
      refreshToken: (data['refreshToken'] ?? '').toString(),
      name:
          (user['fullName'] ??
                  user['name'] ??
                  user['username'] ??
                  user['firstName'] ??
                  '')
              .toString(),
      email: (user['email'] ?? '').toString(),
      role: (user['role'] ?? '').toString(),
      preferredLanguage: (user['preferredLanguage'] ?? 'en').toString(),
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String username;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.role,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      role: map['role'] ?? '',
    );
  }
}
