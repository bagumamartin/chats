import 'package:chats/data/chat_data.dart';
import 'package:chats/logic/auth/auth_logic.dart';
import 'package:chats/logic/chat/chat_logic.dart';
import 'package:chats/logic/user/cubit/user_cubit.dart';
import 'package:chats/presentation/components/app_drawer.dart';
import 'package:chats/presentation/pages/chats/chats_pages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppHomePage extends StatelessWidget {
  static const String routeName = '/';

  const AppHomePage({
    super.key,
    // required this.title,
  });

  // final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality; Search in chats
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/contacts");
        },
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState.status == AuthStatus.authenticated) {
          return _buildUserChatsList(context, authState.user!.id!);
        } else {
          return const Center(child: Text('Please log in to view your chats.'));
        }
      },
    );
  }

  Widget _buildUserChatsList(BuildContext context, String userId) {
    context.read<ChatBloc>().add(LoadUserChats(userId: userId));

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserChatsLoaded) {
          return StreamBuilder<List<Chat>>(
            stream: state.chats,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final chats = snapshot.data!;
                return chats.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        itemCount: chats.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          return _buildChatListItem(
                              context, chats[index], userId);
                        },
                      );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        } else if (state is ChatError) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          return _buildEmptyState();
        }
      },
    );
  }

  Widget _buildChatListItem(
      BuildContext context, Chat chat, String currentUserId) {
    String otherUserId = chat.memberIds
        .firstWhere((id) => id != currentUserId, orElse: () => 'Unknown');

    // Trigger user data fetch
    context.read<UserCubit>().getUser(userId: otherUserId);

    return BlocBuilder<UserCubit, UserState>(
      buildWhen: (previous, current) =>
          previous.users[otherUserId] != current.users[otherUserId],
      builder: (context, state) {
        final userData = state.users[otherUserId];

        if (userData == null || userData.status != UserStatus.loaded) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            title: const Text('Loading...'),
            subtitle: const Text('Please wait'),
          );
        }

        final otherUserName = userData.username;

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              otherUserName.isNotEmpty ? otherUserName[0].toUpperCase() : '?',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            otherUserName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  chat.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              Text(
                DateFormat('kk:mm').format(chat.updatedAt!.toDate()),
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              )
            ],
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverId: otherUserId,
                  receiverName: otherUserName,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No chats yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Start a new chat by tapping the button below',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
