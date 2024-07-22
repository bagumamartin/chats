part of 'account_cubit.dart';

// sealed class AccountState extends Equatable {
//   const AccountState();

//   @override
//   List<Object> get props => [];
// }

// final class AccountInitial extends AccountState {}

enum AccountStatus {
  initial,
  loading,
  loaded,
  changing,
  updating,
  updated,
  error
}

// AccountState
class AccountState extends Equatable {
  final AccountStatus status;
  final AuthUser? authUser;
  final String? errorMessage;

  const AccountState({
    required this.status,
    this.authUser,
    this.errorMessage,
  });

  factory AccountState.initial() {
    return const AccountState(
      status: AccountStatus.initial,
      authUser: null,
    );
  }

  AccountState copyWith({
    AccountStatus? status,
    AuthUser? authUser,
  }) {
    return AccountState(
      status: status ?? this.status,
      authUser: authUser ?? this.authUser,
    );
  }

  // If status is error, then the error must be provided
  AccountState copyWithError({
    required String errorMessage,
  }) {
    return AccountState(
      status: AccountStatus.error,
      authUser: authUser,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        authUser,
        authUser?.displayName,
        authUser?.email,
        authUser?.phoneNumber,
        authUser?.photoURL,
        status,
      ];
}
