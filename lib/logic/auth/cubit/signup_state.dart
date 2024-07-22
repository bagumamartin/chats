part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, success, registering, error }

class SignupState extends Equatable {
  final String? email;
  final String? password;
  final String? confirmPassword;
  final SignupStatus status;
  final auth.User? user;

  const SignupState({
    this.email,
    this.password,
    this.confirmPassword,
    required this.status,
    this.user,
  });

  factory SignupState.initial() {
    return const SignupState(
      email: null,
      password: null,
      confirmPassword: null,
      status: SignupStatus.initial,
      user: null,
    );
  }

  SignupState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    SignupStatus? status,
    auth.User? user,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [email, password, confirmPassword, status, user];
}


// class SignupInitial extends SignupState {}