import 'package:cat_app/api/Apis.dart';
import 'package:cat_app/main.dart';
import 'package:cat_app/models/chat_user.dart';
import 'package:cat_app/screens/profile_Screen.dart';
import 'package:cat_app/widget/chat_user_card.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// home screen after login
class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Api.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CAT CHAT'),
        actions: [
          //for profile section
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileScreen(
                      user: Api.me,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.menu, color: Colors.black)),
        ],
      ),
      // //for adding new chat user
      // floatingActionButton: Padding(
      //     padding: const EdgeInsets.only(bottom: 10),
      //     child: FloatingActionButton(
      //         onPressed: () async {
      //           await Api.auth.signOut();
      //           await GoogleSignIn().signOut();
      //         },
      //         child:
      //             const Icon(Icons.add_comment_rounded, color: Colors.black))),
      body: StreamBuilder(
        //for dynamic data display
        stream: Api.getAllUser(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());

            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty) {
                return ListView.builder(
                    itemCount: list.length,
                    padding: EdgeInsets.only(top: mq.height * .01),
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ChatUserCard(user: list[index]);
                    });
              } else {
                return const Center(
                  child: Text(
                    'No Connection Found',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
