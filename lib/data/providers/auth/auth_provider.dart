import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class AuthProvider {
  final auth.FirebaseAuth _firebaseAuth;

  AuthProvider({
    auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  Future<auth.User?> signUpCall({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) => value.user);

      // final user = credential.user;
      // return user;
    } on auth.FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signInCall({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on auth.FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Stream<auth.User?> get userChangesCall => _firebaseAuth.userChanges();

  Future<void> signOutCall() async {
    try {
      await _firebaseAuth.signOut();
    } on auth.FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<String?> updateAuthDisplayNameCall(displayName) async {
    return _firebaseAuth.currentUser!
        .updateDisplayName(displayName)
        .then((value) => _firebaseAuth.currentUser!.displayName);
  }

  Future<String?> updateAuthPhoneNumberCall(phoneNumber) async {
    return _firebaseAuth.currentUser!
        .updatePhoneNumber(phoneNumber)
        .then((value) => _firebaseAuth.currentUser!.phoneNumber);
  }

  Future<String?> updateAuthEmailCall(email) async {
    return _firebaseAuth.currentUser!
        .verifyBeforeUpdateEmail(email)
        .then((value) => _firebaseAuth.currentUser!.email);
  }

  Future<String?> updateAuthPhotoCall(File imageFile) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('No user signed in');
      }

      final fileExtension = path.extension(imageFile.path).toLowerCase();
      final mimeType =
          lookupMimeType(imageFile.path) ?? 'application/octet-stream';

      const uuid = Uuid();
      final filename = '${currentUser.uid}_${uuid.v4()}$fileExtension';

      final storageRef = storage.FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(filename);

      // Upload the file
      final uploadTask = storageRef.putFile(
        imageFile,
        storage.SettableMetadata(contentType: mimeType),
      );

      // Monitor the upload task
      uploadTask.snapshotEvents
          .listen((storage.TaskSnapshot snapshot) {}, onError: (e) {});

      // Wait for the upload to complete
      await uploadTask;

      // Check if the file exists after upload
      try {
        await storageRef.getDownloadURL();
      } catch (e) {
        throw Exception('File upload failed');
      }

      // Get the download URL
      final imageUrl = await storageRef.getDownloadURL();

      // Update the user's photo URL
      await currentUser.updatePhotoURL(imageUrl);

      return imageUrl;
    } catch (e) {
      rethrow;
    }
  }
  // Future<String?> updateAuthPhotoCall(File imageFile) async {
  //   try {
  //     // Get the current user
  //     final currentUser = _firebaseAuth.currentUser;
  //     if (currentUser != null) {
  //       // Upload the image file to Firebase Storage
  //       final storageRef = storage.FirebaseStorage.instance
  //           .ref()
  //           .child('profile_images')
  //           .child('${currentUser.uid}.jpg');
  //       final uploadTask = storageRef.putFile(imageFile);
  //       await uploadTask.whenComplete(() => null);

  //       // Get the download URL of the uploaded image
  //       final imageUrl = await storageRef.getDownloadURL();

  //       // Update the user's photo URL with the download URL of the uploaded image
  //       await currentUser.updatePhotoURL(imageUrl);

  //       // Return the updated photo URL
  //       return imageUrl;
  //     } else {
  //       // No user signed in
  //       print('No user signed in');
  //       return null;
  //     }
  //   } catch (e) {
  //     // Handle error
  //     print('Error updating photo URL: $e');
  //     // Return null if an error occurred
  //     return null;
  //   }
  // }

  Future<bool> updateAuthPasswordCall(String password) async {
    try {
      // Get the current user
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        // Re-authenticate the user
        final credential = auth.EmailAuthProvider.credential(
          email: currentUser.email!,
          password: password,
        );
        await currentUser.reauthenticateWithCredential(credential);

        // Update the password
        await currentUser.updatePassword(password);

        // Password updated successfully
        return true;
      } else {
        // No user signed in
        return false;
      }
    } catch (e) {
      // Handle error
      // Return false if an error occurred
      return false;
    }
  }
}
