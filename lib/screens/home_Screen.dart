import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// home screen after login
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          CupertinoIcons.home,
          color: Colors.black,
        ),
        title: const Text('DEMO CHAT'),
        actions: [
          //for search user
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.black)),
          //for profile section
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu, color: Colors.black)),
        ],
      ),
      //for adding new chat user
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add_comment_rounded, color: Colors.black),
        ),
      ),
    );
  }
}
