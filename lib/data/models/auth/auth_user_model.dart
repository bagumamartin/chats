import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthUser extends Equatable {
  final auth.User authUser;

  const AuthUser({
    required this.authUser,
  });

  String? get id => authUser.uid;
  String? get displayName => authUser.displayName;
  String? get email => authUser.email;
  String? get phoneNumber => authUser.phoneNumber;
  String? get photoURL => authUser.photoURL;

  factory AuthUser.fromUser(auth.User user) {
    return AuthUser(authUser: user);
  }

  AuthUser copyWith({
    String? displayName,
    String? email,
    auth.PhoneAuthCredential? phoneNumber,
    String? photoURL,
  }) {
    if (displayName != null) authUser.updateDisplayName(displayName);
    if (phoneNumber != null) authUser.updatePhoneNumber(phoneNumber);
    if (photoURL != null) authUser.updatePhotoURL(photoURL);
    if (email != null) authUser.verifyBeforeUpdateEmail(email);
    return AuthUser(
      authUser: authUser,
    );
  }

  @override
  String toString() {
    return 'AuthUser{uid: $id, displayName: $displayName, email: $email, phoneNumber: $phoneNumber, photoURL: $photoURL}';
  }

  @override
  List<Object?> get props => [authUser.uid];
}
