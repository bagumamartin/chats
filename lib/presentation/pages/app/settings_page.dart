import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chats/logic/app/theme_logic.dart' as app;

class AppSettingsPage extends StatelessWidget {
  static const String routeName = '/settings';

  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          BlocBuilder<app.ThemeCubit, app.ThemeState>(
            builder: (context, state) {
              return SwitchListTile(
                title: const Text('Dark Mode'),
                value: state.mode == app.ThemeMode.dark,
                onChanged: (bool value) {
                  context.read<app.ThemeCubit>().toggleTheme();
                },
              );
            },
          ),
          // Add more settings options here
        ],
      ),
    );
  }
}
