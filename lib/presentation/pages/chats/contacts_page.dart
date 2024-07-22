import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chats/data/models/user/user_model.dart';
import 'package:chats/logic/user/user_logic.dart';

class ContactPage extends StatelessWidget {
  static const String routeName = '/contacts';

  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      // drawer: const AppDrawer(),
      body: _buildContactList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add new contact functionality
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildContactList(BuildContext context) {
    context.read<UsersCubit>().getUsers();
    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, state) {
        if (state.status == UsersStatus.initial ||
            state.status == UsersStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.status == UsersStatus.loaded) {
          return StreamBuilder<List<User>>(
            stream: state.users,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) =>
                      _buildContactListItem(context, snapshot.data![index]),
                );
              } else {
                return _buildEmptyState();
              }
            },
          );
        } else {
          return const Center(
            child: Text('Error loading contacts'),
          );
        }
      },
    );
  }

  Widget _buildContactListItem(BuildContext context, User user) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        user.fullName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        user.email,
        style: TextStyle(color: Colors.grey[600]),
      ),
      // trailing: Text(
      //   DateFormat('MMM d').format(user.createdAt.toDate()),
      //   style: TextStyle(color: Colors.grey[500], fontSize: 12),
      // ),
      onTap: () {
        Navigator.of(context).pushNamed(
          '/chat',
          arguments: {'userId': user.id!, 'userName': user.fullName},
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No contacts yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Add new contacts by tapping the button below',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
