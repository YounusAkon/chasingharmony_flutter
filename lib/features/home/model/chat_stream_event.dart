import 'dart:convert';

import 'package:chasingharmony_fluttere/features/home/model/message_responces_model.dart';
enum ChatStreamEventType { meta, delta, done, error, unknown }

class ChatStreamEvent {
  const ChatStreamEvent({
    required this.type,
    required this.raw,
    this.text = '',
    this.message = '',
    this.conversationId = '',
    this.emergencyType = '',
    this.language = '',
    this.userMessage,
    this.assistantMessage,
    this.conversation,
    this.degraded = false,
  });

  final ChatStreamEventType type;
  final Map<String, dynamic> raw;
  final String text;
  final String message;
  final String conversationId;
  final String emergencyType;
  final String language;
  final MessageChatItemModel? userMessage;
  final MessageChatItemModel? assistantMessage;
  final MessageConversationModel? conversation;
  final bool degraded;

  factory ChatStreamEvent.fromSse({
    required String event,
    required String data,
  }) {
    final decoded = jsonDecode(data);
    final raw = decoded is Map
        ? Map<String, dynamic>.from(decoded)
        : <String, dynamic>{'value': decoded};
    final type = _typeFor(event);

    return ChatStreamEvent(
      type: type,
      raw: raw,
      text: _asString(raw['text']) ?? '',
      message: _asString(raw['message']) ?? '',
      conversationId: _asString(raw['conversationId']) ?? '',
      emergencyType: _asString(raw['emergencyType']) ?? '',
      language: _asString(raw['language']) ?? '',
      userMessage: raw['userMessage'] is Map
          ? MessageChatItemModel.fromJson(
              Map<String, dynamic>.from(raw['userMessage'] as Map),
            )
          : null,
      assistantMessage: raw['assistantMessage'] is Map
          ? MessageChatItemModel.fromJson(
              Map<String, dynamic>.from(raw['assistantMessage'] as Map),
            )
          : null,
      conversation: raw['conversation'] is Map
          ? MessageConversationModel.fromJson(
              Map<String, dynamic>.from(raw['conversation'] as Map),
            )
          : null,
      degraded: _asBool(raw['degraded']) ?? false,
    );
  }

  static ChatStreamEventType _typeFor(String event) {
    switch (event.trim()) {
      case 'meta':
        return ChatStreamEventType.meta;
      case 'delta':
        return ChatStreamEventType.delta;
      case 'done':
        return ChatStreamEventType.done;
      case 'error':
        return ChatStreamEventType.error;
      default:
        return ChatStreamEventType.unknown;
    }
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
