class SafetyTipModel {
  const SafetyTipModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.category,
    this.categorySlug = '',
    required this.summary,
    required this.estimatedReadMinutes,
    required this.thumbnailUrl,
    required this.coverImageUrl,
    required this.tags,
    required this.featured,
    this.contentSections = const <SafetyTipContentSection>[],
    this.doList = const <String>[],
    this.dontList = const <String>[],
    this.relatedTips = const <SafetyTipModel>[],
    this.status = '',
    this.language = '',
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String slug;
  final String title;
  final String category;
  final String categorySlug;
  final String summary;
  final int estimatedReadMinutes;
  final String thumbnailUrl;
  final String coverImageUrl;
  final List<String> tags;
  final bool featured;
  final List<SafetyTipContentSection> contentSections;
  final List<String> doList;
  final List<String> dontList;
  final List<SafetyTipModel> relatedTips;
  final String status;
  final String language;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory SafetyTipModel.fromJson(Map<String, dynamic> json) {
    final sections =
        (json['contentSections'] is List
                ? json['contentSections'] as List
                : const [])
            .whereType<Map>()
            .map(
              (e) => SafetyTipContentSection.fromJson(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList();

    final related = (json['relatedTips'] is List
            ? json['relatedTips'] as List
            : const [])
        .whereType<Map>()
        .map((e) => SafetyTipModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    final category = _asString(json['category']) ?? '';
    final categorySlug = _asString(json['categorySlug']) ?? '';

    return SafetyTipModel(
      id: _asString(json['id']) ?? '',
      slug: _asString(json['slug']) ?? '',
      title: _asString(json['title']) ?? '',
      category: category.isNotEmpty ? category : categorySlug,
      categorySlug: categorySlug,
      summary: _asString(json['summary']) ?? '',
      estimatedReadMinutes: _asInt(json['estimatedReadMinutes']) ?? 0,
      thumbnailUrl: _asString(json['thumbnailUrl']) ?? '',
      coverImageUrl: _asString(json['coverImageUrl']) ?? '',
      tags: (json['tags'] is List ? json['tags'] as List : const [])
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList(),
      featured: _asBool(json['featured']) ?? false,
      contentSections: sections,
      doList: (json['doList'] is List ? json['doList'] as List : const [])
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList(),
      dontList: (json['dontList'] is List ? json['dontList'] as List : const [])
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList(),
      relatedTips: related,
      status: _asString(json['status']) ?? '',
      language: _asString(json['language']) ?? '',
      createdAt: _asDateTime(json['createdAt']),
      updatedAt: _asDateTime(json['updatedAt']),
    );
  }

  String get displayImageUrl {
    if (thumbnailUrl.trim().isNotEmpty) return thumbnailUrl;
    return coverImageUrl;
  }
}

class SafetyTipContentSection {
  const SafetyTipContentSection({required this.heading, required this.body});

  final String heading;
  final String body;

  factory SafetyTipContentSection.fromJson(Map<String, dynamic> json) {
    return SafetyTipContentSection(
      heading: _asString(json['heading']) ?? '',
      body: _asString(json['body']) ?? '',
    );
  }
}

String? _asString(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

bool? _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final lower = value.trim().toLowerCase();
    if (lower == 'true' || lower == '1') return true;
    if (lower == 'false' || lower == '0') return false;
  }
  return null;
}

DateTime? _asDateTime(dynamic value) {
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}
