import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_app/api/Apis.dart';
import 'package:cat_app/helper/dailogs.dart';
import 'package:cat_app/models/chat_user.dart';
import 'package:cat_app/screens/auth/login_Screen.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        //appbar
        appBar: AppBar(
          title: const Text('Profile Screen'),
        ),
        //for adding new chat user
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.red,
              onPressed: () async {
                //for showing progress bar
                Dialogs.showProgressbar(context);
                //sign out from app
                await Api.auth.signOut().then(
                  (value) async {
                    await GoogleSignIn().signOut().then(
                      (value) {
                        //for hiding progressbar
                        Navigator.pop(context);
                        //back to login screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreeen(),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              icon: const Icon(Icons.logout_outlined, color: Colors.white),
              label: const Text('Logout'),
            )),

        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  //for adding some space
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .03,
                  ),
                  //show profile picture
                  Stack(
                    children: [
                      //profile picture
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .1),
                        child: CachedNetworkImage(
                          imageUrl: widget.user.image,
                          fit: BoxFit.fill,
                          height: mq.height * .2,
                          width: mq.height * .2,
                          //placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                                  child: Icon(CupertinoIcons.person)),
                        ),
                      ),
                      //edit button
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 3,
                          onPressed: () {
                            _showBottomSheet();
                          },
                          color: Colors.white,
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: mq.height * .03,
                  ),
                  //user  email label
                  Text(
                    widget.user.email,
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  SizedBox(
                    height: mq.height * .03,
                  ),
                  //name input field
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (newValue) => Api.me.name = newValue ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      hintText: "eg: Utsav Kumar",
                      label: const Text('Name'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * .03,
                  ),
                  //about input field
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (newValue) => Api.me.about = newValue ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.info_outline),
                      hintText: "eg: Hello there !!",
                      label: const Text('About'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * .03,
                  ),
                  //update profile button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: Size(mq.width * .5, mq.height * .06)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        await Api.updateUserInfo().then((value) {
                          Dialogs.showSnackbar(
                              context, 'Profile Updated Successfully');
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 28,
                    ),
                    label: const Text(
                      'UPDATE',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //bottom sheet to select profile picture
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              //pick profile picture label
              const Text(
                'Pick Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),

              SizedBox(
                height: mq.height * .02,
              ),
              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //select from galary
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () {},
                      child: Image.asset('assets/images/add_image.png')),
                  //select from camera
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () {},
                      child: Image.asset('assets/images/camera.png')),
                ],
              ),
            ],
          );
        });
  }
}
