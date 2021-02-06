import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  final _usersCollection = FirebaseFirestore.instance.collection('users');

  Future getUser(String uid) async => await _usersCollection.doc(uid).get();

  Future updateUser(String uid, dynamic user) async =>
      await _usersCollection.doc(uid).set(user);

  Future createUser(String uid, dynamic user) async =>
      await _usersCollection.doc(uid).set(user);

  Future updateDiscoverySettings(String uid, dynamic discoverySettings) async =>
      await _usersCollection.doc(uid).update(discoverySettings);
}
