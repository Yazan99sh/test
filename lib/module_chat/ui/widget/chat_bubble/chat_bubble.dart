import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart' as timeago;

class ChatBubbleWidget extends StatefulWidget {
  final bool showImage;
  final String message;
  final DateTime sentDate;
  final bool me;

  ChatBubbleWidget({
    Key key,
    this.message,
    this.sentDate,
    this.me,
    this.showImage,
  });

  @override
  State<StatefulWidget> createState() => ChatBubbleWidgetState();
}

class ChatBubbleWidgetState extends State<ChatBubbleWidget> {
  bool focused = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.me ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              width: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Theme.of(context).brightness == Brightness.light
                    ? Color.fromRGBO(236, 239, 241, 1)
                    : Colors.grey[900],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.message.contains('http')
                        ? Image.network(widget.message
                            .replaceFirst('uploadimage', 'upload/image'))
                        : Text(
                            '${widget.message}',
                            style: TextStyle(
                          fontWeight: FontWeight.w400
                            ),
                          ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left:16.0,right:16,top:4),
            child: Text(timeago.format(widget.sentDate ?? DateTime.now()),textAlign: TextAlign.start,style: TextStyle(
              color: Colors.grey
            ),),
          ),
          ])),
    );
  }
}
