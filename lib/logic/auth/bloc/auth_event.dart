part of 'auth_bloc.dart';

enum AuthModificationStatus {
  modifying,
  modified,
}

enum AuthModificationField {
  displayName,
  email,
  phoneNumber,
  photoURL,
}

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthUserChanged extends AuthEvent {
  final AuthUser? authUser;
  final User? user;

  const AuthUserChanged({
    required this.authUser,
    this.user,
  });

  @override
  List<Object?> get props => [authUser, user];
}

class AuthUserModified extends AuthEvent {
  final AuthModificationStatus status;
  final AuthModificationField? field;
  final AuthUser? authUser;
  final User? user;

  const AuthUserModified({
    required this.status,
    this.field,
    this.authUser,
    this.user,
  });

  @override
  List<Object?> get props => [authUser, user, status];
}
