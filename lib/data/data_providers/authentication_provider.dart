import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInUser(String email, String password) async =>
      await _auth.signInWithEmailAndPassword(email: email, password: password);

  bool get isUserLoggedIn => _auth.currentUser != null;
}
