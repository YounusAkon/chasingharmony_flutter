class CreateChatRequestModel {
  const CreateChatRequestModel({
    required this.moodCheckInId,
    required this.content,
  });

  final String moodCheckInId;
  final String content;

  Map<String, dynamic> toJson() {
    return {
      'moodCheckInId': moodCheckInId,
      'content': content,
    };
  }
}
