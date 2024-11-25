import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laborus_app/core/components/generics/double_back_to_close.dart';
import 'package:laborus_app/core/providers/chat_provider.dart';
import 'package:provider/provider.dart';

import 'components/chat_input.dart';
import 'components/chat_message_widget.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      chatProvider.startNewChat('LIA');
    });
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBackToCloseWidget(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primary,
          leading: IconButton(
            onPressed: () => context.go('/chat'),
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onTertiary,
            ),
          ),
          title: Consumer<ChatProvider>(
            builder: (context, chatProvider, _) {
              return Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/lia_avatar.png'),
                    radius: 20,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LIA - Assistente Virtual',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onTertiary,
                        ),
                      ),
                      if (chatProvider.isLoading)
                        Text(
                          'Digitando...',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.onPrimary,
          child: Consumer<ChatProvider>(
            builder: (context, chatProvider, _) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: chatProvider.messages.length,
                      itemBuilder: (context, index) {
                        final message = chatProvider.messages[index];
                        return ChatMessageWidget(message: message);
                      },
                    ),
                  ),
                  if (chatProvider.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  Container(
                    color: Theme.of(context).colorScheme.primary,
                    padding: EdgeInsets.only(
                      left: 22,
                      right: 22,
                      top: 13,
                      bottom: MediaQuery.of(context).padding.bottom + 13,
                    ),
                    child: ChatInputWidget(
                      onSend: (text) {
                        chatProvider.sendMessage(text);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
