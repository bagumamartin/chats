part of 'user_cubit.dart';

enum UserStatus { initial, loading, loaded, error }

class UserData extends Equatable {
  final String id;
  final String username;
  final UserStatus status;

  const UserData(
      {required this.id, required this.username, required this.status});

  @override
  List<Object?> get props => [id, username, status];
}

class UserState extends Equatable {
  final String userId;
  final String username;
  final UserStatus status;
  final Map<String, UserData> users;

  const UserState({
    required this.userId,
    required this.username,
    required this.status,
    required this.users,
  });

  factory UserState.initial() {
    return const UserState(
      userId: '',
      username: '',
      status: UserStatus.initial,
      users: {},
    );
  }

  UserState copyWith({
    String? userId,
    String? username,
    UserStatus? status,
    Map<String, UserData>? users,
  }) {
    return UserState(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      status: status ?? this.status,
      users: users ?? this.users,
    );
  }

  @override
  List<Object?> get props => [userId, username, status, users];
}
