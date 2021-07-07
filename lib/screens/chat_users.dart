//Imports for pubspec Packages
import 'package:flutter/material.dart';

//Imports for Constants
import '../constants.dart';

//Imports for Widgets
import '../widgets/chat/list_users.dart';

class ChatUsers extends StatefulWidget {
  @override
  _ChatUsersState createState() => _ChatUsersState();
}

class _ChatUsersState extends State<ChatUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bBackgroundColor,
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
