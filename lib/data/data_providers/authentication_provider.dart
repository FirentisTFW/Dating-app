import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isUserLoggedIn => _auth.currentUser != null;

  String get userId => _auth.currentUser.uid;

  Future<void> signInUser(String email, String password) async =>
      await _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> registerUser(String email, String password) async => await _auth
      .createUserWithEmailAndPassword(email: email, password: password);

  Future<void> signOutUser() async => await _auth.signOut();
}
