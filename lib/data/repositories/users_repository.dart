import 'package:Dating_app/data/data_providers/firestore_provider.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:flutter/foundation.dart';

class UsersRepository {
  final _firestoreProvider = FirestoreProvider();

  Future updateUser({@required String documentId, @required User data}) async =>
      await _firestoreProvider.updateUser(documentId, data);

  Future createUser(User user) async =>
      await _firestoreProvider.createUser(user);
}
