part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChats extends ChatEvent {
  final String userId;

  const LoadChats({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class LoadUserChats extends ChatEvent {
  final String userId;

  const LoadUserChats({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class TypeMessage extends ChatEvent {
  final String message;

  const TypeMessage({required this.message});

  @override
  List<Object?> get props => [message];
}

class SendMessage extends ChatEvent {
  final String receiverId;

  const SendMessage({required this.receiverId});

  @override
  List<Object?> get props => [receiverId];
}

class LoadChatMessages extends ChatEvent {
  final String chatId;

  const LoadChatMessages({
    required this.chatId,
  });

  @override
  List<Object?> get props => [chatId];
}
