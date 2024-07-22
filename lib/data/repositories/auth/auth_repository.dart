import 'dart:io';

import 'package:chats/data/providers/auth/auth_provider.dart';
import 'package:chats/data/repositories/auth/base_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthRepository extends BaseAuthRepository {
  final AuthProvider _authProvider;

  AuthRepository({
    // auth.FirebaseAuth? firebaseAuth,
    AuthProvider? authProvider,
  }) : _authProvider = authProvider ?? AuthProvider();

  @override
  Future<auth.User?> signUp({
    required String email,
    required String password,
  }) async {
    return await _authProvider.signUpCall(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    return await _authProvider.signInCall(
      email: email,
      password: password,
    );
  }

  @override
  Stream<auth.User?> get user => _authProvider.userChangesCall;

  @override
  Future<void> signOut() async {
    await _authProvider.signOutCall();
  }

  @override
  Future<String?> updateDisplayName({required String displayName}) async {
    return await _authProvider.updateAuthDisplayNameCall(displayName);
  }

  @override
  Future<String?> updateEmail({required String email}) async {
    return await _authProvider.updateAuthEmailCall(email);
  }

  @override
  Future<String?> updatePhoneNumber({required String phoneNumber}) async {
    return await _authProvider.updateAuthPhoneNumberCall(phoneNumber);
  }

  @override
  Future<String?> updatePhoto({required File imageFile}) async {
    return await _authProvider.updateAuthPhotoCall(imageFile);
  }
}
