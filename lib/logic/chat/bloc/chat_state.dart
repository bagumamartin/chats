part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatsLoaded extends ChatState {
  final List<Chat> chats;

  const ChatsLoaded({required this.chats});

  @override
  List<Object?> get props => [chats];
}

class MessageTyped extends ChatState {
  final String message;

  const MessageTyped({required this.message});

  @override
  List<Object?> get props => [message];
}

class MessageSent extends ChatState {
  final ChatMessage message;

  const MessageSent({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChatMessagesLoaded extends ChatState {
  final Stream<List<ChatMessage>> messages;

  const ChatMessagesLoaded({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class ChatError extends ChatState {
  final String error;

  const ChatError({required this.error});

  @override
  List<Object?> get props => [error];
}

class UserChatsLoaded extends ChatState {
  final Stream<List<Chat>> chats;

  const UserChatsLoaded({required this.chats});

  @override
  List<Object?> get props => [chats];
}
