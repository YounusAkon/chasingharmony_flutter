class SendChatMessageRequestModel {
  const SendChatMessageRequestModel({
    required this.chatSessionId,
    required this.content,
  });

  final String chatSessionId;
  final String content;

  Map<String, dynamic> toJson() {
    return {
      'chatSessionId': chatSessionId,
      'content': content,
    };
  }
}
