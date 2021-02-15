import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/data_providers/firestore_provider.dart';
import 'package:Dating_app/data/models/custom_location.dart';
import 'package:Dating_app/data/models/discovery_settings.dart';
import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    final List<DocumentSnapshot> usersSnapshots = await _firestoreProvider
        .getUsersByDiscoverySettings(discoverySettings, location);

    return usersSnapshots.map((item) => User.fromMap(item.data())).toList();
  }

  Future updateUser(User user) async =>
      await _firestoreProvider.updateUser(user.id, user.toMap());

  Future createUser(User user) async =>
      await _firestoreProvider.createUser(user.id, user.toMap());

  Future updateDiscoverySettings(
      String uid, Gender gender, DiscoverySettings discoverySettings) async {
    final discoverySettingsMap = {
      'discoverySettings': discoverySettings.toMap()
    };
    await _firestoreProvider.updateDiscoverySettings(
        uid, gender, discoverySettingsMap);
  }

  Future<List<String>> getUserRejections(String userId) async {
    final rejectionsSnapshots =
        await _firestoreProvider.getUserRejections(userId) as QuerySnapshot;

    return rejectionsSnapshots.docs.map((item) => item.id).toList();
  }
}
