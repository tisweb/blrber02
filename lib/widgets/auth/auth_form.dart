//Imports for pubspec Packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

//Imports for Models
import '../../services/email_auth_custom.dart';

//Imports for Models
import '../../models/company_detail.dart';
import '../../models/user_detail.dart';

//Imports for Constants
import '../../constants.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    String loginType,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  String _isVerified = "";
  String _isVerifiedEmail = "";
  bool submitValid = false;
  String _signUpState = "";

  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _otpcontroller = TextEditingController();

  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();

  AnimationController animationController;
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
      });
    } else {
      setState(() {
        _isVerified = 'no';
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
      });
    } else {
      setState(() {
        submitValid = false;
        _isVerifiedEmail = 'no';
        _signUpState = "otpreceivefailed";
      });
    }
  }

  void _emailLoginSubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();

      if (_isLogin || _isVerified == 'yes') {
        widget.submitFn(
          _userEmail.trim(),
          _userPassword.trim(),
          _userName.trim(),
          _isLogin,
          'email',
          context,
        );
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

  void _googleLoginSubmit() {
    if (_emailcontroller.text.isEmpty) {
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _isLogin,
        'google',
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      backgroundImage:
                          NetworkImage(companyDetails[0].logoImageUrl),
                    ),
                  if (companyDetails[0].logoImageUrl == null)
                    const CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey,
                      backgroundImage: AssetImage(
                          'assets/app_icon_splash_original/welcomepageshortb.jpg'),
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
                                  return 'Please a valid Email';
                                } else if (userDetails != null) {
                                  userDetails = userDetails
                                      .where((e) =>
                                          e.email.trim().toLowerCase() ==
                                          value.trim().toLowerCase())
                                      .toList();
                                  if (!_isLogin) {
                                    if (userDetails.length > 0) {
                                      return 'User Email Already exist';
                                    }
                                  } else {
                                    if (userDetails.length == 0) {
                                      return 'User not registered';
                                    } else {
                                      if (userDetails[0].providerId !=
                                          "password") {
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
                                  return 'Please enter at least 4 characters.';
                                } else if (userDetails != null) {
                                  userDetails = userDetails
                                      .where((e) =>
                                          e.userName.trim().toLowerCase() ==
                                          value.trim().toLowerCase())
                                      .toList();
                                  if (userDetails.length > 0) {
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
                              obscureText: true,
                              key: ValueKey('password'),
                              validator: (value) {
                                if (value.isEmpty || value.length < 7) {
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
                              ),
                              onSaved: (value) {
                                _userPassword = value;
                              },
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
                                  return 'Please re-enter password';
                                }

                                if (_password.text != _confirmpassword.text) {
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
                          if (_signUpState == 'sendingotp')
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  bScaffoldBackgroundColor),
                              backgroundColor: bPrimaryColor,
                            ),
                          const SizedBox(height: 12),
                          if (widget.isLoading)
                            CircularProgressIndicator(
                              // valueColor: animationController.drive(ColorTween(
                              //     begin: Colors.blueAccent, end: Colors.red)),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).scaffoldBackgroundColor),
                              backgroundColor: bPrimaryColor,
                            ),
                          if (!widget.isLoading)
                            ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.blueGrey[700],
                                ),
                              ),
                              onPressed: _emailLoginSubmit,
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
                          if (!widget.isLoading)
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
                              onPressed: _googleLoginSubmit,
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
}
