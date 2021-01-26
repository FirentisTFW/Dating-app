import 'package:Dating_app/data/data_providers/authentication_provider.dart';

class AuthenticationRepository {
  final AuthenticationProvider _provider = AuthenticationProvider();

  Future signInUser(String email, String password) async =>
      await _provider.signInUser(email, password);
}
