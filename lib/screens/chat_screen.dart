import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './auth_screen.dart';
import './chat_users.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messenger',
          style: TextStyle(color: Theme.of(context).disabledColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: 0,
                height: 0,
              );
            }
            if (userSnapshot.hasData) {
              return ChatUsers();
            } else {
              return AuthScreen();
            }
          },
        ),
      ),
    );
  }
}
