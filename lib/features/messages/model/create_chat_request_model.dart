class CreateChatRequestModel {
  const CreateChatRequestModel({
    required this.moodCheckInId,
  });

  final String moodCheckInId;

  Map<String, dynamic> toJson() {
    return {
      'moodCheckInId': moodCheckInId,
    };
  }
}
