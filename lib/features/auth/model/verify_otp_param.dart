class VerifyOtpParam {
  final String email;
  final String code;
  final String purpose;

  VerifyOtpParam({
    required this.email,
    required this.code,
    this.purpose = 'password_reset',
  });

  Map<String, dynamic> toJson() {
    return {'email': email, 'code': code, 'purpose': purpose};
  }
}
