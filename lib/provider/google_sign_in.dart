import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  bool _isSigningIn;
  bool _isLoggedIn;

  GoogleSignInProvider() {
    _isSigningIn = false;
    _isLoggedIn = false;
  }

  bool get isSigningIn => _isSigningIn;
  bool get isLoggedIn => _isLoggedIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  set isLoggedIn(bool isLoggedIn) {
    _isLoggedIn = isLoggedIn;
    notifyListeners();
  }

  Future<GoogleSignInAccount> login() async {
    isSigningIn = true;

    final user = await googleSignIn.signIn().catchError((error) {
      print(error);
    });
    if (user == null) {
      isSigningIn = false;
      isLoggedIn = false;
      return user;
    } else {
      final googleAuth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      isSigningIn = false;
      isLoggedIn = true;
      return user;
    }
  }

  void logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
    isLoggedIn = false;
  }
}
