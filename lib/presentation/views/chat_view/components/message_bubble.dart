import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final bool isMine;
  final String content;
  final DateTime date;

  const MessageBubble({
    Key key,
    @required this.isMine,
    @required this.content,
    @required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color:
                    isMine ? Theme.of(context).primaryColor : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                  bottomLeft: isMine ? Radius.circular(14) : Radius.circular(0),
                  bottomRight:
                      isMine ? Radius.circular(0) : Radius.circular(14),
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 18,
                  color: isMine ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
