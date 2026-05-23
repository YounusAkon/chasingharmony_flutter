class MessageResponseModel {
  final bool success;
  final String message;
  final ChatResponseData data;

  MessageResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MessageResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MessageResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ChatResponseData.fromJson(
        Map<String, dynamic>.from(
          (json['data'] is Map ? json['data'] : <String, dynamic>{}),
        ),
      ),
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

class ChatResponseData {
  final ChatSession session;
  final List<ChatMessage> messages;
  final ChatMessage? userMessage;
  final ChatMessage? assistantMessage;
  final Crisis crisis;

  ChatResponseData({
    required this.session,
    required this.messages,
    required this.userMessage,
    required this.assistantMessage,
    required this.crisis,
  });

  factory ChatResponseData.fromJson(Map<String, dynamic> json) {
    final sessionJson = _firstMap(
      json,
      const ['session', 'chatSession', 'chat', 'conversation'],
    );
    final userMessage = _optionalMessage(json['userMessage']);
    final assistantMessage = _optionalMessage(
      json['assistantMessage'] ?? json['assistantReply'] ?? json['reply'],
    );

    final messages = <ChatMessage>[
      ..._parseMessageList(json['messages']),
      ..._parseMessageList(json['chatMessages']),
      ..._parseMessageList(sessionJson['messages']),
    ];

    void addIfMissing(ChatMessage? message) {
      if (message == null) return;
      final exists = messages.any((item) => item.id == message.id);
      if (!exists) {
        messages.add(message);
      }
    }

    addIfMissing(userMessage);
    addIfMissing(assistantMessage);

    return ChatResponseData(
      session: ChatSession.fromJson(sessionJson),
      messages: messages,
      userMessage: userMessage,
      assistantMessage: assistantMessage,
      crisis: Crisis.fromJson(
        _firstMap(json, const ['crisis', 'crisisStatus', 'safety']),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session': session.toJson(),
      'messages': messages.map((message) => message.toJson()).toList(),
      'userMessage': userMessage?.toJson(),
      'assistantMessage': assistantMessage?.toJson(),
      'crisis': crisis.toJson(),
    };
  }

  static Map<String, dynamic> _firstMap(
    Map<String, dynamic> source,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = source[key];
      if (value is Map) {
        return Map<String, dynamic>.from(value);
      }
    }
    return <String, dynamic>{};
  }

  static ChatMessage? _optionalMessage(dynamic value) {
    if (value is Map) {
      final message = ChatMessage.fromJson(Map<String, dynamic>.from(value));
      if (message.content.trim().isEmpty &&
          message.id.trim().isEmpty &&
          message.role.trim().isEmpty) {
        return null;
      }
      return message;
    }
    return null;
  }

  static List<ChatMessage> _parseMessageList(dynamic value) {
    if (value is! List) return const <ChatMessage>[];
    return value
        .whereType<Map>()
        .map((item) => ChatMessage.fromJson(Map<String, dynamic>.from(item)))
        .where((message) =>
            message.content.trim().isNotEmpty ||
            message.id.trim().isNotEmpty ||
            message.role.trim().isNotEmpty)
        .toList(growable: false);
  }
}

class ChatSession {
  final String id;
  final String title;
  final DateTime lastMessageAt;
  final int messageCount;
  final bool crisisFlagged;

  ChatSession({
    required this.id,
    required this.title,
    required this.lastMessageAt,
    required this.messageCount,
    required this.crisisFlagged,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'] ?? json['_id'] ?? json['chatSessionId'] ?? '',
      title: json['title'] ?? json['name'] ?? '',
      lastMessageAt: _parseDateTime(
        json['lastMessageAt'] ?? json['updatedAt'] ?? json['createdAt'],
      ),
      messageCount: json['messageCount'] ?? json['messagesCount'] ?? 0,
      crisisFlagged: json['crisisFlagged'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lastMessageAt': lastMessageAt.toIso8601String(),
      'messageCount': messageCount,
      'crisisFlagged': crisisFlagged,
    };
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}

class ChatMessage {
  final String id;
  final String role;
  final String content;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawRole = json['role'] ?? json['senderRole'] ?? json['sender'];
    return ChatMessage(
      id: json['id'] ?? json['_id'] ?? '',
      role: rawRole?.toString() ?? '',
      content: json['content'] ?? json['message'] ?? json['text'] ?? '',
      createdAt: _parseDateTime(
        json['createdAt'] ?? json['updatedAt'] ?? json['timestamp'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}

class Crisis {
  final bool triggered;

  Crisis({
    required this.triggered,
  });

  factory Crisis.fromJson(Map<String, dynamic> json) {
    return Crisis(
      triggered: json['triggered'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'triggered': triggered,
    };
  }
}
