import 'dart:math';

import 'package:Dating_app/data/models/conversation_overview.dart';
import 'package:Dating_app/presentation/universal_components/photo_icon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConversationItem extends StatelessWidget {
  final ConversationOverview conversation;

  const ConversationItem(this.conversation, {Key key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: PhotoIcon(
                  photoUrl: null,
                  size: 50,
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        conversation.userName,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(getMessageContent()),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Text(getLastMessageDate()),
              )
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  String getMessageContent() {
    return conversation.lastMessage.content
        .substring(0, min(conversation.lastMessage.content.length, 50));
  }

  String getLastMessageDate() {
    // TODO: check for days
    return conversation.lastMessage.date.hour.toString() +
        ':' +
        conversation.lastMessage.date.minute.toString();
  }
}
