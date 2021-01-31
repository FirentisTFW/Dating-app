import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/data_providers/firestore_provider.dart';
import 'package:Dating_app/data/models/user.dart';

class UsersRepository {
  final _firestoreProvider = locator<FirestoreProvider>();

  Future updateUser(User user) async =>
      await _firestoreProvider.updateUser(user);

  Future createUser(User user) async =>
      await _firestoreProvider.createUser(user);

  Future<User> getUser(String uid) async {
    final userData = await _firestoreProvider.getUser(uid);
    final userMap = userData.data();
    return User.fromMap(userMap);
  }
}
