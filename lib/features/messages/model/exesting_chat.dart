import 'package:chasingharmony_fluttere/features/messages/model/message_responces_model.dart';

class ExestingChat {
  final String sessionId;
  final String content;
  final List<ChatMessage> messages;

  ExestingChat({
    required this.sessionId,
    required this.content,
    required this.messages,
  });
}