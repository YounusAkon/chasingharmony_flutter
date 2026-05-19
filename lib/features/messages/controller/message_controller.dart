import 'package:chasingharmony_fluttere/features/home/model/chat_stream_event.dart';
import 'package:chasingharmony_fluttere/features/home/model/message_responces_model.dart';
import 'package:chasingharmony_fluttere/features/home/model/send_message_model.dart';
import 'package:chasingharmony_fluttere/features/home/services/home_sercices/home_interface.dart';
import 'package:chasingharmony_fluttere/features/messages/model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  MessageController({
    required this.homeInterface,
    // required this.historyInt,
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  static String get friendlyDeliveryError => 'chat.deliveryUnavailable'.tr;
  static const String _safetyTipConversationKeyPrefix =
      'safety_tip_conversation_';

  final HomeInterface homeInterface;
  // final HistoryInt historyInt;
  final FlutterSecureStorage _storage;

  final RxString selectedEmergencyKey = 'general'.obs;
  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isSending = false.obs;
  final RxString lastError = ''.obs;
  String? _activeConversationId;
  String? _activeSafetyTipKey;

  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final List<EmergencyTopic> emergencyTopics = const <EmergencyTopic>[
    EmergencyTopic(
      key: 'general',
      labelKey: 'emergency.general',
      icon: Icons.chat_bubble_outline_rounded,
    ),
    EmergencyTopic(
      key: 'fire',
      labelKey: 'emergency.fire',
      icon: Icons.local_fire_department_rounded,
    ),
    EmergencyTopic(
      key: 'first_aid',
      labelKey: 'emergency.firstAid',
      icon: Icons.medical_services_outlined,
    ),
    EmergencyTopic(
      key: 'earthquake',
      labelKey: 'emergency.earthquake',
      icon: Icons.vibration_rounded,
    ),
    EmergencyTopic(
      key: 'blackout',
      labelKey: 'emergency.blackout',
      icon: Icons.power_off_rounded,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _loadConversationFor(selectedEmergencyKey.value);
  }

  @override
  void onClose() {
    inputController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  List<String> get quickPrompts {
    switch (selectedEmergencyKey.value) {
      case 'general':
        return <String>[
          'chat.quick.general.one'.tr,
          'chat.quick.general.two'.tr,
        ];
      case 'first_aid':
        return <String>[
          'chat.quick.firstAid.one'.tr,
          'chat.quick.firstAid.two'.tr,
        ];
      case 'earthquake':
        return <String>[
          'chat.quick.earthquake.one'.tr,
          'chat.quick.earthquake.two'.tr,
        ];
      case 'blackout':
        return <String>[
          'chat.quick.blackout.one'.tr,
          'chat.quick.blackout.two'.tr,
        ];
      case 'fire':
      default:
        return <String>['chat.quick.fire.one'.tr, 'chat.quick.fire.two'.tr];
    }
  }

  void selectEmergency(String key) {
    if (selectedEmergencyKey.value == key && _activeSafetyTipKey == null) {
      return;
    }
    selectedEmergencyKey.value = key;
    _activeConversationId = null;
    _clearSafetyTipContext();
    _loadConversationFor(key);
  }

  Future<void> sendTypedMessage() async {
    final text = inputController.text.trim();
    if (text.isEmpty) return;
    inputController.clear();
    await _sendToBackend(text: text);
  }

  Future<void> sendQuickPrompt(String prompt) async {
    await _sendToBackend(text: prompt);
  }

  Future<void> retryMessage(MessageModel failedMessage) async {
    if (!failedMessage.canRetry || isSending.value) return;

    final retryText = failedMessage.retryText!.trim();
    if (retryText.isEmpty) return;

    messages.removeWhere((message) => message.id == failedMessage.id);
    await _sendToBackend(
      text: retryText,
      emergencyTypeOverride: failedMessage.retryEmergencyType,
      appendUserMessage: false,
    );
  }

  Future<bool> startEmergencyChat({
    required String emergencyType,
    String? initialMessage,
  }) async {
    final mappedKey = _mapEmergencyTypeToKey(emergencyType);
    if (mappedKey != null) {
      selectedEmergencyKey.value = mappedKey;
    }

    messages.clear();
    _activeConversationId = null;
    _clearSafetyTipContext();
    final openingMessage = (initialMessage ?? '').trim().isNotEmpty
        ? initialMessage!.trim()
        : _defaultInitialPromptFor(selectedEmergencyKey.value);

    return _sendToBackend(
      text: openingMessage,
      emergencyTypeOverride: emergencyType.trim().isEmpty
          ? null
          : emergencyType,
    );
  }

  // Future<void> openSafetyTipChat({
  //   required String tipId,
  //   required String tipTitle,
  // }) async {
  //   final normalizedTipTitle = tipTitle.trim();
  //   final safetyTipKey = _safetyTipKeyFor(tipId: tipId, tipTitle: tipTitle);

  //   selectedEmergencyKey.value = 'general';
  //   lastError.value = '';
  //   inputController.clear();
  //   _activeSafetyTipKey = safetyTipKey;

  //   final storedConversationId = await _storage.read(
  //     key: _storageKeyForSafetyTip(safetyTipKey),
  //   );
  //   if (storedConversationId != null &&
  //       storedConversationId.trim().isNotEmpty) {
  //     final didLoadSavedConversation = await _loadConversationById(
  //       storedConversationId.trim(),
  //       preserveSafetyTipContext: true,
  //     );
  //     if (didLoadSavedConversation) {
  //       return;
  //     }
  //     await _storage.delete(key: _storageKeyForSafetyTip(safetyTipKey));
  //   }

  //   _activeConversationId = null;
  //   messages.clear();
  //   _loadConversationFor(
  //     'general',
  //     topicTitle: normalizedTipTitle.isEmpty ? null : normalizedTipTitle,
  //   );
  // }

  void loadHistoryConversation({
    required List<MessageModel> historyMessages,
    String emergencyType = '',
    String conversationId = '',
    bool preserveSafetyTipContext = false,
  }) {
    final mappedKey = _mapEmergencyTypeToKey(emergencyType);
    if (mappedKey != null) {
      selectedEmergencyKey.value = mappedKey;
    }

    if (!preserveSafetyTipContext) {
      _clearSafetyTipContext();
    }

    if (historyMessages.isEmpty) {
      _activeConversationId = null;
      _loadConversationFor(selectedEmergencyKey.value);
      return;
    }

    _activeConversationId = conversationId.trim().isEmpty
        ? null
        : conversationId.trim();
    messages.assignAll(historyMessages);
    _scrollToBottom();
  }

  Future<bool> _sendToBackend({
    required String text,
    String? emergencyTypeOverride,
    bool appendUserMessage = true,
  }) async {
    final content = text.trim();
    if (content.isEmpty || isSending.value) return false;

    isSending.value = true;
    lastError.value = '';

    if (appendUserMessage) {
      messages.add(
        MessageModel(
          id: _nextId(),
          role: MessageRole.user,
          text: content,
          createdAt: DateTime.now(),
        ),
      );
      _scrollToBottom();
    }

    final override = (emergencyTypeOverride ?? '').trim();
    final overrideKey = _mapEmergencyTypeToKey(override);
    final emergencyType = override.isNotEmpty
        ? (overrideKey == null
              ? override
              : _canonicalEmergencyTypeForKey(overrideKey))
        : _canonicalEmergencyTypeForKey(selectedEmergencyKey.value);

    final assistantDraftId = _nextId();
    messages.add(
      MessageModel(
        id: assistantDraftId,
        role: MessageRole.assistant,
        text: '',
        createdAt: DateTime.now(),
        isStreaming: true,
      ),
    );
    _scrollToBottom();

    var success = false;
    try {
      await for (final event in homeInterface.sendNewMessageStream(
        SendMessageModel(
          emergencyType: emergencyType,
          message: content,
          conversationId: _activeConversationId,
        ),
      )) {
        switch (event.type) {
          case ChatStreamEventType.meta:
            if (event.conversationId.trim().isNotEmpty) {
              _activeConversationId = event.conversationId.trim();
            }
            final mappedKey = _mapEmergencyTypeToKey(event.emergencyType);
            if (mappedKey != null) {
              selectedEmergencyKey.value = mappedKey;
            }
            break;
          case ChatStreamEventType.delta:
            if (event.text.isNotEmpty) {
              _appendToStreamingMessage(assistantDraftId, event.text);
            }
            break;
          case ChatStreamEventType.done:
            success = true;
            final conversation = event.conversation;
            final conversationMessages = conversation?.messages ?? const [];
            _activeConversationId = (conversation?.id ?? '').trim().isEmpty
                ? _activeConversationId
                : conversation?.id.trim();

            final mappedKey = _mapEmergencyTypeToKey(
              conversation?.emergencyType ?? event.emergencyType,
            );
            if (mappedKey != null) {
              selectedEmergencyKey.value = mappedKey;
            }

            await _persistSafetyTipConversationIfNeeded();

            if (conversationMessages.isNotEmpty) {
              messages.assignAll(
                conversationMessages.map(_toMessageModel).toList(),
              );
            } else if (event.assistantMessage != null) {
              _replaceMessageById(
                assistantDraftId,
                _toMessageModel(event.assistantMessage!),
              );
            } else {
              final draftIndex = messages.indexWhere(
                (message) => message.id == assistantDraftId,
              );
              final draft = draftIndex == -1
                  ? MessageModel(
                      id: assistantDraftId,
                      role: MessageRole.assistant,
                      text: '',
                      createdAt: DateTime.now(),
                    )
                  : messages[draftIndex];
              _replaceMessageById(
                assistantDraftId,
                draft.copyWith(isStreaming: false),
              );
            }
            break;
          case ChatStreamEventType.error:
            throw Exception(
              event.message.trim().isEmpty
                  ? friendlyDeliveryError
                  : event.message,
            );
          case ChatStreamEventType.unknown:
            break;
        }
      }

      if (!success) {
        throw Exception('Stream ended before the assistant response completed');
      }
    } catch (error) {
      final technicalError = error.toString().trim();
      lastError.value = technicalError;
      if (kDebugMode && technicalError.isNotEmpty) {
        debugPrint(
          '[MessageController] sendMessage stream failed: $technicalError',
        );
      }

      _replaceMessageById(
        assistantDraftId,
        MessageModel(
          id: assistantDraftId,
          role: MessageRole.assistant,
          text: friendlyDeliveryError,
          createdAt: DateTime.now(),
          isError: true,
          retryText: content,
          retryEmergencyType: emergencyType,
        ),
      );
    } finally {
      isSending.value = false;
      _scrollToBottom();
    }

    return success;
  }

  void _appendToStreamingMessage(String messageId, String delta) {
    final index = messages.indexWhere((message) => message.id == messageId);
    if (index == -1) return;

    final current = messages[index];
    messages[index] = current.copyWith(
      text: '${current.text}$delta',
      isStreaming: true,
    );
    _scrollToBottom();
  }

  void _replaceMessageById(String messageId, MessageModel replacement) {
    final index = messages.indexWhere((message) => message.id == messageId);
    if (index == -1) {
      messages.add(replacement);
      return;
    }
    messages[index] = replacement;
  }

  // Future<bool> _loadConversationById(
  //   String conversationId, {
  //   bool preserveSafetyTipContext = false,
  // }) async {
  //   bool didLoadConversation = false;
  //   // final response = await historyInt.getConversationbyID(conversationId);

  //   response.fold(
  //     (_) {
  //       didLoadConversation = false;
  //     },
  //     (success) {
  //       final conversation = success.data;
  //       if (conversation == null) {
  //         didLoadConversation = false;
  //         return;
  //       }
  //       final historyMessages = conversation.messages
  //           .map(
  //             (message) => MessageModel(
  //               id: message.id.trim().isEmpty ? _nextId() : message.id,
  //               role: _toRole(message.role),
  //               text: message.content,
  //               createdAt: message.createdAt ?? DateTime.now(),
  //             ),
  //           )
  //           .toList();
  //       loadHistoryConversation(
  //         historyMessages: historyMessages,
  //         emergencyType: conversation.emergencyType,
  //         conversationId: conversation.id,
  //         preserveSafetyTipContext: preserveSafetyTipContext,
  //       );
  //       didLoadConversation = true;
  //     },
  //   );

  //   return didLoadConversation;
  // }

  void _loadConversationFor(String key, {String? topicTitle}) {
    final title = (topicTitle ?? '').trim().isNotEmpty
        ? topicTitle!.trim()
        : _mapEmergencyKeyToType(key);
    messages.assignAll(<MessageModel>[
      MessageModel(
        id: _nextId(),
        role: MessageRole.assistant,
        text: _initialAssistantMessageFor(key, title: title, topicTitle: topicTitle),
        createdAt: DateTime.now(),
      ),
    ]);
    _scrollToBottom();
  }

  String _initialAssistantMessageFor(
    String key, {
    required String title,
    String? topicTitle,
  }) {
    final hasCustomTopicTitle = (topicTitle ?? '').trim().isNotEmpty;
    if (!hasCustomTopicTitle) {
      switch (key) {
        case 'general':
          return 'chat.welcomeGeneral'.tr;
        case 'first_aid':
          return 'chat.welcomeFirstAid'.tr;
        case 'earthquake':
          return 'chat.welcomeEarthquake'.tr;
        case 'blackout':
          return 'chat.welcomeBlackout'.tr;
        case 'fire':
          return 'chat.welcomeFire'.tr;
      }
    }

    return 'chat.selectedIntro'.trParams(<String, String>{'topic': title});
  }

  MessageModel _toMessageModel(MessageChatItemModel item) {
    return MessageModel(
      id: item.id.trim().isEmpty ? _nextId() : item.id,
      role: _toRole(item.role),
      text: item.content,
      createdAt: item.createdAt ?? DateTime.now(),
    );
  }

  MessageRole _toRole(String backendRole) {
    switch (backendRole.toLowerCase().trim()) {
      case 'user':
        return MessageRole.user;
      case 'assistant':
      default:
        return MessageRole.assistant;
    }
  }

  String _defaultInitialPromptFor(String key) {
    switch (key) {
      case 'general':
        return 'emergency.generalPrompt'.tr;
      case 'first_aid':
        return 'emergency.firstAidPrompt'.tr;
      case 'earthquake':
        return 'emergency.earthquakePrompt'.tr;
      case 'blackout':
        return 'emergency.blackoutPrompt'.tr;
      case 'fire':
      default:
        return 'emergency.firePrompt'.tr;
    }
  }

  String _mapEmergencyKeyToType(String key) {
    switch (key) {
      case 'general':
        return 'emergency.general'.tr;
      case 'first_aid':
        return 'emergency.firstAid'.tr;
      case 'earthquake':
        return 'emergency.earthquake'.tr;
      case 'blackout':
        return 'emergency.blackout'.tr;
      case 'fire':
      default:
        return 'emergency.fire'.tr;
    }
  }

  String _canonicalEmergencyTypeForKey(String key) {
    switch (key) {
      case 'general':
        return 'General';
      case 'first_aid':
        return 'First Aid';
      case 'earthquake':
        return 'Earthquake';
      case 'blackout':
        return 'Blackout';
      case 'fire':
      default:
        return 'Fire';
    }
  }

  String? _mapEmergencyTypeToKey(String emergencyType) {
    final normalized = emergencyType.toLowerCase().trim();
    if (normalized.isEmpty) return null;
    if (normalized == 'general' ||
        normalized.contains('general safety') ||
        normalized.contains('generale')) {
      return 'general';
    }
    if (normalized.contains('fire') || normalized.contains('incendio')) {
      return 'fire';
    }
    if (normalized.contains('first aid') ||
        normalized.contains('aid') ||
        normalized.contains('primo soccorso')) {
      return 'first_aid';
    }
    if (normalized.contains('earthquake') || normalized.contains('terremoto')) {
      return 'earthquake';
    }
    if (normalized.contains('blackout') ||
        normalized.contains('power outage') ||
        normalized.contains('power cut') ||
        normalized.contains('mancanza di corrente')) {
      return 'blackout';
    }
    return null;
  }

  void _clearSafetyTipContext() {
    _activeSafetyTipKey = null;
  }

  Future<void> _persistSafetyTipConversationIfNeeded() async {
    final safetyTipKey = _activeSafetyTipKey;
    final conversationId = _activeConversationId?.trim() ?? '';
    if (safetyTipKey == null ||
        safetyTipKey.isEmpty ||
        conversationId.isEmpty) {
      return;
    }

    await _storage.write(
      key: _storageKeyForSafetyTip(safetyTipKey),
      value: conversationId,
    );
  }

  String _storageKeyForSafetyTip(String safetyTipKey) {
    return '$_safetyTipConversationKeyPrefix$safetyTipKey';
  }

  String _safetyTipKeyFor({required String tipId, required String tipTitle}) {
    final normalizedTipId = tipId.trim();
    if (normalizedTipId.isNotEmpty) {
      return normalizedTipId;
    }

    final normalizedTitle = tipTitle
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
    return normalizedTitle.isEmpty ? 'unknown_safety_tip' : normalizedTitle;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
    });
  }

  String _nextId() => DateTime.now().microsecondsSinceEpoch.toString();
}

class EmergencyTopic {
  const EmergencyTopic({
    required this.key,
    required this.labelKey,
    required this.icon,
  });

  final String key;
  final String labelKey;
  final IconData icon;
}
