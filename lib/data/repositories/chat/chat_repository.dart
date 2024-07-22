import 'package:chats/data/models/chat/chat_model.dart';
import 'package:chats/data/models/chat/chat_message_model.dart';
import 'package:chats/data/providers/chat/chat_provider.dart';
import 'package:chats/data/repositories/chat/base_chat_repository.dart';

class ChatRepository extends BaseChatRepository {
  final ChatProvider _chatProvider;

  ChatRepository({
    ChatProvider? chatProvider,
  }) : _chatProvider = chatProvider ?? ChatProvider();

  @override
  Future<String> createChat({required Chat chat}) async {
    try {
      return await _chatProvider.createChat(chat: chat);
    } catch (e) {
      // Handle error
      rethrow; // Rethrow the error for higher-level handling
    }
  }

  @override
  Future<List<Chat>> getChats({required String userId}) async {
    try {
      return await _chatProvider.getChats(userId: userId);
    } catch (e) {
      // Handle error
      rethrow; // Rethrow the error for higher-level handling
    }
  }

  @override
  Future<ChatMessage> sendMessage(
      {required String chatId, required ChatMessage message}) async {
    try {
      // Check if the chat exists, if not, create it
      final chatExists = await _chatProvider.checkChat(chatId: chatId);
      if (!chatExists) {
        final chat = Chat(
          id: chatId,
          memberIds: [message.senderId, message.receiverId],
          createdAt: message.timestamp!,
          lastMessageText: message.message,
          lastMessageTimestamp: message.timestamp!,
        );
        await createChat(chat: chat);
      }

      return await _chatProvider.sendMessage(chatId: chatId, message: message);
    } catch (e) {
      // Handle error
      rethrow; // Rethrow the error for higher-level handling
    }
  }

  @override
  Stream<List<ChatMessage>> getChatMessages({required String chatId}) {
    try {
      return _chatProvider.getChatMessagesStream(chatId);
    } catch (e) {
      // Handle error
      rethrow; // Rethrow the error for higher-level handling
    }
  }

  Stream<List<Chat>> getUserChatsStream(String userId) {
    return _chatProvider.getUserChatsStream(userId);
  }
}
