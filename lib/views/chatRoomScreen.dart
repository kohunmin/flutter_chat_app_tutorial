import 'package:chat_app_tutorial/helper/authenticate.dart';
import 'package:chat_app_tutorial/helper/constancts.dart';
import 'package:chat_app_tutorial/helper/helperfunctions.dart';
import 'package:chat_app_tutorial/services/auth.dart';
import 'package:chat_app_tutorial/services/database.dart';
import 'package:chat_app_tutorial/views/conversation_screen.dart';
import 'package:chat_app_tutorial/views/search.dart';
import 'package:chat_app_tutorial/views/signin.dart';
import 'package:chat_app_tutorial/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
  }

  Stream<QuerySnapshot> chatRoom;

  Widget chatRoomList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoom,
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            return ChatRoomTile(
                snapshot.data.docs[index]
                    .get("chatroomid")
                    .toString()
                    .replaceAll("_", "")
                    .replaceAll(Constants.myName, ""),
                snapshot.data.docs[index].get("chatroomid"));
          },
        );
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoom = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 50,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ConversationScreen(chatRoomId: chatRoomId)));
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(40)),
                child: Text("${userName.substring(0, 1)}"),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                userName,
                style: mediumTextFieldStyle(),
              ),
            ],
          )),
    );
  }
}
