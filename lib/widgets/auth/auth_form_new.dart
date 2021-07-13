//Imports for pubspec Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

//Imports for Models
import '../../services/email_auth_custom.dart';

//Imports for Models
import '../../models/company_detail.dart';
import '../../models/user_detail.dart';

//Imports for Constants
import '../../constants.dart';

class AuthFormNew extends StatefulWidget {
  @override
  _AuthFormNewState createState() => _AuthFormNewState();
}

class _AuthFormNewState extends State<AuthFormNew>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var deviceToken = "";
  String _isVerified = "";
  String _isVerifiedEmail = "";
  bool submitValid = false;
  String _signUpState = "";
  bool isLoading = false;
  String _forgetPasswordStatus = '';
  bool _passwordVisible = false;

  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _otpcontroller = TextEditingController();

  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  AnimationController animationController;

  FocusNode focusNode;
  @override
  void dispose() {
    animationController.dispose();
    _emailcontroller.dispose();
    _otpcontroller.dispose();
    _password.dispose();
    _confirmpassword.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
        duration: const Duration(seconds: 2), vsync: this);
    animationController.repeat();
  }

  ///a void function to verify if the Data provided is true
  void verify() {
    var oTPVerify = EmailAuth.validate(
        receiverMail: _emailcontroller.value.text,
        userOTP: _otpcontroller.value.text);

    if (oTPVerify) {
      setState(() {
        _isVerified = 'yes';
        isLoading = false;
      });
    } else {
      setState(() {
        _isVerified = 'no';
        isLoading = false;
      });
    }
  }

  ///a void funtion to send the OTP to the user
  void sendOtp() async {
    EmailAuth.sessionName = "Blrber - Email Verification!!";
    bool result =
        await EmailAuth.sendOtp(receiverMail: _emailcontroller.value.text);
    if (result) {
      setState(() {
        submitValid = true;
        _isVerifiedEmail = 'yes';
        _signUpState = "otpreceivesuccess";
        isLoading = false;
      });
    } else {
      setState(() {
        submitValid = false;
        _isVerifiedEmail = 'no';
        _signUpState = "otpreceivefailed";
        isLoading = false;
      });
    }
    print("_isVerifiedEmail - $_isVerifiedEmail");
  }

  Future<void> _emailLoginSubmit() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();

      if (_isLogin || _isVerified == 'yes') {
        if (_isLogin) {
          if (mounted) {
            print('appsignin is mounted');
          } else {
            print('appsignin is not mounted');
          }
          await _signInWithEmailAndPassword();
        }
        if (_isVerified == 'yes') {
          await _register();
        }
      } else if (!_isLogin) {
        if (_isVerifiedEmail == 'no' || _isVerifiedEmail == '') {
          setState(() {
            _signUpState = "sendingotp";
          });
          sendOtp();
        } else if (_isVerifiedEmail == 'yes') {
          verify();
        }
      }

      //Use those values to send out auth request...
    }
  }

  void _reSet() {
    setState(() {
      _isVerified = "";
      _isVerifiedEmail = "";
      submitValid = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    focusNode = FocusScope.of(context);

    List<CompanyDetail> companyDetails =
        Provider.of<List<CompanyDetail>>(context);
    List<UserDetail> userDetails = Provider.of<List<UserDetail>>(context);
    if (_isLogin) {
      _isVerified = "";
      _isVerifiedEmail = "";
      submitValid = false;
    }

    return companyDetails.length > 0
        ? Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (companyDetails[0].logoImageUrl != null)
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey,
                      backgroundImage: companyDetails[0].logoImageUrl != null
                          ? NetworkImage(companyDetails[0].logoImageUrl)
                          : AssetImage('assets/icon/blrber_logo_text.png'),
                    ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          if (_isVerified != 'yes')
                            TextFormField(
                              controller: _emailcontroller,
                              key: ValueKey('email'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a Email';
                                } else if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  return 'Please enter a valid Email';
                                } else if (userDetails != null) {
                                  userDetails = userDetails
                                      .where((e) =>
                                          e.email.trim().toLowerCase() ==
                                          value.trim().toLowerCase())
                                      .toList();
                                  if (!_isLogin) {
                                    if (userDetails.length > 0) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      return 'User Email Already exist';
                                    }
                                  } else {
                                    if (userDetails.length == 0) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      return 'User not registered';
                                    } else {
                                      if (userDetails[0].providerId !=
                                          "password") {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        return "This user already Signed in with Google!";
                                      }
                                    }
                                  }
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email address',
                                icon: Icon(
                                  Icons.mail,
                                  color: bPrimaryColor,
                                ),
                              ),
                              onSaved: (value) {
                                _userEmail = value;
                              },
                            ),
                          if (_isVerified == 'yes') Text('Eamil - $_userEmail'),

                          if (_isVerified == 'yes')
                            TextFormField(
                              key: ValueKey('username'),
                              validator: (value) {
                                if (value.isEmpty || value.length < 4) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  return 'Please enter at least 4 characters.';
                                } else if (userDetails != null) {
                                  userDetails = userDetails
                                      .where((e) =>
                                          e.userName.trim().toLowerCase() ==
                                          value.trim().toLowerCase())
                                      .toList();
                                  if (userDetails.length > 0) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return 'User Name Already exist';
                                  }
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Username',
                                icon: Icon(
                                  Icons.person,
                                  color: bPrimaryColor,
                                ),
                              ),
                              onSaved: (value) {
                                _userName = value;
                              },
                            ),
                          if (_isLogin || _isVerified == 'yes')
                            TextFormField(
                              controller: _password,
                              obscureText: !_passwordVisible,
                              key: ValueKey('password'),
                              validator: (value) {
                                if (value.isEmpty || value.length < 7) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  return 'Password must be at lease 7 characters long.';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  icon: Icon(
                                    Icons.lock,
                                    color: bPrimaryColor,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                    icon: _passwordVisible
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off),
                                  )),
                              onSaved: (value) {
                                _userPassword = value;
                              },
                            ),

                          if (_isLogin)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _forgetPasswordStatus = "Reset";
                                  });
                                  _showPasswordResetDialog();
                                },
                                child: Text(
                                  'Forget Password?',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),

                          if (_isVerified == 'yes')
                            TextFormField(
                              key: ValueKey('confirmPassword'),
                              controller: _confirmpassword,
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                icon: Icon(
                                  Icons.lock,
                                  color: bPrimaryColor,
                                ),
                              ),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  return 'Please re-enter password';
                                }

                                if (_password.text != _confirmpassword.text) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  return "Password does not match";
                                }
                                return null;
                              },
                            ),
                          // if (!_isLogin)
                          if (submitValid && _isVerified != 'yes')
                            Container(
                              // width: MediaQuery.of(context).size.width / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    // width:
                                    //     MediaQuery.of(context).size.width / 2,
                                    child: TextFormField(
                                      key: ValueKey('otp'),
                                      controller: _otpcontroller,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        labelText: 'Enter OTP from email',
                                        icon: Icon(
                                          Icons.confirmation_num,
                                          color: bPrimaryColor,
                                        ),
                                      ),
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          return 'Please enter OTP';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  if (_isVerified == 'no')
                                    Container(
                                      child: const Text(
                                        'Validation Failed, Please check OTP!',
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  Container(
                                    // width:
                                    //     MediaQuery.of(context).size.width / 2,
                                    child: TextButton(
                                      onPressed: () {
                                        _reSet();
                                      },
                                      child: const Text('Reset'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          if (_signUpState == 'sendingotp' || isLoading)
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  bScaffoldBackgroundColor),
                              backgroundColor: bPrimaryColor,
                            ),
                          const SizedBox(height: 12),
                          // if (isLoading)
                          //   CircularProgressIndicator(
                          //     // valueColor: animationController.drive(ColorTween(
                          //     //     begin: Colors.blueAccent, end: Colors.red)),
                          //     valueColor: AlwaysStoppedAnimation<Color>(
                          //         Theme.of(context).scaffoldBackgroundColor),
                          //     backgroundColor: bPrimaryColor,
                          //   ),
                          if (!isLoading)
                            ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.blueGrey[700],
                                ),
                              ),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                await _emailLoginSubmit();
                              },
                              icon: Icon(Icons.email),
                              label: Text(_isLogin
                                  ? 'Sign In'
                                  : _isVerified == 'yes'
                                      ? 'Sign Up'
                                      : _isVerifiedEmail == 'no' ||
                                              _isVerifiedEmail == ''
                                          ? 'Verify Email'
                                          : 'Verify'),
                            ),
                          if (!isLoading)
                            TextButton(
                              child: Text(_isLogin
                                  ? 'Don\'t have an account? SIGN UP'
                                  : 'Already have an account? SIGN IN'),
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                            ),
                          const SizedBox(height: 12),
                          if (_isLogin)
                            SignInButton(
                              Buttons.GoogleDark,
                              // onPressed: _googleLoginSubmit,
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                await _signInWithGoogle();
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
  }

  void _showPasswordResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Password Reset"),
              content: Container(
                height: MediaQuery.of(context).size.height / 6,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (_forgetPasswordStatus == "Reset")
                        Column(
                          children: [
                            Text("Enter Email to reset password"),
                            TextFormField(
                              controller: _emailcontroller,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                icon: Icon(
                                  Icons.email,
                                  color: bPrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (_forgetPasswordStatus == "Start")
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              bScaffoldBackgroundColor),
                          backgroundColor: bPrimaryColor,
                        ),
                      if (_forgetPasswordStatus == "Success")
                        Text("Password link sent to your email!"),
                      if (_forgetPasswordStatus == "Failed")
                        Text("Failed to send password reset link! Try again!")
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                if (_forgetPasswordStatus == "Reset")
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                if (_forgetPasswordStatus == "Success" ||
                    _forgetPasswordStatus == "Failed")
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                if (_forgetPasswordStatus == "Reset")
                  TextButton(
                    child: const Text('Reset'),
                    onPressed: () {
                      setState(() {
                        _forgetPasswordStatus = 'Start';
                      });

                      _resetPassword().then((value) {
                        setState(() {});
                      });
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailcontroller.text);
      _forgetPasswordStatus = "Success";
    } on FirebaseAuthException catch (e) {
      print("reset - $e");
      _forgetPasswordStatus = "Failed";
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user found for that email.'),
            backgroundColor: bErrorColor,
          ),
        );
      }
    } catch (e) {
      _forgetPasswordStatus = "Failed";
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to Reset Password'),
          backgroundColor: bErrorColor,
        ),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      UserCredential userCredential;

      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _auth.signInWithCredential(googleAuthCredential);

      final user = userCredential.user;
      var providerId = user.providerData[0].providerId.trim();
      print('Sign In1 ${user.uid} with Google');
      if (user != null) {
        await addUserDetail(
          user.uid,
          googleUser.email,
          googleUser.email,
          googleUser.displayName,
          providerId,
        );
        _fcm(user.uid);
        print('Sign In ${user.uid} with Google');
      } else {
        print('Sign In with Google Failed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign in with Google user:'),
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Failed to sign in with Google: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in with Google:'),
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailcontroller.text,
        password: _password.text,
      );
      final user = userCredential.user;
      if (user != null) {
        _fcm(user.uid);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${user.email} signed in'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Email login fail. Try again!'),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user found for that email.'),
            backgroundColor: bErrorColor,
          ),
        );
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong password provided for that user.'),
            backgroundColor: bErrorColor,
          ),
        );
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in with Email & Password'),
          backgroundColor: bErrorColor,
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailcontroller.text, password: _password.text);
      final user = userCredential.user;
      if (user != null) {
        var providerId = user.providerData[0].providerId.trim();
        await addUserDetail(
          user.uid,
          _userName,
          _userEmail,
          _userName,
          providerId,
        );

        if (mounted) {
          print('app is mounted');
        } else {
          print('app is not mounted');
        }
        _fcm(user.uid);
        // setState(() {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: const Text('Email register success!'),
        //       backgroundColor: Theme.of(context).errorColor,
        //     ),
        //   );
        //   _userEmail = user.email;
        // });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Email register fail!'),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No user found for that email!'),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );

        print('No user found for that email.');
      } else if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('The password provided is too weak!'),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Account already exists for that email!'),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        print('Account already exists for that email.');
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Something went wrong. Please login later!'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  void _fcm(String userId) async {
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
}
