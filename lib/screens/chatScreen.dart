import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_app/models/chat_user.dart';
import 'package:cat_app/models/message.dart';
import 'package:cat_app/widget/message_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api/Apis.dart';
import '../main.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  ChatScreen({required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //store all message
  List<Message> _list = [];

  //to store the input text
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 239, 249),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: _appBar(),
      ),
      //body
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              //for dynamic data display
              stream: Api.getAllMessages(widget.user),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const SizedBox();

                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    //print('Data:${jsonEncode(data![0].data())}');
                    _list =
                        data!.map((e) => Message.fromJson(e.data())).toList();

                    if (_list.isNotEmpty) {
                      return ListView.builder(
                          itemCount: _list.length,
                          padding: EdgeInsets.only(top: mq.height * .01),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MessageCard(
                              message: _list[index],
                            );
                            // return ChatUserCard(user: list[index]);
                          });
                    } else {
                      return const Center(
                        child: Text(
                          'Say Hii 👋',
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }
                }
              },
            ),
          ),
          _chatInput()
        ],
      ),
    );
  }

//design for user text input
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: mq.width * .018, vertical: mq.height * .01),
      child: Row(
        children: [
          Expanded(
            child: Card(
              //to provide white box background
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.blueAccent,
                        size: 26,
                      )),
                  //text input field for chat
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: Colors.blue)),
                  )),

                  //pick image from gallary
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.image,
                        color: Colors.blueAccent,
                        size: 26,
                      )),
                  //pick image from camera
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.blueAccent,
                        size: 26,
                      )),
                  //adding some space
                  SizedBox(
                    width: mq.width * .02,
                  ),
                ],
              ),
            ),
          ),
          //send message button
          MaterialButton(
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                Api.sendMessage(widget.user, _textController.text);
                _textController.text = '';
              }
            },
            child: const Icon(
              Icons.send,
              color: Color.fromARGB(255, 246, 248, 246),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  //design for top appbar
  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Row(
          children: [
            //back button
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black54,
              ),
            ),
            //user profile picture
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .3),
              child: CachedNetworkImage(
                imageUrl: widget.user.image,
                fit: BoxFit.fill,
                height: mq.height * .05,
                width: mq.height * .05,
                //placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person)),
              ),
            ),
            //for adding some space
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //user name
                Text(
                  widget.user.name,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                //for adding some space
                const SizedBox(
                  height: 2,
                ),
                //last online
                const Text(
                  'Last seen not available',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
