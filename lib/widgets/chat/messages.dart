import 'package:blrber/models/chat_detail.dart';
import 'package:blrber/widgets/chat/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'message_bubble.dart';

class Messages extends StatefulWidget {
  final String userNameFrom;
  final String userNameTo;
  final String prodName;
  Messages({
    this.userNameFrom,
    this.userNameTo,
    this.prodName,
  });

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    List<ChatDetail> chatDetails = Provider.of<List<ChatDetail>>(context);

    List<ChatDetail> chatDetailsFrom = [];
    chatDetailsFrom = chatDetails
        .where((e) =>
            (e.userNameFrom.trim() == widget.userNameFrom.trim() &&
                e.userNameTo.trim() == widget.userNameTo.trim()) &&
            e.prodName.trim() == widget.prodName.trim())
        .toList();

    List<ChatDetail> chatDetailsTo = [];
    chatDetailsTo = chatDetails
        .where((e) =>
            (e.userNameFrom.trim() == widget.userNameTo.trim() &&
                e.userNameTo.trim() == widget.userNameFrom.trim()) &&
            e.prodName.trim() == widget.prodName.trim())
        .toList();

    List<ChatDetail> chatDetailsFromTo = [];

    chatDetailsFromTo = chatDetailsFrom + chatDetailsTo;

    if (chatDetailsFromTo.length != null && chatDetailsFromTo.length > 1) {
      chatDetailsFromTo.sort((a, b) {
        var aCreateAt = a.createdAt;
        var bCreateAt = b.createdAt;
        return aCreateAt.compareTo(bCreateAt);
      });
    }

    return ListView.builder(
      // reverse: true,
      itemCount: chatDetailsFromTo.length,
      itemBuilder: (ctx, index) => MessageBubble(
        chatDetailsFromTo: chatDetailsFromTo[index],
      ),
    );
  }
}
