import 'package:chat_app_tutorial/helper/constancts.dart';
import 'package:chat_app_tutorial/helper/helperfunctions.dart';
import 'package:chat_app_tutorial/services/database.dart';
import 'package:chat_app_tutorial/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'conversation_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTextEdittingController =
      new TextEditingController();

  DatabaseMethods databaseMethods = new DatabaseMethods();

  QuerySnapshot searchSnapshot;

  initiateSearch() {
    databaseMethods
        .getUersByUsername(searchTextEdittingController.text.trim())
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  /// create chatroom, send user to conversation screen, pushreplacement
  createChatroomAndStartConversation(String userName) {
    if (userName == Constants.myName) {
      print("you cannot send message to yourself");
      return;
    }

    String chatRoomId = getChatRoomId(userName, Constants.myName);
    List<String> users = [userName, Constants.myName];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomid": chatRoomId,
    };
    databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConversationScreen(
                  chatRoomId: chatRoomId,
                )));
  }

  Widget SearchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: mediumTextFieldStyle()),
              Text(userEmail, style: mediumTextFieldStyle())
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndStartConversation(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("message", style: mediumTextFieldStyle()),
            ),
          )
        ],
      ),
    );
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapshot.docs[index].get("name"),
                userEmail: searchSnapshot.docs[index].get("email"),
              );
            })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEdittingController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "serach username...",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF),
                            ]),
                            borderRadius: BorderRadius.circular(40)),
                        padding: EdgeInsets.all(12),
                        child: Image.asset("assets/images/search_white.png")),
                  )
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
