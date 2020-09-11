import 'package:chat_app_tutorial/helper/constancts.dart';
import 'package:chat_app_tutorial/services/database.dart';
import 'package:chat_app_tutorial/views/chatRoomScreen.dart';
import 'package:chat_app_tutorial/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  String chatRoomId;
  ConversationScreen({this.chatRoomId});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();

  Stream<QuerySnapshot> chatMessageStream;
  Widget ChatMessageList() {
    return StreamBuilder<QuerySnapshot>(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return MessageTile(
                  snapshot.data.docs[index].get("message"),
                  snapshot.data.docs[index].get("sendBy") == Constants.myName,
                );
              });
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      databaseMethods.addConversationMesssages(widget.chatRoomId, messageMap);
      messageController.clear();
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            Container(child: ChatMessageList()),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "message ...",
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
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
                          child: Image.asset("assets/images/send.png")),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe
                ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
          ),
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
    );
  }
}
