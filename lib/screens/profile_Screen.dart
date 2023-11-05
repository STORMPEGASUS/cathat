import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_app/api/Apis.dart';
import 'package:cat_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

// profile screen of user
class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  ProfileScreen({required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

// home screen after login
class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
      ),
      //for adding new chat user
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
              onPressed: () async {
                await Api.auth.signOut();
                await GoogleSignIn().signOut();
              },
              child:
                  const Icon(Icons.add_comment_rounded, color: Colors.black))),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
        child: Column(
          children: <Widget>[
            //for adding some space
            SizedBox(
              width: mq.width,
              height: mq.height * .03,
            ),
            //show profile picture
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .1),
              child: CachedNetworkImage(
                imageUrl: widget.user.image,
                fit: BoxFit.fill,
                height: mq.height * .2,
                width: mq.height * .2,
                //placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
