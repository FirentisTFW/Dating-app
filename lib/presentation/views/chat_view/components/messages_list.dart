import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/models/message.dart';
import 'package:Dating_app/logic/current_user_data.dart';
import 'package:Dating_app/logic/messages_cubit/messages_cubit.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'message_bubble.dart';

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
