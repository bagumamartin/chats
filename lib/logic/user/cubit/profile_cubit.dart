import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:chats/logic/auth/auth_logic.dart';
import 'package:chats/data/models/user/user_model.dart';
import 'package:chats/data/user_data.dart';

part 'profile_state.dart';

// class ProfileCubit extends Cubit<ProfileState> {
//   ProfileCubit() : super(ProfileInitial());
// }

enum ProfileAction {
  initiating,
  typing,
  saving,
}

enum ProfileField {
  fullName,
  email,
  address,
  city,
  country,
  zipCode,
}

class ProfileCubit extends Cubit<ProfileState> {
  final AuthBloc _authBloc;
  final UserRepository _userRepository;
  late StreamSubscription _authSubscription;
  late StreamSubscription _profileUpdateSubscription;

  ProfileCubit({
    required AuthBloc authBloc,
    required UserRepository userRepository,
  })  : _authBloc = authBloc,
        _userRepository = userRepository,
        super(
          ProfileState.initial(),
        ) {
    if (_authBloc.state.status == AuthStatus.authenticated) {
      getUserProfile(_authBloc.state.user!.id!);
    }
    _authSubscription = _authBloc.stream.listen((authState) async {
      if (authState.status == AuthStatus.authenticated) {
        // Ensure initialization only once:
        if (state.status == ProfileStatus.initial) {
          await getUserProfile(authState.user!.id!);
        }
      }
    });
    _profileUpdateSubscription = stream.listen((state) {
      if (state.status == ProfileStatus.updated) {
        final userId = _authBloc.state.user!.id!;
        getUserProfile(userId);
      }
    });
  }

  Future<void> updateProfile({
    required ProfileField field,
    String? value,
    required ProfileAction action,
  }) async {
    switch (field) {
      case ProfileField.fullName:
        await changeFullName(
          value: value!,
          action: action,
        );
        break;
      case ProfileField.email:
        await changeEmail(
          value: value!,
          action: action,
        );
        break;
      case ProfileField.address:
        await changeAddress(
          value: value!,
          action: action,
        );
        break;
      case ProfileField.city:
        await changeCity(
          value: value!,
          action: action,
        );
        break;
      case ProfileField.country:
        await changeCountry(
          value: value!,
          action: action,
        );
        break;
      case ProfileField.zipCode:
        await changeZipCode(
          value: value!,
          action: action,
        );
        break;
    }
  }

  Future<void> getUserProfile(String userId) async {
    try {
      if (state.status == ProfileStatus.loading) return;
      emit(state.copyWith(status: ProfileStatus.loading));
      User user = await _userRepository.getUser(userId: userId).first;
      emit(state.copyWith(status: ProfileStatus.loaded, user: user));
    } catch (e) {
      emit(
          state.copyWith(status: ProfileStatus.error, biography: e.toString()));
      rethrow;
    }
  }

  Future<void> changeFullName({
    required String value,
    required ProfileAction action,
  }) async {
    switch (action) {
      case ProfileAction.initiating:
        emit(
          state.copyWith(
            user: state.user!.copyWith(fullName: value),
            status: ProfileStatus.loading,
          ),
        );
        break;
      case ProfileAction.typing:
        emit(
          state.copyWith(
            user: state.user!.copyWith(fullName: value),
            status: ProfileStatus.changing,
          ),
        );
        break;
      case ProfileAction.saving:
        emit(
          state.copyWith(
            user: state.user!.copyWith(fullName: value),
            status: ProfileStatus.updating,
          ),
        );
        // Persist to firebase
        await _userRepository.updateUser(user: state.user!);
        emit(
          state.copyWith(
            user: state.user!.copyWith(fullName: value),
            status: ProfileStatus.updated,
          ),
        );
        break;
    }
  }

  Future<void> changeEmail({
    required String value,
    required ProfileAction action,
  }) async {
    switch (action) {
      case ProfileAction.initiating:
        emit(
          state.copyWith(
            user: state.user!.copyWith(email: value),
            status: ProfileStatus.loading,
          ),
        );
        break;
      case ProfileAction.typing:
        emit(
          state.copyWith(
            user: state.user!.copyWith(email: value),
            status: ProfileStatus.changing,
          ),
        );
        break;
      case ProfileAction.saving:
        emit(
          state.copyWith(
            user: state.user!.copyWith(email: value),
            status: ProfileStatus.updating,
          ),
        );
        // Persist to firebase
        await _userRepository.updateUser(user: state.user!);
        emit(
          state.copyWith(
            user: state.user!.copyWith(email: value),
            status: ProfileStatus.updated,
          ),
        );
        break;
    }
  }

