// ignore_for_file: unused_field

import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chats/data/models/auth/auth_user_model.dart';
import 'package:chats/data/repositories/auth/auth_repository.dart';
import 'package:chats/data/repositories/user/user_repository.dart';
import 'package:chats/logic/auth/auth_logic.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'account_state.dart';

// class AccountCubit extends Cubit<AccountState> {
//   AccountCubit() : super(AccountInitial());
// }

enum AccountAction {
  initiating,
  typing,
  saving,
}

enum AccountField {
  displayName,
  email,
  phoneNumber,
}

class AccountCubit extends Cubit<AccountState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final AuthBloc _authBloc;
  late StreamSubscription<User?>? _authUserSubscrption;

  AccountCubit({
    required AuthRepository authRepository,
    required UserRepository userRepository,
    required AuthBloc authBloc,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        _authBloc = authBloc,
        super(AccountState.initial()) {
    emit(state.copyWith(status: AccountStatus.loading));

    if (_authBloc.state.status == AuthStatus.authenticated) {
      emit(state.copyWith(
        status: AccountStatus.loaded,
        authUser: _authBloc.state.authUser!,
      ));
    }

    _authUserSubscrption = _authRepository.user.listen((authUser) {
      if (authUser != null) {
        emit(state.copyWith(
          status: AccountStatus.updated,
          authUser: AuthUser.fromUser(authUser),
        ));
      } else {
        emit(state.copyWith(status: AccountStatus.initial));
      }
    });
  }

  Future<void> updateAccount({
    required AccountAction action,
    required AccountField field,
    String? value,
  }) async {
    switch (field) {
      case AccountField.displayName:
        if (action == AccountAction.saving) {
          await updateDisplayName(value!);
        }
        break;
      case AccountField.email:
        if (action == AccountAction.saving) {
          await updateEmail(value!);
        }
        break;
      case AccountField.phoneNumber:
        if (action == AccountAction.saving) {
          await updatePhoneNumber(value!);
        }
        break;
    }
  }

  Future<void> updateDisplayName(String displayName) async {
    emit(state.copyWith(status: AccountStatus.updating));
    try {
      final updatedDisplayName =
          await _authRepository.updateDisplayName(displayName: displayName);
      if (updatedDisplayName != null) {
        emit(state.copyWith(
          authUser: state.authUser?.copyWith(displayName: updatedDisplayName),
          status: AccountStatus.updated,
        ));
      } else {
        emit(
            state.copyWithError(errorMessage: 'Failed to update display name'));
      }
    } catch (e) {
      emit(state.copyWithError(errorMessage: e.toString()));
    }
  }

  Future<void> updateEmail(String email) async {
    emit(state.copyWith(status: AccountStatus.updating));
    try {
      final updatedEmail = await _authRepository.updateEmail(email: email);
      if (updatedEmail != null) {
        // ToDo: Update email in user collection
        emit(state.copyWith(
          authUser: state.authUser?.copyWith(email: updatedEmail),
          status: AccountStatus.updated,
        ));
      } else {
        emit(state.copyWithError(errorMessage: 'Failed to update email'));
      }
    } catch (e) {
      emit(state.copyWithError(errorMessage: e.toString()));
    }
  }

  Future<void> updatePhoneNumber(String phoneNumber) async {
    emit(state.copyWith(status: AccountStatus.updating));
    try {
      final updatedPhoneNumber =
          await _authRepository.updatePhoneNumber(phoneNumber: phoneNumber);
      if (updatedPhoneNumber != null) {
        emit(state.copyWith(
          authUser: state.authUser?.copyWith(
              phoneNumber: updatedPhoneNumber as PhoneAuthCredential),
          status: AccountStatus.updated,
        ));
      } else {
        emit(
            state.copyWithError(errorMessage: 'Failed to update phone number'));
      }
    } catch (e) {
      emit(state.copyWithError(errorMessage: e.toString()));
    }
  }

  Future<void> updatePhoto(File imageFile) async {
    emit(state.copyWith(status: AccountStatus.updating));
    try {
      final updatedPhotoURL =
          await _authRepository.updatePhoto(imageFile: imageFile);
      if (updatedPhotoURL != null) {
        emit(state.copyWith(
          authUser: state.authUser?.copyWith(photoURL: updatedPhotoURL),
          status: AccountStatus.updated,
        ));
      } else {
        emit(state.copyWithError(errorMessage: 'Failed to update photo'));
      }
    } catch (e) {
      emit(state.copyWithError(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authUserSubscrption?.cancel();
    return super.close();
  }
}
