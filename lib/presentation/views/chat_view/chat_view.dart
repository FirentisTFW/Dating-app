import 'package:Dating_app/data/models/conversation.dart';
import 'package:flutter/material.dart';

import 'components/message_bubble.dart';
import 'components/message_input.dart';

class ChatView extends StatelessWidget {
  final String userId;
  Conversation conversation;

  ChatView({@required this.userId, this.conversation});

  @override
  Widget build(BuildContext context) {
    // test only
    conversation = Conversation(
      userId: 'wasdsa15',
      userName: 'Olivia',
      lastMessage: null,
    );
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(child: SizedBox()),
            PhotoIcon(size: AppBar().preferredSize.height * 0.8),
            const SizedBox(width: 20),
            Align(
              alignment: Alignment.center,
              child: Text(
                conversation.userName,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: MessagesList()),
          MessageInput(),
        ],
      ),
    );
  }
}

class PhotoIcon extends StatelessWidget {
  final double size;

  // test only
  final networkImage =
      'https://firebasestorage.googleapis.com/v0/b/dating-app-76b0f.appspot.com/o/users_images%2FmgIzISF1o6Gfau0SqV1arDCZNtKO2%2F1614161715112?alt=media&token=05111a20-0883-4b81-95ec-eccf961850c7';

  const PhotoIcon({Key key, @required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fitWidth,
          image: NetworkImage(
            networkImage,
          ),
        ),
      ),
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
