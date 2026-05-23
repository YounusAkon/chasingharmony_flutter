class ChangePasswordModel {
  String? currentPassword;
  String? newPassword;
  String? confirmPassword;

  ChangePasswordModel({
    this.currentPassword,
    this.newPassword,
    this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }
}
