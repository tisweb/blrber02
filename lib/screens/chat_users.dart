import 'package:flutter/material.dart';

import '../widgets/chat/list_users.dart';

class ChatUsers extends StatefulWidget {
  @override
  _ChatUsersState createState() => _ChatUsersState();
}

class _ChatUsersState extends State<ChatUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListUsers(),
            ),
          ],
        ),
      ),
    );
  }
}
