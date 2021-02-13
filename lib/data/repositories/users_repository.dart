import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/data_providers/firestore_provider.dart';
import 'package:Dating_app/data/models/custom_location.dart';
import 'package:Dating_app/data/models/discovery_settings.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:flutter/foundation.dart';

class UsersRepository {
  final _firestoreProvider = locator<FirestoreProvider>();

  Future<User> getUser(String uid) async {
    final userData = await _firestoreProvider.getUser(uid);
    final userMap = userData.data();
    if (userMap != null) {
      return User.fromMap(userMap);
    }
    return null;
  }

  Future<List<User>> getUsersByDiscoverySettings(
      DiscoverySettings discoverySettings,
      {@required CustomLocation location}) async {
    final usersSnapshots = await _firestoreProvider.getUsersByDiscoverySettings(
        discoverySettings, location);
    List<User> users = [];

    for (int i = 0; i < usersSnapshots.length; i++) {
      users.add(User.fromMap(usersSnapshots[i].data()));
    }
    return users;
  }

  Future updateUser(User user) async =>
      await _firestoreProvider.updateUser(user.id, user.toMap());

  Future createUser(User user) async =>
      await _firestoreProvider.createUser(user.id, user.toMap());

  Future updateDiscoverySettings(
      String uid, DiscoverySettings discoverySettings) async {
    final discoverySettingsMap = {
      'discoverySettings': discoverySettings.toMap()
    };
    await _firestoreProvider.updateDiscoverySettings(uid, discoverySettingsMap);
  }
}
