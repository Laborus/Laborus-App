import 'package:flutter/material.dart';
import 'package:laborus_app/core/model/chat/chat_messages.dart';
import 'package:laborus_app/core/services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService;
  String? currentChatId;
  bool isLoading = false;
  List<ChatMessage> messages = [];

  ChatProvider(this._chatService);

  Future<void> startNewChat(String userId) async {
    isLoading = true;
    notifyListeners();

    try {
      final chat = await _chatService.createChat(userId);
      currentChatId = chat.id;

      // Começa a ouvir as mensagens
      _chatService.getMessages(chat.id).listen((updatedMessages) {
        messages = updatedMessages;
        notifyListeners();
      });
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String content) async {
    if (currentChatId == null) return;

    isLoading = true;
    notifyListeners();

    try {
      // Adiciona a mensagem do usuário
      await _chatService.addMessage(currentChatId!, content, 'user');

      // Gera e adiciona a resposta do assistente
      final response = await _chatService.generateResponse(content);
      await _chatService.addMessage(currentChatId!, response, 'assistant');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
