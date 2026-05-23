class CreateMessageModel {
  final String moodCheckInId;
  final String content;

  CreateMessageModel({
    required this.moodCheckInId,
    required this.content,
  });

  factory CreateMessageModel.fromJson(Map<String, dynamic> json) {
    return CreateMessageModel(
      moodCheckInId: json['moodCheckInId'] ?? '',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'moodCheckInId': moodCheckInId,
      'content': content,
    };
  }
}