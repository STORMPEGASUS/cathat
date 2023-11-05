import 'dart:io';

import 'package:cat_app/api/Apis.dart';
import 'package:cat_app/helper/dailogs.dart';
import 'package:cat_app/screens/home_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../main.dart';

class LoginScreeen extends StatefulWidget {
  const LoginScreeen({super.key});

  @override
  State<LoginScreeen> createState() => _LoginScreeenState();
}

// login screen
class _LoginScreeenState extends State<LoginScreeen> {
  Future<UserCredential?> signInWithGoogle() async {
    try {
      //using try catch for internet issue detection
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await Api.auth.signInWithCredential(credential);
    } catch (e) {
      // print('\nsignInWithGoogle: $e');
      Dialogs.showSnackbar(context, "Something went wrong !!! (No internet)");
      return null;
    }
  }

  _googleButton() {
    //for showing progress bar
    Dialogs.showProgressbar(context);
    signInWithGoogle().then((user) {
      //for hiding progress bar
      Navigator.pop(context);
      if (user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size; //media query varible for dynamic size
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to CAT CHAT'),
      ),
      body: Stack(
        children: [
          Positioned(
              top: mq.height * .20,
              width: mq.width * .6,
              left: mq.width * .20,
              child: Image.asset('assets/images/cat.png')),
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .1,
            width: mq.width * .8,
            height: mq.height * .06,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  elevation: 3,
                  backgroundColor: const Color.fromARGB(255, 40, 47, 46)),
              onPressed: () {
                _googleButton();
              },
              icon: Image.asset('assets/images/google.png',
                  height: mq.height * 0.04),
              label: const Text(
                'Sign In using Google',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
