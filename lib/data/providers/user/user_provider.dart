import 'package:chats/data/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class UserProvider {
  final firestore.FirebaseFirestore _firebaseFirestore;

  UserProvider({
    firestore.FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore =
            firebaseFirestore ?? firestore.FirebaseFirestore.instance;

  Future<User> createUserCall(User user) async {
    return await _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .set(user.toDocument())
        .then(
          (value) => _firebaseFirestore
              .collection('users')
              .doc(user.id)
              .get()
              .then((snapshot) => User.fromSnapshot(snapshot)),
        );
  }

  Stream<User> getUserCall(String userId) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .asyncMap((snapshot) {
      if (snapshot.exists) {
        return User.fromSnapshot(snapshot);
      } else {
        return createUserCall(User(id: userId));
      }
    });
  }

  // Stream<List<User>> getUsersCall() {
  //   Stream<List<User>> getUsersCall() async* {
  //     yield await _firebaseFirestore.collection('users').get().then(
  //       (querySnapshot) =>
  //           querySnapshot.docs.map((doc) => User.fromSnapshot(doc)).toList(),
  //     );
  //   }
  // }

  Stream<List<User>> getUsersStream({
    required String userId,
  }) {
    return _firebaseFirestore
        .collection('users')
        .where("id", isNotEqualTo: userId)
        .snapshots()
        .asyncMap((querySnapshot) =>
            querySnapshot.docs.map((doc) => User.fromSnapshot(doc)).toList());
  }

  Future<User> updateUserCall(User user) async {
    await _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .update(user.toDocument());
    return _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .get()
        .then((snapshot) => User.fromSnapshot(snapshot));
  }
}
