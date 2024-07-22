import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:chats/data/auth_data.dart';

part 'signout_state.dart';

class SignoutCubit extends Cubit<SignoutState> {
  // SignoutCubit() : super(const SignoutState.initial());

  final AuthRepository _authRepository;

  SignoutCubit(this._authRepository) : super(const SignoutState.initial());

  Future<void> signOut() async {
    emit(const SignoutState.initial());
    try {
      emit(const SignoutState.signingOut());
      await _authRepository.signOut();
      emit(const SignoutState.success());
    } on Exception catch (e) {
      emit(SignoutState.error(message: '$e'));
    }
  }
}
