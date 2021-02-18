import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/models/custom_location.dart';
import 'package:Dating_app/data/models/discovery_settings.dart';
import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/logic/custom_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:flutter/foundation.dart';

class FirestoreProvider {
  final _db = FirebaseFirestore.instance;
  CollectionReference _menCollection;
  CollectionReference _womenCollection;

  FirestoreProvider() {
    // local firebase emulator

    String host = defaultTargetPlatform == TargetPlatform.android
        ? '10.0.2.2:8080'
        : 'localhost:8080';

    _db.settings = Settings(host: host, sslEnabled: false);

    // end - local firebase emulator

    _menCollection = _db.collection('users').doc('men').collection('men');
    _womenCollection = _db.collection('users').doc('women').collection('women');
  }

  Future getUser(String uid) async {
    final user = await _menCollection.doc('m' + uid).get();
    if (user.data() != null) {
      return user;
    }
    return await _womenCollection.doc('w' + uid).get();
  }

  Future getUsersByDiscoverySettings(
      DiscoverySettings discoverySettings, CustomLocation userLocation) async {
    final geo = locator<Geoflutterfire>();
    final genderCollection =
        _getGenderCollectionForGender(discoverySettings.gender);

    final queryResult = await geo
        .collection(collectionRef: genderCollection.limit(50))
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
      await _getGenderCollectionForUser(uid).doc(uid).set(user);

  Future createUser(String uid, dynamic user) async =>
      await _getGenderCollectionForUser(uid).doc(uid).set(user);

  Future updateDiscoverySettings(
          String uid, Gender gender, dynamic discoverySettings) async =>
      await _getGenderCollectionForUser(uid).doc(uid).update(discoverySettings);

  Future getUserRejections(String uid) async =>
      await _getGenderCollectionForUser(uid)
          .doc(uid)
          .collection('rejections')
          .get();

  Future getUserAcceptances(String uid) async =>
      await _getGenderCollectionForUser(uid)
          .doc(uid)
          .collection('acceptances')
          .get();

  CollectionReference _getGenderCollectionForGender(Gender gender) {
    if (gender == Gender.Man) {
      return _menCollection;
    }
    return _womenCollection;
  }

  CollectionReference _getGenderCollectionForUser(String uid) {
    if (uid[0] == 'm') {
      return _menCollection;
    }
    return _womenCollection;
  }

  Future acceptUser({String acceptingUid, dynamic acceptance}) async =>
      await _getGenderCollectionForUser(acceptingUid)
          .doc(acceptingUid)
          .collection('acceptances')
          .doc(acceptance['userId'])
          .set(acceptance);

  Future rejectUser({String rejectingUid, dynamic rejection}) async =>
      await _getGenderCollectionForUser(rejectingUid)
          .doc(rejectingUid)
          .collection('rejections')
          .doc(rejection['userId'])
          .set(rejection);
}
