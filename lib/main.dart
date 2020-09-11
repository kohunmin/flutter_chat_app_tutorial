// import 'package:chat_app_tutorial/views/signin.dart';
import 'package:chat_app_tutorial/helper/helperfunctions.dart';
import 'package:chat_app_tutorial/views/chatRoomScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'helper/authenticate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    getLoggedInState();
    super.initState();
  }

  bool userIsLoggedIn;
  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn != null
          ? userIsLoggedIn ? ChatRoom() : Authenticate()
          : Authenticate(),
    );
  }
}
