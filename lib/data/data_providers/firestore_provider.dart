import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/models/custom_location.dart';
import 'package:Dating_app/data/models/discovery_settings.dart';
import 'package:Dating_app/logic/custom_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class FirestoreProvider {
  final _usersCollection = FirebaseFirestore.instance.collection('users');

  Future getUser(String uid) async => await _usersCollection.doc(uid).get();

  Future getUsersByDiscoverySettings(
      DiscoverySettings discoverySettings, CustomLocation userLocation) async {
    final geo = locator<Geoflutterfire>();

    final queryResult = await geo
        .collection(collectionRef: _usersCollection)
        .within(
          center: userLocation,
          radius: discoverySettings.distance.toDouble(),
          field: 'location',
        )
        .first;

    final filteredResult = queryResult.where((item) {
      final birthDate =
          DateTime.fromMillisecondsSinceEpoch(item.data()['birthDate']);
      final age = CustomHelpers.getDifferenceInYears(birthDate, DateTime.now());

      return age >= discoverySettings.ageMin && age <= discoverySettings.ageMax;
    }).toList();

    return filteredResult;
  }

  Future updateUser(String uid, dynamic user) async =>
      await _usersCollection.doc(uid).set(user);

  Future createUser(String uid, dynamic user) async =>
      await _usersCollection.doc(uid).set(user);

  Future updateDiscoverySettings(String uid, dynamic discoverySettings) async =>
      await _usersCollection.doc(uid).update(discoverySettings);
}
