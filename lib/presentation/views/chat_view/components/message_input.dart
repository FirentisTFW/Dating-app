import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/models/message.dart';
import 'package:Dating_app/logic/conversations_cubit/conversations_cubit.dart';
import 'package:Dating_app/logic/current_user_data.dart';
import 'package:Dating_app/logic/messages_cubit/messages_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageInput extends StatefulWidget {
  final String conversationId;
  final String matchedUserId;

  const MessageInput({@required this.conversationId, this.matchedUserId});

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  String _conversationId;
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _conversationId = widget.conversationId;
  }

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

  void sendMessage() async {
    final userData = locator<CurrentUserData>();

    if (userData.isUserSet) {
      final message = Message(
        userId: userData.userId,
        content: _messageController.text,
        date: DateTime.now(),
        read: false,
      );

      await _createConversationIfDoesntExist(userData.userId);

      if (_conversationId != null) {
        BlocProvider.of<MessagesCubit>(context)
            .sendMessage(_conversationId, message);
      }
    }
  }

  Future<void> _createConversationIfDoesntExist(String userId) async {
    if (_conversationId == null && widget.matchedUserId != null) {
      _conversationId =
          await BlocProvider.of<ConversationsCubit>(context).createConversation(
        userId: userId,
        matchedUserId: widget.matchedUserId,
      );
    }
  }
}
