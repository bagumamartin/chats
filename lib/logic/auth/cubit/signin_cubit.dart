import 'package:bloc/bloc.dart';
import 'package:chats/data/auth_data.dart';
import 'package:chats/data/repositories/auth/auth_repository.dart';
import 'package:chats/logic/auth/auth_logic.dart';
import 'package:equatable/equatable.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  // SigninCubit() : super(SigninInitial());

  final AuthRepository _authRepository;
  final AuthBloc _authBloc;

  SigninCubit({
    required AuthRepository authRepository,
    required AuthBloc authBloc,
  })  : _authRepository = authRepository,
        _authBloc = authBloc,
        super(SigninState.initial()) {
    if (_authBloc.state.status == AuthStatus.authenticated) {
      emit(state.copyWith(status: SigninStatus.success));
    }
  }

  void emailChanged(String emailValue) {
    emit(
      state.copyWith(
        email: emailValue,
        status: SigninStatus.initial,
      ),
    );
  }

  void passwordChanged(String passwordValue) {
    emit(
      state.copyWith(
        password: passwordValue,
        status: SigninStatus.initial,
      ),
    );
  }

  Future<void> signinwithCredentials() async {
    if (state.status == SigninStatus.submitting) return;
    emit(state.copyWith(status: SigninStatus.submitting));
    try {
      await _authRepository.signIn(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: SigninStatus.success));
    } catch (e) {
      emit(state.copyWith(status: SigninStatus.error));
      throw Exception(e);
    }
  }
}
