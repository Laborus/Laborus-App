import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:laborus_app/core/model/chat/chat_messages.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageWidget({required this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';

    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 300),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUser
                ? Theme.of(context).colorScheme.primary
                : AppColors.primaryPurple,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: isUser ? const Radius.circular(12) : Radius.zero,
              bottomRight: isUser ? Radius.zero : const Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              MarkdownBody(
                data: message.content,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    color: isUser
                        ? Theme.of(context).colorScheme.onTertiary
                        : AppColors.neutralsLight[0],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
