part of 'users_cubit.dart';

enum UsersStatus { initial, loading, loaded, error }

class UsersState extends Equatable {
  final Stream<List<User>> users;
  final UsersStatus status;

  const UsersState({
    required this.users,
    required this.status,
  });

  factory UsersState.initial() {
    return const UsersState(
      users: Stream<List<User>>.empty(),
      status: UsersStatus.initial,
    );
  }

  UsersState copyWith({
    Stream<List<User>>? users,
    UsersStatus? status,
  }) {
    return UsersState(
      users: users ?? this.users,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [users, status];
}
