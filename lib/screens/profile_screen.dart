// Imports for pubspec Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports for Models
import '../models/user_detail.dart';

// Imports for Services
import '../constants.dart';
import '../services/foundation.dart';

//Imports for Widgets
import '../widgets/display_profile.dart';
import '../widgets/display_admin_profile.dart';
import 'auth_screen_new.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return isIos
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text('Profile'),
            ),
            child: DisplayProfile(),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Profile',
                style: TextStyle(
                    color: bDisabledColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 25),
              ),
              elevation: 0.0,
              backgroundColor: bBackgroundColor,
            ),
            backgroundColor: bBackgroundColor,
            body: Container(
              child: StreamBuilder<Object>(
                // stream: FirebaseAuth.instance.authStateChanges(),
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: 0,
                      height: 0,
                    );
                  }
                  if (userSnapshot.hasData) {
                    final user = FirebaseAuth.instance.currentUser;
                    List<AdminUser> adminUsers =
                        Provider.of<List<AdminUser>>(context);

                    // if (user.emailVerified) {
                    if (adminUsers.length > 0 &&
                        adminUsers
                            .any((e) => e.userId.trim() == user.uid.trim())) {
                      return DisplayAdminProfile();
                    } else {
                      return DisplayProfile();
                    }
                    // } else {
                    //   return AuthScreen();
                    // }
                  } else {
                    // return AuthScreen();
                    return AuthScreenNew();
                  }
                },
              ),
            ),
            // _displayProfile,
          );
  }
}
