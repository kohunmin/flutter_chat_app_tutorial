import 'package:chat_app_tutorial/helper/helperfunctions.dart';
import 'package:chat_app_tutorial/services/auth.dart';
import 'package:chat_app_tutorial/services/database.dart';
import 'package:chat_app_tutorial/views/chatRoomScreen.dart';
import 'package:chat_app_tutorial/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEdittingController =
      new TextEditingController();
  TextEditingController emailTextEdittingController =
      new TextEditingController();
  TextEditingController passwordTextEdittingController =
      new TextEditingController();

  signMeUP() {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        "name": userNameTextEdittingController.text.trim(),
        "email": emailTextEdittingController.text.trim()
      };

      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEdittingController.text.trim());
      HelperFunctions.saveUserNameSharedPreference(
          userNameTextEdittingController.text.trim());

      setState(() {
        isLoading = true;
      });

      authMethods
          .signupwithEmailAndPassword(emailTextEdittingController.text.trim(),
              passwordTextEdittingController.text.trim())
          .then((val) {
        // print("$val");

        HelperFunctions.saveUserLoggedInSharedPreference(true);
        databaseMethods.uploadUserInfo(userInfoMap);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
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
                                  return val.isEmpty || val.length < 2
                                      ? "Please Provide UserName"
                                      : null;
                                },
                                controller: userNameTextEdittingController,
                                style: simpleTextFieldStyle(),
                                decoration:
                                    textFieldInputDecoration("username"),
                              ),
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
                                decoration:
                                    textFieldInputDecoration("password"),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
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
                          onTap: () => {signMeUP()},
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
                              "Sign Up",
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
                            "Sign Up with Google",
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
                            Text("Already have account? ",
                                style: mediumTextFieldStyle()),
                            GestureDetector(
                              onTap: () {
                                widget.toggle();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text("SignIn now",
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
