import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class BaseAuthRepository {
  Stream<auth.User?> get user;

  Future<auth.User?> signUp({
    required String email,
    required String password,
  });

  Future<void> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<String?> updateDisplayName({required String displayName});

  Future<String?> updatePhoto({required File imageFile});

  Future<String?> updatePhoneNumber({required String phoneNumber});

  Future<String?> updateEmail({required String email});
}
