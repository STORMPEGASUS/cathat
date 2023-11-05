import 'package:cat_app/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//for using static method all over the code
class Api {
  //for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for checking if user exist or not

  static Future<bool> userExist() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
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
}
