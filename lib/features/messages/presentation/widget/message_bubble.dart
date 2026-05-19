import 'package:chasingharmony_fluttere/features/messages/model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message, this.onRetry});

  final MessageModel message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (message.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 240),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1676C9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            message.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    if (message.isGuidance) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 280),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEFEFEF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFD5D5D5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.report_gmailerrorred_rounded,
                    color: Color(0xFFF19100),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      message.title ?? 'message.guidance'.tr,
                      style: const TextStyle(
                        color: Color(0xFF2D2D2D),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                message.text,
                style: const TextStyle(
                  color: Color(0xFF424242),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 8),
              _MessageActions(messageText: message.text),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFDCDCDC)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.isTyping)
              const _TypingIndicator()
            else
              Text(
                message.text,
                style: const TextStyle(
                  color: Color(0xFF3F3F3F),
                  fontSize: 14,
                  height: 1.35,
                ),
              ),
            if (!message.isStreaming && message.text.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              _MessageActions(
                messageText: message.text,
                canRetry: message.canRetry,
                onRetry: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'typing...',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MessageActions extends StatelessWidget {
  const _MessageActions({
    required this.messageText,
    this.canRetry = false,
    this.onRetry,
  });

  final String messageText;
  final bool canRetry;
  final VoidCallback? onRetry;

  Future<void> _copyMessage(BuildContext context) async {
    final text = messageText.trim();
    if (text.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('message.copied'.tr)));
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.grey.shade600;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => _copyMessage(context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
            child: Row(
              children: [
                Icon(Icons.copy_all_rounded, size: 13, color: color),
                const SizedBox(width: 4),
                Text(
                  'message.copy'.tr,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (canRetry) ...[
          const SizedBox(width: 10),
          InkWell(
            onTap: onRetry,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              child: Row(
                children: [
                  Icon(Icons.refresh_rounded, size: 13, color: color),
                  const SizedBox(width: 4),
                  Text(
                    'common.retry'.tr,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
