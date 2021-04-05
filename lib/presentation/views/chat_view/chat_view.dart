import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/models/conversation_overview.dart';
import 'package:Dating_app/data/repositories/conversations_repository.dart';
import 'package:Dating_app/data/repositories/photos_repository.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:Dating_app/logic/current_user_data.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/views/user_profile_view/user_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'components/message_input.dart';
import '../../universal_components/photo_icon.dart';
import 'components/messages_list.dart';

class ChatView extends StatelessWidget {
  final String matchedUserId;
  final String matchedUserName;
  final ConversationOverview conversationOverview;

  ChatView(
      {this.matchedUserId, this.matchedUserName, this.conversationOverview});

  @override
  Widget build(BuildContext context) {
    if (conversationOverview != null && !conversationOverview.lastMessageRead) {
      _markLastMessageAsRead();
    }
    return Scaffold(
        appBar: AppBar(
          title: conversationOverview != null
              ? _buildAppBarFromConversationData()
              : _buildAppBarFromUserData(),
        ),
        body: conversationOverview != null
            ? _buildBodyFromConversationData()
            : _buildBodyFromUserData());
  }

  Widget _buildAppBarFromConversationData() {
    final _photosRepository = PhotosRepository();

    return FutureBuilder(
      future: _photosRepository
          .getFirstPhotoUrlForUser(conversationOverview.userId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildAppBarUserInfo(
              photoUrl: snapshot.data, userName: conversationOverview.userName);
        } else if (snapshot.hasError) {
          if (snapshot.data == null) {
            return _buildAppBarUserInfo(
              userName: conversationOverview.userName,
              photoUrl: null,
            );
          }
          return Container();
        }
        return Container();
      },
    );
  }

  Widget _buildAppBarFromUserData() {
    final _photosRepository = PhotosRepository();

    return FutureBuilder(
      future: _photosRepository.getFirstPhotoUrlForUser(matchedUserId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildAppBarUserInfo(
              userName: matchedUserName, photoUrl: snapshot.data);
        } else if (snapshot.hasError) {
          if (snapshot.data == null) {
            return _buildAppBarUserInfo(
              userName: matchedUserName,
              photoUrl: null,
            );
          }
          return Container();
        }
        return Container();
      },
    );
  }

  Widget _buildAppBarUserInfo(
      {@required String userName, @required String photoUrl}) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        PhotoIcon(
            photoUrl: photoUrl, size: AppBar().preferredSize.height * 0.8),
        const SizedBox(width: 20),
        InkWell(
          onTap: _goToUserProfileView,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              userName,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  Widget _buildBodyFromConversationData() {
    final usersRepository = UsersRepository();
    final userData = locator<CurrentUserData>();

    return FutureBuilder(
      future: usersRepository.areUsersMatched(
          userData.userId, conversationOverview.userId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildBody(
              conversationId: conversationOverview.conversationId,
              isStillMatched: snapshot.data);
        }
        return LoadingSpinner();
      },
    );
  }

  Widget _buildBodyFromUserData() {
    final usersRepository = UsersRepository();
    final userData = locator<CurrentUserData>();

    return FutureBuilder(
      future: usersRepository.getConversationIdForMatch(
          userId: userData.userId, matchId: matchedUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildBody(conversationId: snapshot.data);
        } else if (snapshot.hasError) {
          return LoadingSpinner();
        }
        return LoadingSpinner();
      },
    );
  }

  Widget _buildBody(
      {@required String conversationId, bool isStillMatched = true}) {
    return Column(
      children: [
        Expanded(child: MessagesList(conversationId: conversationId)),
        if (isStillMatched)
          MessageInput(
              conversationId: conversationId, matchedUserId: matchedUserId),
        if (!isStillMatched) _ConversationBlockedInfo()
      ],
    );
  }

  void _markLastMessageAsRead() {
    final conversationsRepository = ConversationsRepository();

    final userId = locator<CurrentUserData>().userId;

    conversationsRepository.markLastMessageAsRead(
        userId, conversationOverview.conversationId);
  }

  void _goToUserProfileView() =>
      Get.off(UserProfileView(matchedUserId ?? conversationOverview.userId));
}

class _ConversationBlockedInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text('You can\'t respond to this conversation.'),
    );
  }
}
