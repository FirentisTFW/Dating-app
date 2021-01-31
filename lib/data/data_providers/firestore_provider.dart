import 'package:Dating_app/data/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  final _usersCollection = FirebaseFirestore.instance.collection('users');

  Future updateUser(User user) async =>
      await _usersCollection.doc(user.id).set(user.toMap());

  Future createUser(User user) async =>
      await _usersCollection.doc(user.id).set(user.toMap());

  Future getUser(String uid) async => await _usersCollection.doc(uid).get();
}
