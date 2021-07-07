//Imports for pubspec Packages
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

//Imports for Constants
import '../constants.dart';

//Imports for Widgets
import '../widgets/auth/auth_form.dart';

//Imports for Providers
import '../provider/google_sign_in.dart';

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

          if (authResult != null) {
            // if (!authResult.emailVerified) {
            //   _showEmailVerifyDialog(authResult.email);
            // }
            _fcm(authResult.uid);
          }
        } else {
          authResult = (await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ))
              .user;

          if (authResult != null) {
            // if (!authResult.emailVerified) {
            //   print('check create user3');
            //   authResult.sendEmailVerification();
            //   _showEmailVerifyDialog(authResult.email);
            // }
            var providerId = authResult.providerData[0].providerId.trim();
            await addUserDetail(
              authResult.uid,
              userName,
              email,
              userName,
              providerId,
            );

            _fcm(authResult.uid);
          }
        }
      } else if (loginType == 'google') {
        final googleSignin =
            Provider.of<GoogleSignInProvider>(context, listen: false);
        googleSignin.login().then((googleUser) async {
          if (googleUser != null) {
            user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              var providerId = user.providerData[0].providerId.trim();

              // For google login user googleUser.email is considered for as user name
              await addUserDetail(
                user.uid,
                googleUser.email,
                googleUser.email,
                googleUser.displayName,
                providerId,
              );
              _fcm(user.uid);
            } else {
              print('Error getting user!');
            }
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: const Text('No user found for that email!'),
            backgroundColor: Theme.of(ctx).errorColor,
          ),
        );
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: const Text('Wrong password!!'),
            backgroundColor: Theme.of(ctx).errorColor,
          ),
        );
        print('Wrong password provided for the email ID.');
      }
      setState(() {
        _isLoding = false;
      });
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
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(err),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoding = false;
      });
    }
  }

  Future<void> addUserDetail(String userId, String userName, String userEmail,
      String displayName, String providerId) async {
    await FirebaseFirestore.instance
        .collection('userDetails')
        .doc(userId.trim())
        .get()
        .then((documentSnapshot) async {
      if (documentSnapshot.exists) {
        print("User $userId already exist!!");
        if (documentSnapshot.data()["providerID"] != providerId) {
          await updateUserProviderId(userId.trim(), providerId);
        }
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
          'providerId': providerId,
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

  Future<void> updateUserProviderId(String userDocId, String providerId) async {
    await FirebaseFirestore.instance
        .collection('userDetails')
        .doc(userDocId.trim())
        .update({
      'providerId': providerId,
    }).then((value) {
      print("User Updated");
    }).catchError((error) => print("Failed to update User Details: $error"));
  }

  void _fcm(String userId) async {
    print('checking fcm!!');
    final fcm = FirebaseMessaging();
    await fcm.requestNotificationPermissions();
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
    await fcm.getToken().then(
      (value) async {
        print('checking get token!!!');
        // setState(() {
        deviceToken = value;
        // });

        await _setToken(userId);
        print('device token - $deviceToken');
      },
    );
  }

  Future<void> _setToken(String userId) async {
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
  }

  // void _showEmailVerifyDialog(String email) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Email Verification!"),
  //         content: Container(
  //           height: 100,
  //           child: Center(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
  //               children: [
  //                 Text('Verification link has been sent to $email .'),
  //               ],
  //             ),
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('Ok'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bBackgroundColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoding,
      ),
    );
  }
}
