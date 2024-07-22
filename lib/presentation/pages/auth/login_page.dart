import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "package:chats/logic/auth/auth_logic.dart";
import "package:chats/presentation/components/app_button.dart";
import "package:chats/presentation/components/app_textfield.dart";
import "package:chats/presentation/pages/auth/auth_pages.dart";

class LoginPage extends StatelessWidget {
  static const String routeName = '/login';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Login method
    void login() {
      try {
        context.read<SigninCubit>().signinwithCredentials();
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

                    const SizedBox(
                      height: 50,
                    ),

                    // Welcome back message
                    Text(
                      "Welcome back, you've been missed!",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    // Email textfield
                    AppTextField(
                      labelText: "Email",
                      hintText: "Enter email...",
                      obsecureText: false,
                      onChanged: (email) =>
                          context.read<SigninCubit>().emailChanged(email),
                    ),

                    const SizedBox(
                      height: 10.0,
                    ),

                    // Password textfield
                    AppTextField(
                      labelText: "Password",
                      hintText: "Enter password",
                      obsecureText: true,
                      onChanged: (password) =>
                          context.read<SigninCubit>().passwordChanged(password),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    // Login button
                    AppButton(
                      onTap: login,
                      label: "Log in",
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    // Register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Not registered? ",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                            context,
                            RegisterPage.routeName,
                          ),
                          child: Text(
                            " Register now.",
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


// class LoginPage extends StatelessWidget {
//   static const String routeName = '/login';

//   const LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Login method
//     void login() {
//       try {
//         context.read<SigninCubit>().signinwithCredentials();
//       } catch (e) {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text(e.toString()),
//           ),
//         );
//       }
//     }

//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Logo
//           Icon(
//             Icons.message,
//             size: 60,
//             color: Theme.of(context).colorScheme.primary,
//           ),

//           const SizedBox(
//             height: 50,
//           ),

//           // Welcome back message
//           Text(
//             "Welcome back, you've been missed!",
//             style: TextStyle(
//               color: Theme.of(context).colorScheme.primary,
//               fontSize: 16,
//             ),
//           ),

//           const SizedBox(
//             height: 25,
//           ),

//           // Email textfield
//           AppTextField(
//             labelText: "Email",
//             hintText: "Enter email...",
//             obsecureText: false,
//             onChanged: (email) =>
//                 context.read<SigninCubit>().emailChanged(email),
//           ),

//           const SizedBox(
//             height: 10.0,
//           ),

//           // Password textfield
//           AppTextField(
//             labelText: "Password",
//             hintText: "Enter password",
//             obsecureText: true,
//             onChanged: (password) =>
//                 context.read<SigninCubit>().passwordChanged(password),
//           ),

//           const SizedBox(
//             height: 25,
//           ),

//           // Login button
//           AppButton(
//             onTap: login,
//             label: "Log in",
//           ),

//           const SizedBox(
//             height: 25,
//           ),

//           // Register now
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "Not registered? ",
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () =>
//                     Navigator.popAndPushNamed(context, RegisterPage.routeName),
//                 child: Text(
//                   " Register now.",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
