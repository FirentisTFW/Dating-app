import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/models/conversation_overview.dart';
import 'package:Dating_app/data/models/message.dart';
import 'package:Dating_app/data/repositories/conversations_repository.dart';
import 'package:Dating_app/data/repositories/photos_repository.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:Dating_app/logic/current_user_data.dart';
import 'package:Dating_app/logic/messages_cubit/messages_cubit.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/views/user_profile_view/user_profile_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import 'components/message_bubble.dart';
import 'components/message_input.dart';
import '../../universal_components/photo_icon.dart';

class ChatView extends StatelessWidget {
  final String userId;
  final String userName;
  final ConversationOverview conversationOverview;

  ChatView({this.userId, this.userName, this.conversationOverview});

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

  Widget _buildBodyFromConversationData() =>
      _buildBody(conversationId: conversationOverview.conversationId);

  Widget _buildBodyFromUserData() {
    final usersRepository = UsersRepository();
    final userData = locator<CurrentUserData>();

    return FutureBuilder(
      future: usersRepository.getConversationIdForMatch(
          userId: userData.userId, matchId: userId),
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

  Widget _buildBody({@required String conversationId}) {
    return Column(
      children: [
        Expanded(child: MessagesList(conversationId: conversationId)),
        MessageInput(conversationId: conversationId, matchedUserId: userId),
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
      Get.off(UserProfileView(userId ?? conversationOverview.userId));
}

class MessagesList extends StatelessWidget {
  final String conversationId;

  const MessagesList({@required this.conversationId});

  @override
  Widget build(BuildContext context) {
    if (conversationId != null) {
      BlocProvider.of<MessagesCubit>(context).getMessagesRef(conversationId);
    } else {
      BlocProvider.of<MessagesCubit>(context).waitForConversationStart();
    }

    return BlocBuilder<MessagesCubit, MessagesState>(
      builder: (context, state) {
        print(state);
        if (state is MessagesReferenceFetched) {
          return _buildMessages(state.messagesReference);
        } else if (state is MessagesNewConversation) {
          return const Center(
              child: Text('No messages yet, you can start conversation.'));
        }
        return const LoadingSpinner();
      },
    );
  }

  Widget _buildMessages(CollectionReference messagesReference) {
    final userId = locator<CurrentUserData>().userId;
    return StreamBuilder<QuerySnapshot>(
      stream: messagesReference.orderBy('date').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingSpinner();
        }
        if (snapshot.hasError) {
          return Text('Could not fetch messages');
        }
        return ListView(
          children: snapshot.data.docs.map((messageMap) {
            final message = Message.fromMap(messageMap.data());
            return MessageBubble(
              isMine: message.userId == userId,
              content: message.content,
              date: message.date,
            );
          }).toList(),
        );
      },
    );
  }
}
