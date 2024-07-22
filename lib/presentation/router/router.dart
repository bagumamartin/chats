import 'package:flutter/material.dart';

import 'package:chats/presentation/pages/user/user_profile_pages.dart';
import 'package:chats/presentation/pages/chats/chats_pages.dart';
import 'package:chats/presentation/pages/auth/auth_pages.dart';
import 'package:chats/presentation/pages/app/app_pages.dart';

class AppRouter {
  static AppRouter? _instance;
  bool _authenticated;

  AppRouter._internal() : _authenticated = false;

  factory AppRouter() {
    _instance ??= AppRouter._internal();
    return _instance!;
  }

  void setAuthenticated(bool authenticated) {
    _authenticated = authenticated;
  }

  Route generateRoute(
    RouteSettings routeSettings,
  ) {
    switch (_authenticated) {
      case true:
        switch (routeSettings.name) {
          case AppHomePage.routeName:
            return MaterialPageRoute(
              maintainState: false,
              builder: (context) => const AppHomePage(),
            );

          case AppSettingsPage.routeName:
            return MaterialPageRoute(
              builder: (context) => const AppSettingsPage(),
            );

          case AccountPage.routeName:
            return MaterialPageRoute(
              builder: (context) => const AccountPage(),
            );

          case UserProfilePage.routeName:
            return MaterialPageRoute(
              builder: (_) => const UserProfilePage(),
            );

          case ContactPage.routeName:
            return MaterialPageRoute(
              builder: (_) => const ContactPage(),
            );

          case ChatPage.routeName:
            // Extract the arguments
            final args = routeSettings.arguments as Map<String, dynamic>?;
            final userId = args?['userId'] as String;
            final userName = args?['userName'] as String;

            return MaterialPageRoute(
              builder: (_) => ChatPage(
                receiverId: userId,
                receiverName: userName,
              ),
            );

          default:
            return _errorRoute();
        }
      case false:
        switch (routeSettings.name) {
          case SplashScreen.routeName:
            return MaterialPageRoute(
              builder: (context) => const SplashScreen(),
            );

          case LoginPage.routeName:
            return MaterialPageRoute(
              builder: (context) => const LoginPage(),
            );

          case RegisterPage.routeName:
            return MaterialPageRoute(
              builder: (_) => const RegisterPage(),
            );

          default:
            return MaterialPageRoute(
              builder: (context) => const LoginPage(),
            );
        }
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('error'),
        ),
      ),
      settings: const RouteSettings(name: '/error'),
    );
  }
}
