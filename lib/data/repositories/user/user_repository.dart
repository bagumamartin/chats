import 'package:chats/data/models/user/user_model.dart';
import 'package:chats/data/providers/user/user_provider.dart';
import 'package:chats/data/repositories/user/base_user_repository.dart';

class UserRepository extends BaseUserRepository {
  final UserProvider _userProvider;

  UserRepository({
    UserProvider? userProvider,
  }) : _userProvider = userProvider ?? UserProvider();

  @override
  Future<User> createUser({
    required User user,
  }) async {
    return await _userProvider.createUserCall(user);
  }

  @override
  Stream<User> getUser({
    required String userId,
  }) {
    return _userProvider.getUserCall(userId);
  }

  @override
  Stream<List<User>> getUsers({required String userId}) {
    return _userProvider.getUsersStream(userId: userId);
  }

  @override
  Future<User> updateUser({
    required User user,
  }) async {
    return _userProvider.updateUserCall(user);
  }
}
