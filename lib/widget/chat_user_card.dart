import 'package:cat_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  ChatUserCard({required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .01, vertical: 4),
      color: const Color.fromARGB(255, 234, 245, 255),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {},
        child: ListTile(
          //user profile picture
          leading: const CircleAvatar(child: Icon(CupertinoIcons.person)),
          //user name
          title: Text(widget.user.name),
          //user last message
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
          ),
          //last message time
          trailing: const Text(
            '12:00 pm',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
