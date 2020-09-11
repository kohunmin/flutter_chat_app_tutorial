import 'package:chat_app_tutorial/helper/helperfunctions.dart';
import 'package:chat_app_tutorial/services/auth.dart';
import 'package:chat_app_tutorial/services/database.dart';
import 'package:chat_app_tutorial/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatRoomScreen.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEdittingController =
      new TextEditingController();
  TextEditingController passwordTextEdittingController =
      new TextEditingController();

  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;
  signIn() {
    if (formKey.currentState.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEdittingController.text.trim());

      //
      setState(() {
        isLoading = true;
      });

      databaseMethods
          .getUersByUserEmail(emailTextEdittingController.text.trim())
          .then((value) {
        snapshotUserInfo = value;
        HelperFunctions.saveUserNameSharedPreference(
            snapshotUserInfo.docs[0].get("name"));
      });

      authMethods
          .signInWithEmailAndPassword(emailTextEdittingController.text.trim(),
              passwordTextEdittingController.text.trim())
          .then((value) {
        if (value != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val)
                                ? null
                                : "Enter correct email";
                          },
                          controller: emailTextEdittingController,
                          style: simpleTextFieldStyle(),
                          decoration: textFieldInputDecoration("email"),
                        ),
                        TextFormField(
                          validator: (val) {
                            return val.length < 6
                                ? "Enter Password 6+ characters"
                                : null;
                          },
                          controller: passwordTextEdittingController,
                          style: simpleTextFieldStyle(),
                          decoration: textFieldInputDecoration("password"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        "Forgot Password",
                        style: simpleTextFieldStyle(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      signIn();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC),
                        ]),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Sign In",
                        style: mediumTextFieldStyle(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Sign In with Google",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have account? ",
                          style: mediumTextFieldStyle()),
                      GestureDetector(
                        onTap: () {
                          widget.toggle();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Register now",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                decoration: TextDecoration.underline,
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              )),
        ),
      ),
    );
  }
}
