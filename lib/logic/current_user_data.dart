import 'package:Dating_app/data/models/user.dart';

class CurrentUserData {
  User _user;

  User get user => _user;
  String get userId => _user.id;
  bool get isUserSet => _user != null;

  void setUser(User value) => _user = value;
}
