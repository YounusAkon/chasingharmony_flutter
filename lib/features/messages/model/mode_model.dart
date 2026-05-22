class ModeModel {
  const ModeModel({
    required this.feelings,
    required this.triggers,
    required this.durations,
    required this.supportTypes,
    required this.intensity,
  });

  final List<String> feelings;
  final List<String> triggers;
  final List<String> durations;
  final List<String> supportTypes;
  final ModeIntensityModel intensity;

  factory ModeModel.fromJson(Map<String, dynamic> json) {
    return ModeModel(
      feelings: _parseStringList(json['feelings']),
      triggers: _parseStringList(json['triggers']),
      durations: _parseStringList(json['durations']),
      supportTypes: _parseStringList(json['supportTypes']),
      intensity: ModeIntensityModel.fromJson(
        json['intensity'] is Map<String, dynamic>
            ? json['intensity'] as Map<String, dynamic>
            : json['intensity'] is Map
            ? Map<String, dynamic>.from(json['intensity'] as Map)
            : const <String, dynamic>{},
      ),
    );
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is! List) return const <String>[];

    return value
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }
}

class ModeIntensityModel {
  const ModeIntensityModel({
    required this.min,
    required this.max,
  });

  final int min;
  final int max;

  factory ModeIntensityModel.fromJson(Map<String, dynamic> json) {
    return ModeIntensityModel(
      min: _parseInt(json['min'], fallback: 1),
      max: _parseInt(json['max'], fallback: 10),
    );
  }

  static int _parseInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
