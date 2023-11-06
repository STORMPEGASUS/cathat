import 'package:cat_app/models/chat_user.dart';
import 'package:cat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//for using static method all over the code
class Api {
  //for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for storing self information
  static ChatUser me = ChatUser(
      id: auth.currentUser!.uid,
      name: auth.currentUser!.displayName.toString(),
      email: auth.currentUser!.email.toString(),
      about: "Hey, I'm using We Chat!",
      image: auth.currentUser!.photoURL.toString(),
      createdAt: '',
      isOnline: false,
      lastActive: '',
      pushToken: '');

  //for checking if user exist or not
  static Future<bool> userExist() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  //for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  //for creating new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final user = ChatUser(
      image: auth.currentUser!.photoURL.toString(),
      name: auth.currentUser!.displayName.toString(),
      about: "hello world this is new user",
      createdAt: time,
      lastActive: time,
      id: auth.currentUser!.uid,
      isOnline: false,
      pushToken: '',
      email: auth.currentUser!.email.toString(),
    );

    return await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .set(user.toJson());
  }

  //for getting all user from firebase
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: auth.currentUser!.uid)
        .snapshots();
  }

  //for updating user info
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }
  /////////////////////////chat screen related api///////////////////////

  //for getting msg from the specific conversation from firebase
  // static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessage() {
  //   return firestore.collection('messages').snapshots();
  // }

  //chats(collection)->conversation_id(docs)->messages(collection)->message(docs);

  // useful for getting conversation id
  static String getConversationID(String id) =>
      auth.currentUser!.uid.hashCode <= id.hashCode
          ? '${auth.currentUser!.uid}_$id'
          : '${id}_${auth.currentUser!.uid}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: false)
        .snapshots();
  }

  //for sending message
  static Future<void> sendMessage(ChatUser user, String msg) async {
    //message sending time also set as id
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(
      msg: msg,
      read: '',
      told: user.id,
      type: Type.Text,
      fromId: auth.currentUser!.uid,
      sent: time,
    );

    final ref =
        firestore.collection('chats/${getConversationID(user.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }
}
