import 'package:blrber/models/message.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class NewMessage extends StatefulWidget {
  final String userIdTo;
  final String userNameTo;
  final String prodName;
  NewMessage({
    this.userIdTo,
    this.userNameTo,
    this.prodName,
  });
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  List<ReceivedMsgCount> receivedMsgCounts = [];
  final _controller = new TextEditingController();
  var _enteredMessage = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    receivedMsgCounts = Provider.of<List<ReceivedMsgCount>>(context);
  }

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      print('user there ${user.uid}');

      final userData = await FirebaseFirestore.instance
          .collection('userDetails')
          .doc(user.uid.trim())
          .get();

      if (userData == null) {
        print('user is null');
      } else {
        print('user there ${userData['userName']}');

        await FirebaseFirestore.instance.collection('chats').add({
          'text': _enteredMessage,
          'createdAt': Timestamp.now(),
          'userIdFrom': user.uid,
          'userNameFrom': userData['userName'],
          'userIdTo': widget.userIdTo,
          'userNameTo': widget.userNameTo,
          'userImage': userData['userImageUrl'],
          'prodName': widget.prodName,
        }).then((value) async {
          if (receivedMsgCounts.length > 0) {
            receivedMsgCounts = receivedMsgCounts
                .where((e) =>
                    e.receivedUserName.trim() == widget.userNameTo.trim() &&
                    e.sentUserName.trim() == userData['userName'].trim() &&
                    e.prodName.trim() == widget.prodName.trim())
                .toList();
          }

          if (receivedMsgCounts.length > 0) {
            receivedMsgCounts[0].receivedMsgCount =
                receivedMsgCounts[0].receivedMsgCount + 1;
            await FirebaseFirestore.instance
                .collection('receivedMsgCount')
                .doc(receivedMsgCounts[0].receivedMsgCountId)
                .update(
                    {'receivedMsgCount': receivedMsgCounts[0].receivedMsgCount})
                .then((value) => print("receivedMsgCount Updated"))
                .catchError((error) =>
                    print("Failed to update receivedMsgCount: $error"));
          } else {
            await FirebaseFirestore.instance
                .collection('receivedMsgCount')
                .add({
                  'receivedUserName': widget.userNameTo,
                  'receivedMsgCount': 1,
                  'sentUserName': userData['userName'],
                  'prodName': widget.prodName,
                })
                .then((value) => print("receivedMsgCount added"))
                .catchError(
                    (error) => print("Failed to add receivedMsgCount: $error"));
          }
        });
      }
    }

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter your message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.send,
            ),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
