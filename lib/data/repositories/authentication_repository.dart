import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/data_providers/authentication_provider.dart';

class AuthenticationRepository {
  final AuthenticationProvider _provider = locator<AuthenticationProvider>();

  bool get isUserLoggedIn => _provider.isUserLoggedIn;

  String get userId => _provider.userId;

  Future signInUser(String email, String password) async =>
      await _provider.signInUser(email, password);

  Future registerUser(String email, String password) async =>
      await _provider.registerUser(email, password);
}
