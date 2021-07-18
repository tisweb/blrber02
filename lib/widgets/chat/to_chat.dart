import 'package:blrber/screens/user_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ToChat extends StatefulWidget {
  final String userIdFrom;
  final String userIdTo;
  final String prodName;
  ToChat({this.userIdFrom, this.userIdTo, this.prodName});
  @override
  _ToChatState createState() => _ToChatState();
}

class _ToChatState extends State<ToChat> {
  String userNameFrom = "";
  String userNameTo = "";
  String imageUrlTo = "";

  @override
  void initState() {
    super.initState();
    _getUsersDetails();
  }

  void _getUsersDetails() async {
    final userDataFrom = await FirebaseFirestore.instance
        .collection('userDetails')
        .doc(widget.userIdFrom.trim())
        .get();

    if (userDataFrom == null) {
      print('user is null');
    } else {
      print('user there ${userDataFrom['userName']}');
      setState(() {
        userNameFrom = userDataFrom['userName'];
      });
    }

    final userDataTo = await FirebaseFirestore.instance
        .collection('userDetails')
        .doc(widget.userIdTo.trim())
        .get();

    if (userDataTo == null) {
      print('user is null');
    } else {
      print('user there ${userDataTo['userName']}');
      setState(() {
        userNameTo = userDataTo['userName'];
        imageUrlTo = userDataTo["userImageUrl"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: UserChatScreen(
        userNameFrom: userNameFrom,
        userNameTo: userNameTo,
        userIdFrom: widget.userIdFrom,
        userIdTo: widget.userIdTo,
        prodName: widget.prodName,
        imageUrlTo: imageUrlTo,
      ),
    );
  }
}
