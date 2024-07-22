part of 'auth_bloc.dart';

enum AuthStatus {
  unknown,
  authenticated,
  modifying,
  modified,
  unauthenticated,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthUser? authUser;
  final User? user;

  const AuthState._({
    this.authUser,
    this.user,
    this.status = AuthStatus.unknown,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated({
    required AuthUser authUser,
    required User user,
  }) : this._(
          status: AuthStatus.authenticated,
          authUser: authUser,
          user: user,
        );

  const AuthState.modifying({
    required AuthUser authUser,
    required User user,
  }) : this._(
          status: AuthStatus.modifying,
          authUser: authUser,
          user: user,
        );

  const AuthState.modified({
    required AuthUser authUser,
    required User user,
  }) : this._(
          status: AuthStatus.modifying,
          authUser: authUser,
          user: user,
        );

  const AuthState.unauthenticated()
      : this._(
          status: AuthStatus.unauthenticated,
        );

  @override
  List<Object?> get props => [status, authUser, user];
}

// class AuthInitial extends AuthState {}