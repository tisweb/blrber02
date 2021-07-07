import 'package:blrber/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Import services
import '../constants.dart';
import '../services/foundation.dart';

//Imports for Widgets
import '../widgets/display_favorites.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _displayFavorites = SafeArea(
      child: DisplayFavorites(),
    );

    return isIos
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(
                'Favorites',
                style: TextStyle(color: bDisabledColor),
              ),
              backgroundColor: bBackgroundColor,
            ),
            child: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.hasData) {
                    return _displayFavorites;
                  } else {
                    return AuthScreen();
                  }
                }),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Favorites',
                style: TextStyle(
                    color: bDisabledColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 25),
              ),
              backgroundColor: bBackgroundColor,
              elevation: 0.0,
            ),
            body: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: 0,
                      height: 0,
                    );
                  }
                  if (userSnapshot.hasData) {
                    return _displayFavorites;
                  }
                  return AuthScreen();
                }),
          );
  }
}
