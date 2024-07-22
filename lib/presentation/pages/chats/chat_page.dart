import 'package:chats/data/models/chat/chat_message_model.dart';
import 'package:chats/logic/auth/auth_logic.dart';
import 'package:chats/logic/chat/chat_logic.dart';
import 'package:chats/logic/utils/consistent_id_generator.dart';
import 'package:chats/presentation/components/app_textfield.dart';
import 'package:chats/presentation/components/message_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  static const String routeName = '/chat';
  final String receiverId;
  final String receiverName;

  const ChatPage({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(
          LoadChatMessages(
            chatId: generateConsistentId(
              widget.receiverId,
              context.read<AuthBloc>().state.user?.id ?? '',
            ),
          ),
        );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          final userId = context.read<AuthBloc>().state.user?.id;
          context.read<ChatBloc>().add(LoadUserChats(userId: userId!));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              // final user = state.authUser;
              return Text(
                widget.receiverName.isNotEmpty ? widget.receiverName : 'Chat',
                //   user?.displayName?.isNotEmpty == true
                //       ? user!.displayName!
                //       : (user?.email ?? 'Chat'),
              );
            },
          ),
        ),
        body: Column(
          children: [
            // Display messages
            Expanded(
              child: _buildMessageList(context),
            ),
            // Input field
            _buildMessageInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) {
        // Only rebuild for these states
        return current is ChatInitial ||
            current is ChatLoading ||
            current is ChatMessagesLoaded ||
            current is ChatError;
      },
      builder: (context, chatState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (chatState is ChatInitial || chatState is ChatLoading) {
              if (chatState is ChatInitial) {
                context.read<ChatBloc>().add(
                      LoadChatMessages(
                        chatId: generateConsistentId(
                          widget.receiverId,
                          authState.user?.id ?? '',
                        ),
                      ),
                    );
              }
              return const Center(child: CircularProgressIndicator());
            } else if (chatState is ChatMessagesLoaded) {
              return StreamBuilder<List<ChatMessage>>(
                stream: chatState.messages,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final userId = authState.user?.id;
                    if (userId == null) {
                      return const Center(
                          child: Text('User not authenticated'));
                    }
                    return ListView(
                      children: snapshot.data!
                          .map((message) =>
                              _builderMessageListItem(context, message, userId))
                          .toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return const Center(child: Text('No messages found'));
                  }
                },
              );
            } else if (chatState is ChatError) {
              return Center(child: Text('Error: ${chatState.error}'));
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        );
      },
    );
  }

  Widget _builderMessageListItem(
    BuildContext context,
    ChatMessage message,
    String userId,
  ) {
    return MessageTile(message: message, userid: userId);
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Email textfield
          Expanded(
            child: AppTextField(
              controller: _messageController,
              hintText: "Type a message...",
              obsecureText: false,
              onChanged: (value) {
                context.read<ChatBloc>().add(
                      TypeMessage(
                        message: value,
                      ),
                    );
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              context.read<ChatBloc>().add(
                    SendMessage(receiverId: widget.receiverId),
                  );
              _messageController.clear();
              setState(() {
                FocusScope.of(context).unfocus();
              });
            },
          ),
        ],
      ),
    );
  }
}
