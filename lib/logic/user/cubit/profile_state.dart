part of 'profile_cubit.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  changing,
  updating,
  updated,
  error
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final User? user;
  final String? biography;

  const ProfileState({
    required this.status,
    this.biography,
    this.user,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      status: ProfileStatus.initial,
      user: null,
      biography: null,
    );
  }

  ProfileState copyWith({
    ProfileStatus? status,
    User? user,
    String? biography,
  }) {
    return ProfileState(
      status: status ?? this.status,
      biography: biography ?? this.biography,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [user, status, biography];
}

// class ProfileInitial extends ProfileState {}

// class ProfileUpdateSuccess extends ProfileState {
//   final User user;

//   const ProfileUpdateSuccess(this.user);

//   @override
//   List<Object?> get props => [user];
// }

// class ProfileError extends ProfileState {
//   final String message;

//   const ProfileError(this.message);

//   @override
//   List<Object?> get props => [message];
// }

// final class ProfileInitial extends ProfileState {}