  Future<void> changeAddress({
    required String value,
    required ProfileAction action,
  }) async {
    switch (action) {
      case ProfileAction.initiating:
        emit(
          state.copyWith(
            user: state.user!.copyWith(address: value),
            status: ProfileStatus.loading,
          ),
        );
        break;
      case ProfileAction.typing:
        emit(
          state.copyWith(
            user: state.user!.copyWith(address: value),
            status: ProfileStatus.changing,
          ),
        );
        break;
      case ProfileAction.saving:
        emit(
          state.copyWith(
            user: state.user!.copyWith(address: value),
            status: ProfileStatus.updating,
          ),
        );
        // Persist to firebase
        await _userRepository.updateUser(user: state.user!);
        emit(
          state.copyWith(
            user: state.user!.copyWith(address: value),
            status: ProfileStatus.updated,
          ),
        );
        break;
    }
  }

  Future<void> changeCity({
    required String value,
    required ProfileAction action,
  }) async {
    switch (action) {
      case ProfileAction.initiating:
        emit(
          state.copyWith(
            user: state.user!.copyWith(city: value),
            status: ProfileStatus.loading,
          ),
        );
        break;
      case ProfileAction.typing:
        emit(
          state.copyWith(
            user: state.user!.copyWith(city: value),
            status: ProfileStatus.changing,
          ),
        );
        break;
      case ProfileAction.saving:
        emit(
          state.copyWith(
            user: state.user!.copyWith(city: value),
            status: ProfileStatus.updating,
          ),
        );
        // Persist to firebase
        await _userRepository.updateUser(user: state.user!);
        emit(
          state.copyWith(
            user: state.user!.copyWith(city: value),
            status: ProfileStatus.updated,
          ),
        );
        break;
    }
  }

  Future<void> changeCountry({
    required String value,
    required ProfileAction action,
  }) async {
    switch (action) {
      case ProfileAction.initiating:
        emit(
          state.copyWith(
            user: state.user!.copyWith(country: value),
            status: ProfileStatus.loading,
          ),
        );
        break;
      case ProfileAction.typing:
        emit(
          state.copyWith(
            user: state.user!.copyWith(country: value),
            status: ProfileStatus.changing,
          ),
        );
        break;
      case ProfileAction.saving:
        emit(
          state.copyWith(
            user: state.user!.copyWith(country: value),
            status: ProfileStatus.updating,
          ),
        );
        // Persist to firebase
        await _userRepository.updateUser(user: state.user!);
        emit(
          state.copyWith(
            user: state.user!.copyWith(country: value),
            status: ProfileStatus.updated,
          ),
        );
        break;
    }
  }

  Future<void> changeZipCode({
    required String value,
    required ProfileAction action,
  }) async {
    switch (action) {
      case ProfileAction.initiating:
        emit(
          state.copyWith(
            user: state.user!.copyWith(zipCode: value),
            status: ProfileStatus.loading,
          ),
        );
        break;
      case ProfileAction.typing:
        emit(
          state.copyWith(
            user: state.user!.copyWith(zipCode: value),
            status: ProfileStatus.changing,
          ),
        );
        break;
      case ProfileAction.saving:
        emit(
          state.copyWith(
            user: state.user!.copyWith(zipCode: value),
            status: ProfileStatus.updating,
          ),
        );
        // Persist to firebase
        await _userRepository.updateUser(user: state.user!);
        emit(
          state.copyWith(
            user: state.user!.copyWith(zipCode: value),
            status: ProfileStatus.updated,
          ),
        );
        break;
    }
  }

  Future<void> updateUserProfile() async {
    if (state.status == ProfileStatus.updating) return;
    emit(state.copyWith(status: ProfileStatus.updating));
    try {
      User updatedUser = await _userRepository.updateUser(user: state.user!);
      emit(state.copyWith(
        status: ProfileStatus.updated,
        user: updatedUser,
      ));
    } catch (e) {
      emit(
          state.copyWith(status: ProfileStatus.error, biography: e.toString()));
      rethrow;
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _profileUpdateSubscription.cancel();
    return super.close();
  }
}
