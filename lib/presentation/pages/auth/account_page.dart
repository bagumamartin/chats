import 'dart:io';

import 'package:chats/logic/auth/auth_logic.dart';
import 'package:chats/presentation/pages/chats/chats_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AccountPage extends StatelessWidget {
  static const String routeName = '/authSettings';

  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Account')),
        body: BlocConsumer<AccountCubit, AccountState>(
          listener: (context, state) {
            if (state.status == AccountStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
          },
          buildWhen: (previous, current) =>
              (previous.status == AccountStatus.loading &&
                  current.status == AccountStatus.loaded) ||
              current.status == AccountStatus.updated,
          builder: (context, state) {
            if (state.status == AccountStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () => _updateProfilePicture(context),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: state.authUser?.photoURL != null
                            ? NetworkImage(state.authUser!.photoURL!)
                            : null,
                        child: state.authUser?.photoURL == null
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildListTile(
                    context,
                    'Display Name',
                    AccountField.displayName,
                    state.authUser?.displayName ?? 'Enter a user name',
                    (field, value, action) async {
                      await context.read<AccountCubit>().updateAccount(
                            action: action,
                            field: field,
                            value: value,
                          );
                    },
                  ),
                  _buildListTile(
                    context,
                    'Email',
                    AccountField.email,
                    state.authUser?.email ?? 'Enter your email',
                    (field, value, action) async {
                      await context.read<AccountCubit>().updateAccount(
                            action: action,
                            field: field,
                            value: value,
                          );
                    },
                  ),
                  _buildListTile(
                    context,
                    'Phone Number',
                    AccountField.phoneNumber,
                    state.authUser?.phoneNumber ?? 'Enter your phone number',
                    (field, value, action) async {
                      await context.read<AccountCubit>().updateAccount(
                            action: action,
                            field: field,
                            value: value,
                          );
                    },
                  ),
                ],
              ),
            );
          },
        ),

        // If SignupState status is registering, show bottom navigation bar with done and skip buttons
        // If SignupState status is success, don't show bottom navigation bar
        bottomNavigationBar: BlocBuilder<SignupCubit, SignupState>(
          builder: (context, state) {
            if (state.status == SignupStatus.registering) {
              return BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.read<SignupCubit>().registered();
                        Navigator.of(context).pushReplacementNamed(
                          AppHomePage.routeName,
                        );
                      },
                      child: const Text('Done'),
                    ),
                    // Divider
                    VerticalDivider(
                      color: Theme.of(context).colorScheme.primary,
                      width: 20,
                      thickness: 2,
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<SignupCubit>().registered();
                        Navigator.of(context).pushReplacementNamed(
                          AppHomePage.routeName,
                        );
                      },
                      child: const Text('Skip'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ));
  }

  Future<void> _updateProfilePicture(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image.path);
      context.read<AccountCubit>().updatePhoto(imageFile);
    }
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    AccountField field,
    String value,
    Function(AccountField, String?, AccountAction) callEventFunction,
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
    AccountField profileField,
    String currentValue,
    Function(AccountField, String?, AccountAction) callEventFunction,
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
              callEventFunction(profileField, value, AccountAction.typing);
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
                    AccountAction.saving); // Use controller.text here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
