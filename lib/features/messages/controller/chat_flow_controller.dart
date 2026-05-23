import 'dart:async';

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
  final RxBool isAiTyping = false.obs;
  final RxString streamingAiText = ''.obs;
  final RxString error = ''.obs;

  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  Timer? _streamTimer;
  static const Duration _streamTickDuration = Duration(milliseconds: 18);
  static const int _streamCharsPerTick = 2;

  String? _chatSessionId;

  bool get hasActiveConversation => (_chatSessionId ?? '').trim().isNotEmpty;

  // @override
  // void onClose() {
  //   inputController.dispose();
  //   scrollController.dispose();
  //   super.onClose();
  // }

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

    debugPrint('[submitMoodCheckIn] Submitting mood selection: feeling=$feeling, intensity=$intensity...');
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
        debugPrint('[submitMoodCheckIn] selectMood API failed: ${failure.fullError}');
        error.value = failure.uiMessage;
        _showError(failure.uiMessage);
      },
      (success) {
        debugPrint('[submitMoodCheckIn] selectMood API succeeded: ${success.message}');
        final moodData = success.data;
        if (moodData == null) {
          error.value = 'Mood check-in response was empty.';
          _showError(error.value);
          return;
        }
        moodCheckInResponse = moodData;
      },
    );

    if (moodCheckInResponse == null) {
      debugPrint('[submitMoodCheckIn] Mood check-in response is null. Aborting chat creation.');
      isSubmittingMoodCheckIn.value = false;
      return false;
    }

    final activeCheckIn = moodCheckInResponse!.data.moodCheckIn;
    if (activeCheckIn.id.trim().isEmpty) {
      debugPrint('[submitMoodCheckIn] Error: activeCheckIn ID is empty! Aborting chat creation.');
      isSubmittingMoodCheckIn.value = false;
      return false;
    }

    debugPrint('[submitMoodCheckIn] Extracted active check-in ID: ${activeCheckIn.id}');

    String formatLabel(String value) {
      return value
          .trim()
          .split('_')
          .where((part) => part.isNotEmpty)
          .map((part) {
            final lower = part.toLowerCase();
            return lower.length == 1
                ? lower.toUpperCase()
                : '${lower[0].toUpperCase()}${lower.substring(1)}';
          })
          .join(' ');
    }

    final triggerLabels = triggers.map(formatLabel).toList();
    final triggerStr = triggerLabels.isEmpty ? 'nothing specific' : triggerLabels.join(', ');
    final triggerOtherStr = triggerOther.trim().isNotEmpty ? ' ($triggerOther)' : '';
    final formattedDuration = formatLabel(duration);
    final formattedSupportType = formatLabel(supportType);

    final String initialContent =
        "I'm feeling $feeling (intensity: $intensity/10). Triggers: $triggerStr$triggerOtherStr. "
        "It's been going on for $formattedDuration. I need some $formattedSupportType.";

    debugPrint('[submitMoodCheckIn] Calling createChat: moodCheckInId=${activeCheckIn.id}, content="$initialContent"');
    final createChatResponse = await messageInt.createChat(
      CreateChatRequestModel(
        moodCheckInId: activeCheckIn.id,
        content: initialContent,
      ),
    );

    var isSuccess = false;
    createChatResponse.fold(
      (failure) {
        debugPrint('[submitMoodCheckIn] createChat API failed: ${failure.fullError}');
        error.value = failure.uiMessage;
        _showError(failure.uiMessage);
      },
      (success) {
        debugPrint('[submitMoodCheckIn] createChat API succeeded: ${success.message}');
        final messageData = success.data;
        if (messageData == null) {
          error.value = 'Chat response was empty.';
          _showError(error.value);
          return;
        }
        error.value = '';
        _chatSessionId = _resolveSessionId(messageData);
        messages.assignAll(_mapResponseMessages(messageData));
        debugPrint('[submitMoodCheckIn] Successfully loaded ${messages.length} messages into state (Session ID: $_chatSessionId)');
        isSuccess = true;
        _scrollToBottom();
      },
    );

    isSubmittingMoodCheckIn.value = false;
    return isSuccess;
  }

  Future<bool> sendTypedMessage() async {
    final content = inputController.text.trim();
    if (content.isEmpty || isSendingMessage.value || isAiTyping.value) {
      return false;
    }
    if (!hasActiveConversation) {
      _showError('Please start a chat from the mood check-in first.');
      return false;
    }

    inputController.clear();
    isSendingMessage.value = true;
    error.value = '';

    final optimisticId =
        'optimistic_user_${DateTime.now().microsecondsSinceEpoch}';
    final optimisticMessage = ChatUiMessage(
      id: optimisticId,
      role: 'user',
      content: content,
      createdAt: DateTime.now(),
    );
    messages.add(optimisticMessage);
    _scrollToBottom();

    isAiTyping.value = true;
    streamingAiText.value = '';

    final response = await messageInt.sendNewMessage(
      SendChatMessageRequestModel(
        chatSessionId: _chatSessionId!,
        content: content,
      ),
    );

    var isSuccess = false;
    await response.fold(
      (failure) async {
        error.value = failure.uiMessage;
        messages.removeWhere((message) => message.id == optimisticId);
        isAiTyping.value = false;
        streamingAiText.value = '';
        inputController.text = content;
        inputController.selection = TextSelection.fromPosition(
          TextPosition(offset: inputController.text.length),
        );
        _showError(failure.uiMessage);
      },
      (success) async {
        final messageData = success.data;
        if (messageData == null) {
          error.value = 'Chat response was empty.';
          messages.removeWhere((message) => message.id == optimisticId);
          isAiTyping.value = false;
          streamingAiText.value = '';
          _showError(error.value);
          return;
        }
        error.value = '';
        _chatSessionId = _resolveSessionId(messageData);

        final mapped = _mapResponseMessages(messageData);
        final realUserMessages =
            mapped.where((message) => message.isUser).toList();
        final assistantMessages =
            mapped.where((message) => !message.isUser).toList();

        messages.removeWhere((message) => message.id == optimisticId);
        _upsertMessages(realUserMessages);
        _scrollToBottom();

        for (final assistantMessage in assistantMessages) {
          await _streamAssistantMessage(assistantMessage);
        }

        isAiTyping.value = false;
        streamingAiText.value = '';
        isSuccess = true;
        _scrollToBottom();
      },
    );

    isSendingMessage.value = false;
    return isSuccess;
  }

  Future<void> _streamAssistantMessage(ChatUiMessage finalMessage) async {
    _streamTimer?.cancel();
    streamingAiText.value = '';

    final fullText = finalMessage.content;
    if (fullText.isEmpty) {
      if (!messages.any((message) => message.id == finalMessage.id)) {
        messages.add(finalMessage);
      }
      return;
    }

    final completer = Completer<void>();
    var charIndex = 0;

    _streamTimer = Timer.periodic(_streamTickDuration, (timer) {
      final nextIndex =
          (charIndex + _streamCharsPerTick).clamp(0, fullText.length);
      streamingAiText.value = fullText.substring(0, nextIndex);
      charIndex = nextIndex;
      _scrollToBottom();

      if (charIndex >= fullText.length) {
        timer.cancel();
        streamingAiText.value = '';
        if (!messages.any((message) => message.id == finalMessage.id)) {
          messages.add(finalMessage);
        }
        _scrollToBottom();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    await completer.future;
  }

  @override
  void onClose() {
    _streamTimer?.cancel();
    super.onClose();
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
