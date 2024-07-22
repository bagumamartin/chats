import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chats/logic/user/user_logic.dart';

class UserProfilePage extends StatelessWidget {
  static const String routeName = '/profile';
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen: (previous, current) =>
            (previous.status == ProfileStatus.loading &&
                current.status == ProfileStatus.loaded) ||
            current.status == ProfileStatus.updated,
        builder: (context, state) {
          return ListView(
            children: <Widget>[
              _buildListTile(
                context,
                'Full Name',
                ProfileField.fullName,
                state.user?.fullName ?? 'N/A', // Adjusted line
                (field, value, action) async {
                  await context.read<ProfileCubit>().updateProfile(
                        action: action,
                        field: field,
                        value: value,
                      );
                },
              ),
              _buildListTile(
                context,
                'Email',
                ProfileField.email,
                state.user?.email ?? 'N/A', // Adjusted line
                (field, value, action) async {
                  await context.read<ProfileCubit>().updateProfile(
                        action: action,
                        field: field,
                        value: value,
                      );
                },
              ),
              _buildListTile(
                context,
                'Address',
                ProfileField.address,
                state.user?.address ?? 'N/A', // Adjusted line
                (field, value, action) async {
                  await context.read<ProfileCubit>().updateProfile(
                        action: action,
                        field: field,
                        value: value,
                      );
                },
              ),
              _buildListTile(
                context,
                'City',
                ProfileField.city,
                state.user?.city ?? 'N/A', // Adjusted line
                (field, value, action) async {
                  await context.read<ProfileCubit>().updateProfile(
                        action: action,
                        field: field,
                        value: value,
                      );
                },
              ),
              _buildListTile(
                context,
                'Country',
                ProfileField.country,
                state.user?.country ?? 'N/A', // Adjusted line
                (field, value, action) async {
                  await context.read<ProfileCubit>().updateProfile(
                        action: action,
                        field: field,
                        value: value,
                      );
                },
              ),
              _buildListTile(
                context,
                'Zip Code',
                ProfileField.zipCode,
                state.user?.zipCode ?? 'N/A', // Adjusted line
                (field, value, action) async {
                  await context.read<ProfileCubit>().updateProfile(
                        action: action,
                        field: field,
                        value: value,
                      );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    ProfileField field,
    String value,
    Function(ProfileField, String?, ProfileAction) callEventFunction,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      onTap: () =>
          _showOverlayForm(context, title, field, value, callEventFunction),
    );
  }

  void _showOverlayForm(
    BuildContext context,
    String field,
    ProfileField profileField,
    String currentValue,
    Function(ProfileField, String?, ProfileAction) callEventFunction,
  ) {
    // Create a TextEditingController with the current value
    final TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            controller: controller, // Use the created controller here
            decoration: InputDecoration(labelText: 'Enter new $field'),
            onChanged: (value) {
              callEventFunction(profileField, value, ProfileAction.typing);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                callEventFunction(profileField, controller.text,
                    ProfileAction.saving); // Use controller.text here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
