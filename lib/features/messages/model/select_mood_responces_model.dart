class SelectMoodResponsesModel {
  final bool success;
  final String message;
  final MoodData data;

  SelectMoodResponsesModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SelectMoodResponsesModel.fromJson(Map<String, dynamic> json) {
    return SelectMoodResponsesModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: MoodData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class MoodData {
  final MoodCheckIn moodCheckIn;

  MoodData({
    required this.moodCheckIn,
  });

  factory MoodData.fromJson(Map<String, dynamic> json) {
    return MoodData(
      moodCheckIn: MoodCheckIn.fromJson(json['moodCheckIn'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'moodCheckIn': moodCheckIn.toJson(),
    };
  }
}

class MoodCheckIn {
  final String user;
  final String? chatSession;
  final String feeling;
  final int intensity;
  final List<String> triggers;
  final String triggerOther;
  final String duration;
  final String supportType;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  MoodCheckIn({
    required this.user,
    this.chatSession,
    required this.feeling,
    required this.intensity,
    required this.triggers,
    required this.triggerOther,
    required this.duration,
    required this.supportType,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory MoodCheckIn.fromJson(Map<String, dynamic> json) {
    return MoodCheckIn(
      user: json['user'] ?? '',
      chatSession: json['chatSession'],
      feeling: json['feeling'] ?? '',
      intensity: json['intensity'] ?? 0,
      triggers: List<String>.from(json['triggers'] ?? []),
      triggerOther: json['triggerOther'] ?? '',
      duration: json['duration'] ?? '',
      supportType: json['supportType'] ?? '',
      id: json['_id'] ?? '',
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'chatSession': chatSession,
      'feeling': feeling,
      'intensity': intensity,
      'triggers': triggers,
      'triggerOther': triggerOther,
      'duration': duration,
      'supportType': supportType,
      '_id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}
