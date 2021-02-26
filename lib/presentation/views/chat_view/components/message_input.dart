import 'package:Dating_app/data/models/message.dart';
import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
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
    final message = Message(
      userId: null,
      content: _messageController.text,
      date: DateTime.now(),
      read: false,
    );
  }
}
