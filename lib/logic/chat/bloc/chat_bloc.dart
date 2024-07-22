import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:chats/logic/utils/utils.dart';
import 'package:chats/logic/auth/auth_logic.dart';

import 'package:chats/data/models/chat/chat_model.dart';
import 'package:chats/data/models/chat/chat_message_model.dart';
import 'package:chats/data/repositories/chat/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final AuthBloc _authBloc;
  final ChatRepository _chatRepository;

  ChatBloc({
    required AuthBloc authBloc,
    required ChatRepository chatRepository,
  })  : _authBloc = authBloc,
        _chatRepository = chatRepository,
        super(ChatInitial()) {
    on<LoadChats>(_onLoadChats);
    on<LoadUserChats>(_onLoadUserChats);
    on<TypeMessage>(_onTypeMessage);
    on<SendMessage>(_onSendMessage);
    on<LoadChatMessages>(_onLoadChatMessages);
  }

  Future<void> _onLoadChats(LoadChats event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final List<Chat> chats =
          await _chatRepository.getChats(userId: event.userId);
      emit(ChatsLoaded(chats: chats));

      // final Stream<List<Chat>> chats =
      //     _chatRepository.getUserChatsStream(event.userId);
      // emit(UserChatsLoaded(chats: chats));
    } catch (e) {
      emit(ChatError(error: 'Failed to load chats: $e'));
    }
  }

//   on<LoadChatMessages>((event, emit) async {
//     emit(ChatLoading());
//     try {
//         final Stream<List<ChatMessage>> messages = _chatRepository.getChatMessages(chatId: event.chatId);
//         await for (final messageList in messages) {
//             if (state is ChatMessagesLoaded && (state as ChatMessagesLoaded).messages == messageList) {
//                 continue;  // Skip emitting if the new state is the same as the current state
//             }
//             emit(ChatMessagesLoaded(messages: messageList));
//         }
//     } catch (e) {
//         emit(ChatError(error: 'Failed to load chat messages: $e'));
//     }
// });

  Future<void> _onLoadUserChats(
      LoadUserChats event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      // final List<Chat> chats =
      //     await _chatRepository.getChats(userId: event.userId);
      // emit(UserChatsLoaded(chats: chats));

      final Stream<List<Chat>> chats =
          _chatRepository.getUserChatsStream(event.userId);
      emit(UserChatsLoaded(chats: chats));
    } catch (e) {
      emit(ChatError(error: 'Failed to load chats: $e'));
    }
  }

  void _onTypeMessage(TypeMessage event, Emitter<ChatState> emit) {
    emit(MessageTyped(message: event.message));
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    final currentState = state;
    if (currentState is MessageTyped) {
      try {
        final user = _authBloc.state.user;
        if (user == null) {
          emit(const ChatError(error: 'User is not authenticated.'));
          return;
        }

        final userId = user.id;
        final receiverId = event.receiverId;
        final messageContent = currentState.message;

        if (userId == null || receiverId.isEmpty || messageContent.isEmpty) {
          emit(const ChatError(error: 'Invalid message data.'));
          return;
        }

        final message = ChatMessage(
          senderId: userId,
          receiverId: receiverId,
          message: messageContent,
          timestamp: Timestamp.now(),
        );

        await _chatRepository.sendMessage(
          chatId: generateConsistentId(receiverId, userId),
          message: message,
        );
        emit(MessageSent(message: message));

        // Reload messages after sending
        add(LoadChatMessages(chatId: generateConsistentId(receiverId, userId)));
      } catch (e) {
        emit(ChatError(error: 'Failed to send message: $e'));
      }
    } else {}
  }

  Future<void> _onLoadChatMessages(
      LoadChatMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final Stream<List<ChatMessage>> messages =
          _chatRepository.getChatMessages(chatId: event.chatId);
      emit(ChatMessagesLoaded(messages: messages));
    } catch (e) {
      emit(ChatError(error: 'Failed to load chat messages: $e'));
    }
  }
}
