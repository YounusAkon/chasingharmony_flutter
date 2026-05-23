import 'package:chasingharmony_fluttere/features/messages/model/create_chat_request_model.dart';
import 'package:chasingharmony_fluttere/features/messages/model/message_responces_model.dart';
import 'package:chasingharmony_fluttere/features/messages/model/send_chat_message_request_model.dart';
import 'package:chasingharmony_fluttere/features/messages/model/select_mood_request_model.dart';
import 'package:chasingharmony_fluttere/features/messages/model/select_mood_responces_model.dart';
import 'package:chasingharmony_fluttere/features/messages/services/message_int.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatFlowController extends GetxController {
  ChatFlowController({required this.messageInt});

  final MessageInt messageInt;

  final RxList<ChatUiMessage> messages = <ChatUiMessage>[].obs;
  final RxBool isSubmittingMoodCheckIn = false.obs;
  final RxBool isSendingMessage = false.obs;
  final RxString error = ''.obs;

  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  String? _chatSessionId;

  bool get hasActiveConversation => (_chatSessionId ?? '').trim().isNotEmpty;

  @override
  void onClose() {
    inputController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<bool> submitMoodCheckIn({
    required String feeling,
    required int intensity,
    required List<String> triggers,
    required String triggerOther,
    required String duration,
    required String supportType,
  }) async {
    if (isSubmittingMoodCheckIn.value) return false;

    isSubmittingMoodCheckIn.value = true;
    error.value = '';

    final moodResponse = await messageInt.selectMood(
      SelectMoodRequestModel(
        feeling: feeling,
        intensity: intensity,
        triggers: triggers,
        triggerOther: triggerOther,
        duration: duration,
        supportType: supportType,
      ),
    );

    SelectMoodResponsesModel? moodCheckInResponse;
    moodResponse.fold(
      (failure) {
        error.value = failure.uiMessage;
        _showError(failure.uiMessage);
      },
      (success) {
        final moodData = success.data;
        if (moodData == null) {
          error.value = 'Mood check-in response was empty.';
          _showError(error.value);
          return;
        }
        moodCheckInResponse = moodData;
      },
    );

    final activeCheckIn = moodCheckInResponse?.data.moodCheckIn;
    if (activeCheckIn == null || activeCheckIn.id.trim().isEmpty) {
      isSubmittingMoodCheckIn.value = false;
      return false;
    }

    final createChatResponse = await messageInt.createChat(
      CreateChatRequestModel(
        moodCheckInId: activeCheckIn.id,
      ),
    );

    var isSuccess = false;
    createChatResponse.fold(
      (failure) {
        error.value = failure.uiMessage;
        _showError(failure.uiMessage);
      },
      (success) {
        final messageData = success.data;
        if (messageData == null) {
          error.value = 'Chat response was empty.';
          _showError(error.value);
          return;
        }
        error.value = '';
        _chatSessionId = _resolveSessionId(messageData);
        messages.assignAll(_mapResponseMessages(messageData));
        isSuccess = true;
        _scrollToBottom();
      },
    );

    isSubmittingMoodCheckIn.value = false;
    return isSuccess;
  }

  Future<bool> sendTypedMessage() async {
    final content = inputController.text.trim();
    if (content.isEmpty || isSendingMessage.value) return false;
    if (!hasActiveConversation) {
      _showError('Please start a chat from the mood check-in first.');
      return false;
    }

    inputController.clear();
    isSendingMessage.value = true;
    error.value = '';

    final response = await messageInt.sendNewMessage(
      SendChatMessageRequestModel(
        chatSessionId: _chatSessionId!,
        content: content,
      ),
    );

    var isSuccess = false;
    response.fold(
      (failure) {
        error.value = failure.uiMessage;
        inputController.text = content;
        inputController.selection = TextSelection.fromPosition(
          TextPosition(offset: inputController.text.length),
        );
        _showError(failure.uiMessage);
      },
      (success) {
        final messageData = success.data;
        if (messageData == null) {
          error.value = 'Chat response was empty.';
          _showError(error.value);
          return;
        }
        error.value = '';
        _chatSessionId = _resolveSessionId(messageData);
        _upsertMessages(_mapResponseMessages(messageData));
        isSuccess = true;
        _scrollToBottom();
      },
    );

    isSendingMessage.value = false;
    return isSuccess;
  }

  List<ChatUiMessage> _mapResponseMessages(MessageResponseModel response) {
    final mapped = response.data.messages
        .map(ChatUiMessage.fromApi)
        .where((message) => message.content.trim().isNotEmpty)
        .toList(growable: false);

    if (mapped.isNotEmpty) {
      return mapped;
    }

    return <ChatUiMessage>[
      if (response.data.userMessage != null)
        ChatUiMessage.fromApi(response.data.userMessage!),
      if (response.data.assistantMessage != null)
        ChatUiMessage.fromApi(response.data.assistantMessage!),
    ];
  }

  void _upsertMessages(List<ChatUiMessage> incoming) {
    for (final message in incoming) {
      final index = messages.indexWhere((item) => item.id == message.id);
      if (index == -1) {
        messages.add(message);
      } else {
        messages[index] = message;
      }
    }
  }

  String? _resolveSessionId(MessageResponseModel response) {
    final sessionId = response.data.session.id.trim();
    if (sessionId.isNotEmpty) {
      return sessionId;
    }
    return _chatSessionId;
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }
}

class ChatUiMessage {
  const ChatUiMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String role;
  final String content;
  final DateTime createdAt;

  bool get isUser => role.trim().toLowerCase() == 'user';

  factory ChatUiMessage.fromApi(ChatMessage message) {
    return ChatUiMessage(
      id: message.id.trim().isEmpty
          ? '${message.role}_${message.createdAt.microsecondsSinceEpoch}'
          : message.id,
      role: message.role,
      content: message.content,
      createdAt: message.createdAt,
    );
  }
}
