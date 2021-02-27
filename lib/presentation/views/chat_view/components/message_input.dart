import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/models/message.dart';
import 'package:Dating_app/logic/current_user_data.dart';
import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  final String conversationId;

  const MessageInput({@required this.conversationId});

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.conversationId);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
              minLines: 1,
              maxLines: 4,
            ),
          ),
          FlatButton(
            shape: CircleBorder(),
            onPressed: sendMessage,
            color: Theme.of(context).primaryColor,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  void sendMessage() {
    final userData = locator<CurrentUserData>();

    if (userData.isUserSet) {
      final message = Message(
        userId: userData.userId,
        content: _messageController.text,
        date: DateTime.now(),
        read: false,
      );

      // create comversation if doesn't exists (widget.conversationId == null)

      // send message to conversation
    }
  }
}
