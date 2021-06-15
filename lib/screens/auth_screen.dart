import 'package:blrber/provider/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  User authResult;
  User user;

  var _isLoding = false;

  var deviceToken = "";

  void _submitAuthForm(
    String email,
    String password,
    String userName,
    bool isLogin,
    String loginType,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoding = true;
      });
      if (loginType == 'email') {
        if (isLogin) {
          authResult = (await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ))
              .user;

          _fcm(authResult.uid);
        } else {
          authResult = (await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ))
              .user;

          await addUserDetail(authResult.uid, userName, email, userName);

          _fcm(authResult.uid);

          print('check user2');
        }
      } else if (loginType == 'google') {
        final googleSignin =
            Provider.of<GoogleSignInProvider>(context, listen: false);
        googleSignin.login().then((googleUser) async {
          if (googleUser != null) {
            user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              // For google login user googleUser.email is considered for as user name
              await addUserDetail(user.uid, googleUser.email, googleUser.email,
                  googleUser.displayName);
              _fcm(user.uid);
            } else {
              print('Error getting user!');
            }
          }
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occured, please check your credntials!';

      if (err.message != null) {
        message = err.message;
      }
      print('Platform error - $message');

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoding = false;
      });
    } catch (err) {
      print('Platform error 2 - $err');
      setState(() {
        _isLoding = false;
      });
    }
  }

  Future<void> addUserDetail(String userId, String userName, String userEmail,
      String displayName) async {
    await FirebaseFirestore.instance
        .collection('userDetails')
        .doc(userId.trim())
        .get()
        .then((documentSnapshot) async {
      if (documentSnapshot.exists) {
        print("User $userId already exist!!");
      } else {
        print("User $userId not exist!! Add new user");
        await FirebaseFirestore.instance
            .collection('userDetails')
            .doc(userId)
            .set({
          'userName': userName,
          'email': userEmail,
          'userImageUrl': '',
          'displayName': displayName,
          'addressLocation': '',
          'countryCode': '',
          'buyingCountryCode': '',
          'latitude': 0.0,
          'longitude': 0.0,
          'phoneNumber': '',
          'alternateNumber': '',
          'userType': '',
          'licenceNumber': '',
          'companyName': '',
          'companyLogoUrl': '',
        }).catchError((error) {
          print("Failed to add user: $error");
        });
      }
    }).catchError((error) {
      print("Failed to get user: $error");
    });

    print('user id in add2 - $userId');
  }

  void _fcm(String userId) {
    print('checking fcm!!');
    final fcm = FirebaseMessaging();
    fcm.requestNotificationPermissions();
    fcm.configure(
      onMessage: (message) {
        print(message);
        return;
      },
      onLaunch: (message) {
        print(message);
        return;
      },
      onResume: (message) {
        print(message);
        return;
      },
    );
    // fcm.subscribeToTopic('chat');
    // fcm.subscribeToTopic(widget.userNameFrom);
    // print('fcm messaging user name - ${widget.userNameFrom}');
    fcm.getToken().then(
      (value) async {
        print('checking get token!!!');
        // setState(() {
        deviceToken = value;
        // });
        print('device token11111111 - $deviceToken');
        await _setToken(userId);
        print('device token - $deviceToken');
      },
    );
  }

  Future<void> _setToken(String userId) async {
    print('user id111 - $userId');
    await FirebaseFirestore.instance
        .collection('userDeviceToken')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        print(
            'Document exists on the database - ${documentSnapshot.data()["deviceToken"]}');

        if (documentSnapshot.data()["deviceToken"] != deviceToken) {
          await FirebaseFirestore.instance
              .collection('userDeviceToken')
              .doc(userId)
              .update({'deviceToken': deviceToken})
              .then((value) => print("userDeviceToken Updated"))
              .catchError(
                  (error) => print("Failed to update userDeviceToken: $error"));
        } else {
          print(
              'Document exists on the database SAME DEVICE - ${documentSnapshot.data()["deviceToken"]}');
        }
      } else {
        print('Document NOT exists on the database - Adding new token');
        await FirebaseFirestore.instance
            .collection('userDeviceToken')
            .doc(userId)
            .set({
              'userId': userId,
              'deviceToken': deviceToken,
              'userLevel': 'Normal',
            })
            .then((value) => print("userDeviceToken added"))
            .catchError(
                (error) => print("Failed to add userDeviceToken: $error"));
      }
    });
    print('user id222 - $userId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AuthForm(
        _submitAuthForm,
        _isLoding,
      ),
    );
  }
}
