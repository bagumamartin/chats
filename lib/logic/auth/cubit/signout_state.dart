part of 'signout_cubit.dart';

enum SignoutStatus { initial, signingOut, success, error }

class SignoutState extends Equatable {
  final String? message;

  const SignoutState({
    this.message,
  });

  const SignoutState.initial([this.message]);

  const SignoutState.signingOut([this.message]);

  const SignoutState.success([this.message]);

  const SignoutState.error({this.message});

  @override
  List<Object?> get props => [message];
}

// class SignoutInitial extends SignoutState {}