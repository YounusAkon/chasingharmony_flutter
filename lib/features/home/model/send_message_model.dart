class SendMessageModel {
  const SendMessageModel({
    required this.emergencyType,
    required this.message,
    this.conversationId,
  });

  final String emergencyType;
  final String message;
  final String? conversationId;

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{
      'emergencyType': emergencyType,
      'message': message,
    };

    final id = conversationId?.trim() ?? '';
    if (id.isNotEmpty) {
      payload['conversationId'] = id;
    }

    return payload;
  }
}
