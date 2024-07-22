import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String username;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.username,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.secondary,
      leading: const Icon(Icons.person),
      title: Text(username),
      onTap: onTap,
    );
  }
}
