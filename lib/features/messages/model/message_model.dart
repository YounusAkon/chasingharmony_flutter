enum MessageRole { assistant, user, guidance }

class MessageModel {
  MessageModel({
    required this.id,
    required this.role,
    required this.text,
    required this.createdAt,
    this.title,
    this.isError = false,
    this.isStreaming = false,
    this.retryText,
    this.retryEmergencyType,
  });

  final String id;
  final MessageRole role;
  final String text;
  final DateTime createdAt;
  final String? title;
  final bool isError;
  final bool isStreaming;
  final String? retryText;
  final String? retryEmergencyType;

  bool get isUser => role == MessageRole.user;
  bool get isGuidance => role == MessageRole.guidance;
  bool get isTyping => isStreaming && text.trim().isEmpty;
  bool get canRetry =>
      !isStreaming && isError && (retryText?.trim().isNotEmpty ?? false);

  MessageModel copyWith({
    String? id,
    MessageRole? role,
    String? text,
    DateTime? createdAt,
    String? title,
    bool? isError,
    bool? isStreaming,
    String? retryText,
    String? retryEmergencyType,
  }) {
    return MessageModel(
      id: id ?? this.id,
      role: role ?? this.role,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      isError: isError ?? this.isError,
      isStreaming: isStreaming ?? this.isStreaming,
      retryText: retryText ?? this.retryText,
      retryEmergencyType: retryEmergencyType ?? this.retryEmergencyType,
    );
  }
}
