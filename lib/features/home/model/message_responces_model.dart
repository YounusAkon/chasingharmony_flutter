class MessageResponcesModel {
  const MessageResponcesModel({
    required this.success,
    required this.message,
    this.data,
  });

  final bool success;
  final String message;
  final MessageResponseData? data;

  factory MessageResponcesModel.fromJson(Map<String, dynamic> json) {
    return MessageResponcesModel(
      success: _asBool(json['success']) ?? true,
      message: _asString(json['message']) ?? 'Success',
      data: json['data'] is Map
          ? MessageResponseData.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            )
          : null,
    );
  }
}

class MessageResponseData {
  const MessageResponseData({
    this.conversation,
    this.userMessage,
    this.assistantMessage,
    this.aiSource,
  });

  final MessageConversationModel? conversation;
  final MessageChatItemModel? userMessage;
  final MessageChatItemModel? assistantMessage;
  final MessageAiSourceModel? aiSource;

  factory MessageResponseData.fromJson(Map<String, dynamic> json) {
    return MessageResponseData(
      conversation: json['conversation'] is Map
          ? MessageConversationModel.fromJson(
              Map<String, dynamic>.from(json['conversation'] as Map),
            )
          : null,
      userMessage: json['userMessage'] is Map
          ? MessageChatItemModel.fromJson(
              Map<String, dynamic>.from(json['userMessage'] as Map),
            )
          : null,
      assistantMessage: json['assistantMessage'] is Map
          ? MessageChatItemModel.fromJson(
              Map<String, dynamic>.from(json['assistantMessage'] as Map),
            )
          : null,
      aiSource: json['aiSource'] is Map
          ? MessageAiSourceModel.fromJson(
              Map<String, dynamic>.from(json['aiSource'] as Map),
            )
          : null,
    );
  }
}

class MessageConversationModel {
  const MessageConversationModel({
    required this.id,
    required this.title,
    required this.userId,
    required this.emergencyType,
    this.createdAt,
    this.updatedAt,
    this.messages = const <MessageChatItemModel>[],
  });

  final String id;
  final String title;
  final String userId;
  final String emergencyType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<MessageChatItemModel> messages;

  factory MessageConversationModel.fromJson(Map<String, dynamic> json) {
    final parsedMessages =
        (json['messages'] is List ? json['messages'] as List : const [])
            .whereType<Map>()
            .map(
              (e) =>
                  MessageChatItemModel.fromJson(Map<String, dynamic>.from(e)),
            )
            .toList();

    parsedMessages.sort((a, b) {
      final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return aTime.compareTo(bTime);
    });

    return MessageConversationModel(
      id: _asString(json['id']) ?? '',
      title: _asString(json['title']) ?? '',
      userId: _asString(json['userId']) ?? '',
      emergencyType: _asString(json['emergencyType']) ?? '',
      createdAt: _asDateTime(json['createdAt']),
      updatedAt: _asDateTime(json['updatedAt']),
      messages: parsedMessages,
    );
  }
}

class MessageChatItemModel {
  const MessageChatItemModel({
    required this.id,
    required this.role,
    required this.content,
    this.createdAt,
  });

  final String id;
  final String role;
  final String content;
  final DateTime? createdAt;

  factory MessageChatItemModel.fromJson(Map<String, dynamic> json) {
    return MessageChatItemModel(
      id: _asString(json['id']) ?? '',
      role: _asString(json['role']) ?? '',
      content: _asString(json['content']) ?? '',
      createdAt: _asDateTime(json['createdAt']),
    );
  }
}

class MessageAiSourceModel {
  const MessageAiSourceModel({required this.baseUrl, required this.docsUrl});

  final String baseUrl;
  final String docsUrl;

  factory MessageAiSourceModel.fromJson(Map<String, dynamic> json) {
    return MessageAiSourceModel(
      baseUrl: _asString(json['baseUrl']) ?? '',
      docsUrl: _asString(json['docsUrl']) ?? '',
    );
  }
}

String? _asString(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

bool? _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final normalized = value.toLowerCase().trim();
    if (normalized == 'true' || normalized == '1') return true;
    if (normalized == 'false' || normalized == '0') return false;
  }
  return null;
}

DateTime? _asDateTime(dynamic value) {
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}
