import 'package:bloc/bloc.dart';
import 'package:chats/data/models/user/user_model.dart';
import 'package:chats/data/repositories/user/user_repository.dart';
import 'package:chats/logic/auth/auth_logic.dart';
import 'package:equatable/equatable.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final UserRepository _userRepository;
  final AuthBloc _authBloc;

  // UsersCubit(this._userRepository) : super(UsersState.initial());

  UsersCubit({
    required UserRepository userRepository,
    required AuthBloc authBloc,
  })  : _userRepository = userRepository,
        _authBloc = authBloc,
        super(UsersState.initial());

  void getUsers() {
    emit(state.copyWith(status: UsersStatus.loading));
    try {
      final Stream<List<User>> users =
          _userRepository.getUsers(userId: _authBloc.state.user!.id!);
      emit(state.copyWith(users: users, status: UsersStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: UsersStatus.error));
    }
  }
}
