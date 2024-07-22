import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:chats/data/models/user/user_model.dart';
import 'package:chats/data/repositories/user/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;

  UserCubit(this._userRepository) : super(UserState.initial());

  void userIdChanged(String userIdValue) {
    emit(
      state.copyWith(
        userId: userIdValue,
        status: UserStatus.initial,
      ),
    );
  }

  void userNameChanged(String userNameValue) {
    emit(
      state.copyWith(
        username: userNameValue,
        status: UserStatus.initial,
      ),
    );
  }

  Future<void> createUser() async {
    if (state.status == UserStatus.loading) return;
    emit(state.copyWith(status: UserStatus.loading));
    try {
      final user = User(
        id: state.userId,
        fullName: state.username,
      );
      await _userRepository.createUser(user: user);
      emit(state.copyWith(status: UserStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.error));
    }
  }

  Future<void> updateUser() async {
    if (state.status == UserStatus.loading) return;
    emit(state.copyWith(status: UserStatus.loading));
    try {
      final user = User(
        id: state.userId,
        fullName: state.username,
      );
      await _userRepository.updateUser(user: user);
      emit(state.copyWith(status: UserStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.error));
    }
  }

  Future<void> getUser({required String userId}) async {
    if (state.users[userId]?.status == UserStatus.loading) return;

    emit(state.copyWith(
      users: {
        ...state.users,
        userId: UserData(id: userId, username: '', status: UserStatus.loading)
      },
    ));

    try {
      final user = await _userRepository.getUser(userId: userId).first;
      emit(state.copyWith(
        users: {
          ...state.users,
          userId: UserData(
              id: userId, username: user.fullName, status: UserStatus.loaded)
        },
      ));
    } catch (e) {
      emit(state.copyWith(
        users: {
          ...state.users,
          userId: UserData(id: userId, username: '', status: UserStatus.error)
        },
      ));
    }
  }
}
