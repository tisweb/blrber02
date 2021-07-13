//Imports for pubspec Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//Imports for Screens
import '../screens/auth_screen_new.dart';

//Imports for Widgets
import '../widgets/post_input_form.dart';

//Imports for Constants
import '../constants.dart';

class GeneratePost extends StatefulWidget {
  static const routeName = '/generate-post';

  @override
  _GeneratePostState createState() => _GeneratePostState();
}

class _GeneratePostState extends State<GeneratePost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Generate Post',
          style: TextStyle(
              color: bDisabledColor, fontWeight: FontWeight.w600, fontSize: 25),
        ),
        elevation: 0.0,
        backgroundColor: bBackgroundColor,
      ),
      body: Container(
        child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: 0,
                  height: 0,
                );
              }
              if (userSnapshot.hasData) {
                return PostInputForm(
                    // editPost: 'false',
                    );
              }
              // return AuthScreen();
              return AuthScreenNew();
            }),
      ),
    );
  }
}
