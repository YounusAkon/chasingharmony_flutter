class SelectMoodRequestModel {
  final String feeling;
  final int intensity;
  final List<String> triggers;
  final String triggerOther;
  final String duration;
  final String supportType;

  SelectMoodRequestModel({
    required this.feeling,
    required this.intensity,
    required this.triggers,
    required this.triggerOther,
    required this.duration,
    required this.supportType,
  });

  factory SelectMoodRequestModel.fromJson(Map<String, dynamic> json) {
    return SelectMoodRequestModel(
      feeling: json['feeling'] ?? '',
      intensity: json['intensity'] ?? 0,
      triggers: List<String>.from(json['triggers'] ?? []),
      triggerOther: json['triggerOther'] ?? '',
      duration: json['duration'] ?? '',
      supportType: json['supportType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feeling': feeling,
      'intensity': intensity,
      'triggers': triggers,
      'triggerOther': triggerOther,
      'duration': duration,
      'supportType': supportType,
    };
  }
}