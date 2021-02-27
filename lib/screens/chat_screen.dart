import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String _message = '';
  var loggedInUser;
  final textFieldController = TextEditingController();
  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print('Logged in user is $loggedInUser');
      }
    } catch (e) {
      print('The following is the error $e');
    }
  }

  void getMessages() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data()['text']);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                try {
                  await _auth.signOut();
                  Navigator.pushNamed(context, 'welcome_screen');
                } catch (e) {
                  print('error is $e');
                }
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
            StreamBuilder(
              stream: _firestore
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data.docs.reversed;
                  final currentUser = loggedInUser.email;
                  List<MessageBubble> messages = [];
                  for (var item in data) {
                    final message = item['text'];
                    final sender = item['sender'];
                    messages.add(MessageBubble(
                      sender: sender,
                      text: message,
                      isMe: sender == currentUser,
                    ));
                  }
                  return Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ListView(
                      children: messages,
                      reverse: true,
                    ),
                  ));
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textFieldController,
                      style: TextStyle(color: Colors.black),
                      onChanged: (value) {
                        _message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      textFieldController.clear();
                      try {
                        await _firestore.collection('messages').add({
                          'sender': loggedInUser.email,
                          'text': _message,
                          'timestamp': DateTime.now()
                        });
                      } catch (e) {
                        print('error is: $e');
                      }
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

class MessageBubble extends StatelessWidget {
  final text;
  final sender;
  final bool isMe;
  MessageBubble({this.text, this.sender, this.isMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 15, right: 15),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender, style: TextStyle(color: Colors.black38, fontSize: 12)),
          Material(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
                topLeft: isMe ? Radius.circular(25) : Radius.circular(0),
                topRight: isMe ? Radius.circular(0) : Radius.circular(25),
              ),
              elevation: 5,
              color: isMe ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(text,
                      style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                          fontSize: 16)))),
        ],
      ),
    );
  }
}
