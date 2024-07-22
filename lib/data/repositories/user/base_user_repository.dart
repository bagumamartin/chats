import 'package:chats/data/models/user/user_model.dart';

abstract class BaseUserRepository {
  Stream<User> getUser({
    required String userId,
  });

  Stream<List<User>> getUsers({
    required String userId,
  });

  Future<void> createUser({
    required User user,
  });

  Future<void> updateUser({
    required User user,
  });
}
