import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:texting_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:texting_app/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedinUser;

class ChatScreen extends StatefulWidget {
  static const String id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final mesageTextControler = TextEditingController();

  String msgText = "";
  String msgrecived = "";

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
        print(loggedinUser.email);
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamed(context, WelcomeScreen.id);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: mesageTextControler,
                      onChanged: (value) {
                        msgText = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      mesageTextControler.clear();
                      _firestore
                          .collection('messages')
                          .add({'text': msgText, 'sender': loggedinUser.email});
                      //Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').snapshots(),
        builder: (context, snapshot) {
          List<messageBubble> MessageBubbles = [];
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.lightBlueAccent,
              ),
            );
          }
          final messages = snapshot.data!.docChanges.reversed;
          for (var msg in messages) {
            final messageText = msg.doc['text'];
            final messageSender = msg.doc['sender'];
            final CurrentUser = loggedinUser.email;

            final messagebubble =
                messageBubble(Sender: messageSender, text: messageText,isMe:CurrentUser==messageSender);
            MessageBubbles.add(messagebubble);
          }

          return Expanded(
            child: ListView(
              reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                children: MessageBubbles),
          );
        });
  }
}

class messageBubble extends StatelessWidget {
  messageBubble({required this.Sender, required this.text, required this.isMe});

  final String text;
  final String Sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: !isMe ?Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              Sender,
              style: TextStyle(color: Colors.black45),
            ),
            Material(
              elevation: 5.0,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topLeft: Radius.circular(30)),
              color: Colors.lightBlueAccent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                child: Text(
                  '$text',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          ],
        ):
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Sender,
              style: TextStyle(color: Colors.black45),
            ),
            Material(
              elevation: 5.0,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topRight: Radius.circular(30)),
              color: Colors.white70,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                child: Text(
                  '$text',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
              ),
            ),
          ],
        )
    );
  }
}
