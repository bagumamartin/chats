import 'package:bloc/bloc.dart';
import 'package:chats/data/repositories/auth/auth_repository.dart';
import 'package:chats/logic/auth/auth_logic.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  // SignupCubit() : super(SignupInitial());

  final AuthRepository _authRepository;
  final AuthBloc _authBloc;

  SignupCubit({
    required AuthRepository authRepository,
    required AuthBloc authBloc,
  })  : _authRepository = authRepository,
        _authBloc = authBloc,
        super(SignupState.initial()) {
    // if (_authBloc.state.status == AuthStatus.authenticated) {
    //   emit(state.copyWith(status: SignupStatus.registering));
    // }
  }

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: value,
        status: SignupStatus.initial,
      ),
    );
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        status: SignupStatus.initial,
      ),
    );
  }

  void confirmPasswordChanged(String value) {
    emit(
      state.copyWith(
        confirmPassword: value,
        status: SignupStatus.initial,
      ),
    );
  }

  Future<void> signupFormSubmitted() async {
    if (state.status == SignupStatus.submitting) return;
    if (state.email == null ||
        state.password == null ||
        state.password != state.confirmPassword) return;
    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      var user = await _authRepository.signUp(
        email: state.email!,
        password: state.password!,
      );

      emit(state.copyWith(
        status: SignupStatus.registering,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(status: SignupStatus.error));
      rethrow;
    }
  }

  void registered() {
    emit(state.copyWith(status: SignupStatus.success));
  }
}
