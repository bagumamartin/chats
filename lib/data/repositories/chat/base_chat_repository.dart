import 'package:chats/data/models/chat/chat_message_model.dart';
import 'package:chats/data/models/chat/chat_model.dart';

abstract class BaseChatRepository {
  Future<String> createChat({required Chat chat});

  Future<List<Chat>> getChats({required String userId});

  Future<ChatMessage> sendMessage(
      {required String chatId, required ChatMessage message});

  Stream<List<ChatMessage>> getChatMessages({required String chatId});
}
