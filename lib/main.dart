// I learnt coding in dart and building flutter applications from various tutorials on youtube.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:chats/firebase_options.dart';
import 'package:chats/bloc_config.dart';

import 'package:chats/data/chat_data.dart';
import 'package:chats/data/auth_data.dart';
import 'package:chats/data/user_data.dart';

import 'package:chats/logic/app/theme_logic.dart';
import 'package:chats/logic/chat/chat_logic.dart';
import 'package:chats/logic/user/user_logic.dart';
import 'package:chats/logic/auth/auth_logic.dart';

import 'package:chats/presentation/router/router.dart';
import 'package:chats/presentation/pages/auth/auth_pages.dart';
import 'package:chats/presentation/pages/chats/chats_pages.dart';
import 'package:chats/presentation/pages/app/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Chats());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = AppBlocObserver();
}

final navigatorKey = GlobalKey<NavigatorState>();

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  // This widget is the root of the application.
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    // Check for Firebase initialization after WidgetsFlutterBinding.ensureInitialized()
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        if (Firebase.apps.isNotEmpty) {
          initialized = true;
        }
      });
    });

    if (!initialized) {
      return const MaterialApp(
        home: SplashScreen(),
      );
    }

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider(
          create: (context) => ChatRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeCubit(),
          ),
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => SigninCubit(
              authRepository: context.read<AuthRepository>(),
              authBloc: context.read<AuthBloc>(),
            ),
          ),
          BlocProvider(
            create: (context) => SignupCubit(
              // context.read<AuthRepository>(),
              authRepository: context.read<AuthRepository>(),
              authBloc: context.read<AuthBloc>(),
            ),
          ),
          BlocProvider(
            create: (context) => SignoutCubit(
              context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => AccountCubit(
              authRepository: context.read<AuthRepository>(),
              userRepository: context.read<UserRepository>(),
              authBloc: context.read<AuthBloc>(),
            ),
          ),
          BlocProvider(
            create: (context) => UserCubit(
              context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => UsersCubit(
              userRepository: context.read<UserRepository>(),
              authBloc: context.read<AuthBloc>(),
            ),
          ),
          BlocProvider(
            create: (context) => ProfileCubit(
              authBloc: context.read<AuthBloc>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ChatBloc(
              authBloc: context.read<AuthBloc>(),
              chatRepository: context.read<ChatRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => UsersCubit(
              userRepository: context.read<UserRepository>(),
              authBloc: context.read<AuthBloc>(),
            ),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themestate) {
            return MaterialApp(
              title: 'Connect with loved ones',
              theme: themestate.theme,
              onGenerateRoute: (routeSettings) {
                return AppRouter().generateRoute(routeSettings);
              },
              home: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state.status != AuthStatus.unknown) {
                    AppRouter().setAuthenticated(
                        state.status == AuthStatus.authenticated);
                  }
                },
                builder: (context, state) {
                  // Check the authentication state and return the appropriate UI
                  if (state.status == AuthStatus.unknown) {
                    return const SplashScreen();
                  } else if (state.status == AuthStatus.authenticated &&
                      context.read<SignupCubit>().state.status ==
                          SignupStatus.registering) {
                    return const AccountPage();
                  } else if (state.status ==
                          AuthStatus
                              .authenticated //&& context.read<SigninCubit>().state.status == SigninStatus.success
                      ) {
                    return const AppHomePage();
                  } else {
                    return const AuthNavigator();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        if (settings.name == RegisterPage.routeName) {
          return MaterialPageRoute(builder: (_) => const RegisterPage());
        }
        // Default to LoginPage
        return MaterialPageRoute(builder: (_) => const LoginPage());
      },
    );
  }
}
