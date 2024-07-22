import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chats/logic/auth/auth_logic.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // Logo
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40.0,
                  ),
                ),
              ),

              // Home list tile

              Padding(
                padding: const EdgeInsets.only(
                  left: 25.0,
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.security,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Account'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed('/authSettings');
                  },
                ),
              ),

              // Settings list tile
              Padding(
                padding: const EdgeInsets.only(
                  left: 25.0,
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed('/settings');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 25.0,
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed('/profile');
                  },
                ),
              ),
            ],
          ),
          // Logout list tile
          Padding(
            padding: const EdgeInsets.only(
              left: 25.0,
              bottom: 25.0,
            ),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                context.read<SignoutCubit>().signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
