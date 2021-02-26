import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/models/conversation_overview.dart';
import 'package:Dating_app/data/repositories/photos_repository.dart';
import 'package:flutter/material.dart';

import 'components/message_bubble.dart';
import 'components/message_input.dart';
import 'components/photo_icon.dart';

class ChatView extends StatelessWidget {
  final String userId;
  final String userName;
  final ConversationOverview conversationOverview;

  ChatView({this.userId, this.userName, this.conversationOverview});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: conversationOverview != null
            ? _buildAppBarFromConversationData()
            : _buildAppBarFromUserData(),
      ),
      body: Column(
        children: [
          Expanded(child: MessagesList()),
          MessageInput(),
        ],
      ),
    );
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
          return Container();
        }
        return Container();
      },
    );
  }

  Widget _buildAppBarFromUserData() {
    final _photosRepository = PhotosRepository();

    return FutureBuilder(
      future: _photosRepository.getFirstPhotoUrlForUser(userId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildAppBarUserInfo(
              userName: userName, photoUrl: snapshot.data);
        } else if (snapshot.hasError) {
          if (snapshot.data == null) {
            return _buildAppBarUserInfo(
              userName: userName,
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
        Align(
          alignment: Alignment.center,
          child: Text(
            userName,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}

class MessagesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        MessageBubble(
          isMine: false,
          content: 'Hi',
          date: DateTime.now(),
        ),
        MessageBubble(
          isMine: true,
          content: 'Hi, what\'s up?',
          date: DateTime.now(),
        ),
        MessageBubble(
          isMine: false,
          content: 'Wanna hang out?',
          date: DateTime.now(),
        ),
      ],
    );
  }
}
