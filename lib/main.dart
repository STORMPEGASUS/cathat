import 'package:cat_app/screens/auth/login_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

late Size mq;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          //defining constant appbar theme for whole app
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 40, 180, 240),
          elevation: 1,
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 241, 236, 236),
            fontWeight: FontWeight.normal,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: const LoginScreeen(),
    );
  }
}
