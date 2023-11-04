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
  Future<UserCredential> signInWithGoogle() async {
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
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  _googleButton() {
    signInWithGoogle().then((user) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
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
