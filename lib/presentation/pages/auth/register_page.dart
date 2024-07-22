import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chats/logic/auth/auth_logic.dart';
import 'package:chats/presentation/components/app_button.dart';
import 'package:chats/presentation/components/app_textfield.dart';
import 'package:chats/presentation/pages/auth/auth_pages.dart';

class RegisterPage extends StatelessWidget {
  static const String routeName = '/register';

  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    void register() {
      try {
        context.read<SignupCubit>().signupFormSubmitted();
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Icon(
                      Icons.message,
                      size: 60,
                      color: Theme.of(context).colorScheme.primary,
                    ),

                    const SizedBox(height: 50),

                    // Welcome message
                    Text(
                      "Let's create an account for you!",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Email textfield
                    AppTextField(
                      labelText: "Email",
                      hintText: "Enter email...",
                      obsecureText: false,
                      onChanged: (email) =>
                          context.read<SignupCubit>().emailChanged(email),
                    ),

                    const SizedBox(height: 10),

                    // Password textfield
                    AppTextField(
                      labelText: "Password",
                      hintText: "Enter password",
                      obsecureText: true,
                      onChanged: (password) =>
                          context.read<SignupCubit>().passwordChanged(password),
                    ),

                    const SizedBox(height: 10),

                    // Confirm Password textfield
                    AppTextField(
                      labelText: "Confirm Password",
                      hintText: "Confirm password",
                      obsecureText: true,
                      onChanged: (password) => context
                          .read<SignupCubit>()
                          .confirmPasswordChanged(password),
                    ),

                    const SizedBox(height: 25),

                    // Register button
                    AppButton(
                      onTap: register,
                      label: "Register",
                    ),

                    const SizedBox(height: 25),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                            context,
                            LoginPage.routeName,
                          ),
                          child: Text(
                            "Log in now.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
