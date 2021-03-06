import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/data_providers/firestore_provider.dart';
import 'package:Dating_app/data/models/acceptance_rejection.dart';
import 'package:Dating_app/data/models/conversation_overview.dart';
import 'package:Dating_app/data/models/custom_location.dart';
import 'package:Dating_app/data/models/discovery_settings.dart';
import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/data/models/user_match.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UsersRepository {
  final _firestoreProvider = locator<FirestoreProvider>();

  Future<User> getUserById(String uid) async {
    final userData = await _firestoreProvider.getUserById(uid);
    final userMap = userData.data();

    if (userMap != null) {
      return User.fromMap(userMap);
    }
    return null;
  }

  Future<User> getUserByAuthId(String uid) async {
    final userData = await _firestoreProvider.getUserByAuthId(uid);
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

  Future<List<String>> getUserRejections(String userId) async {
    final rejectionsSnapshots =
        await _firestoreProvider.getUserRejections(userId);

    if (rejectionsSnapshots.docs.length > 0) {
      return rejectionsSnapshots.docs
          .map((item) => item.data()['userId'] as String)
          .toList();
    }
    return [];
  }

  Future<List<String>> getUserAcceptances(String userId) async {
    final acceptancesSnapshots =
        await _firestoreProvider.getUserAcceptances(userId);

    if (acceptancesSnapshots.docs.length > 0) {
      return acceptancesSnapshots.docs
          .map((item) => item.data()['userId'] as String)
          .toList();
    }
    return [];
  }

  Future<List<UserMatch>> getUserMatches(String userId) async {
    final matchesSnapshots = await _firestoreProvider.getUserMatches(userId);

    if (matchesSnapshots.docs.length > 0) {
      return matchesSnapshots.docs
          .map((item) => UserMatch.fromMap(item.data()))
          .toList();
    }
    return [];
  }

  Future<List<ConversationOverview>> getUserConversations(String userId) async {
    final conversationsSnapshots =
        await _firestoreProvider.getUserConversations(userId);

    if (conversationsSnapshots.docs.length > 0) {
      return conversationsSnapshots.docs
          .map((item) => ConversationOverview.fromMap(item.data()))
          .toList();
    }
    return [];
  }

  Future<void> createUser(User user) async =>
      await _firestoreProvider.createUser(user.id, user.toMap());

  Future<void> updateUser(User user) async =>
      await _firestoreProvider.updateUser(user.id, user.toMap());

  Future<void> updateDiscoverySettings(
      String uid, Gender gender, DiscoverySettings discoverySettings) async {
    final discoverySettingsMap = {
      'discoverySettings': discoverySettings.toMap()
    };
    await _firestoreProvider.updateDiscoverySettings(
        uid, gender, discoverySettingsMap);
  }

  Future<void> acceptUser({String acceptingUid, Acceptance acceptance}) async =>
      await _firestoreProvider.acceptUser(
          acceptingUid: acceptingUid, acceptance: acceptance.toMap());

  Future<void> rejectUser({String rejectingUid, Rejection rejection}) async =>
      await _firestoreProvider.rejectUser(
          rejectingUid: rejectingUid, rejection: rejection.toMap());

  Future<void> unmatchUser(String unmatchingUid, String unmatchedUid) async =>
      await _firestoreProvider.unmatchUser(unmatchingUid, unmatchedUid);

  Future<String> getConversationIdForMatch(
      {String userId, String matchId}) async {
    final matchData = await _firestoreProvider.getMatch(userId, matchId);

    return matchData.data()['conversationId'];
  }

  Future<bool> areUsersMatched(String firstUid, String secondUid) async =>
      await _firestoreProvider.areUsersMatched(firstUid, secondUid);
}
