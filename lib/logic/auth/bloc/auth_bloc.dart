import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chats/data/models/auth/auth_user_model.dart';
import 'package:chats/data/models/user/user_model.dart';
import 'package:chats/data/repositories/auth/auth_repository.dart';
import 'package:chats/data/repositories/user/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  StreamSubscription<auth.User?>? _authUserSubscrption;
  StreamSubscription<User?>? _userSubscription;

  AuthBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(
          const AuthState.unknown(),
        ) {
    on<AuthUserChanged>(_onAuthUserChanged);
    on<AuthUserModified>(_onAuthUserModified);

    _authUserSubscrption = _authRepository.user.listen((authUser) {
      if (authUser != null && state.status != AuthStatus.modifying) {
        _userRepository
            .getUser(
          userId: authUser.uid,
        )
            .listen((user) {
          add(
            AuthUserChanged(
              authUser: AuthUser.fromUser(authUser),
              user: user,
            ),
          );
        });
      } else {
        add(const AuthUserChanged(authUser: null));
      }
    });
  }

  void _onAuthUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) {
    event.authUser != null
        ? emit(AuthState.authenticated(
            authUser: event.authUser!,
            user: event.user!,
          ))
        : emit(const AuthState.unauthenticated());
  }

  void _onAuthUserModified(
    AuthUserModified event,
    Emitter<AuthState> emit,
  ) {
    if (event.authUser != null) {
      switch (event.status == AuthModificationStatus.modified &&
          state.status == AuthStatus.modifying) {
        case true:
          switch (event.field) {
            case AuthModificationField.displayName:
              _authRepository.updateDisplayName(
                displayName: event.authUser!.displayName!,
              );
              break;
            case AuthModificationField.email:
              _authRepository.updateEmail(
                email: event.authUser!.email!,
              );
              break;
            case AuthModificationField.phoneNumber:
              _authRepository.updatePhoneNumber(
                phoneNumber: event.authUser!.phoneNumber!,
              );
              break;
            case AuthModificationField.photoURL:
              // _authRepository.updatePhotoURL(
              //   photoURL: event.authUser!.photoURL,
              // );
              break;
            case null:
              break;
          }
          emit(AuthState.modified(
            authUser: event.authUser!,
            user: event.user!,
          ));
        case false:
          emit(AuthState.modifying(
            authUser: state.authUser!,
            user: state.user!,
          ));
      }
    }
  }

  @override
  Future<void> close() {
    _authUserSubscrption?.cancel();
    _userSubscription?.cancel();
    return super.close();
  }
}
