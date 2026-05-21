class EditProfileModel {
  final String? fullName;

  EditProfileModel({this.fullName});

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    final normalizedFullName = _normalize(fullName);
    if (normalizedFullName != null) {
      json['fullName'] = normalizedFullName;
    }
    return json;
  }
}

String? _normalize(String? value) {
  if (value == null) return null;
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
