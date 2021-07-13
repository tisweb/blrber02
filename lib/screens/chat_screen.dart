//Imports for pubspec Packages
import 'package:blrber/screens/auth_screen_new.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Imports for Constants
import '../constants.dart';

//Imports for Screens
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
        centerTitle: true,
        title: const Text(
          'Messenger',
          style: TextStyle(
              color: bDisabledColor, fontWeight: FontWeight.w600, fontSize: 25),
        ),
        backgroundColor: bBackgroundColor,
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
              // return AuthScreen();
              return AuthScreenNew();
            }
          },
        ),
      ),
    );
  }
}
