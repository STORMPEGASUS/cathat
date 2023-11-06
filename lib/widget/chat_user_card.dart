import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_app/models/chat_user.dart';
import 'package:cat_app/screens/chatScreen.dart';
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
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) =>  ChatScreen(user: widget.user,)));
        },
        child: ListTile(
          //user profile picture

          leading: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .3),
            child: CachedNetworkImage(
              imageUrl: widget.user.image,
              height: mq.height * .055,
              width: mq.height * .055,
              //placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  const CircleAvatar(child: Icon(CupertinoIcons.person)),
            ),
          ),
          //user name
          title: Text(widget.user.name),
          //user last message
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
          ),
          //last message time
          // trailing: const Text(
          //   '12:00 pm',
          //   style: TextStyle(color: Colors.black54),
          // ),
          trailing: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
                color: Color.fromARGB(173, 171, 241, 90),
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}
