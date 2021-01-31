import 'package:Dating_app/data/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  final _db = FirebaseFirestore.instance;

  final _usersCollection = FirebaseFirestore.instance.collection('users');

  Future updateUser(String documentId, User data) async =>
      _usersCollection.doc(documentId).update(data.toMap());

  Future createUser(User user) async => _usersCollection.add(user.toMap());
}
