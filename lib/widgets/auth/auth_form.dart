import 'package:blrber/models/company_detail.dart';
import 'package:blrber/models/user_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:blrber/services/email_auth_custom.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

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

class _AuthFormState extends State<AuthForm> {
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

  TextEditingController _password = TextEditingController();
  TextEditingController _confirmpassword = TextEditingController();

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
    widget.submitFn(
      _userEmail.trim(),
      _userPassword.trim(),
      _userName.trim(),
      _isLogin,
      'google',
      context,
    );
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

    print('_isVerified - $_isVerified');
    print('_isVerifiedEmail - $_isVerifiedEmail');
    print('submitValid - $submitValid');

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
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          AssetImage('assets/icon/blrber_logo_text.png'),
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
                                } else if (userDetails != null && !_isLogin) {
                                  userDetails = userDetails
                                      .where((e) =>
                                          e.email.trim().toLowerCase() ==
                                          value.trim().toLowerCase())
                                      .toList();
                                  if (userDetails.length > 0) {
                                    return 'User Email Already exist';
                                  }
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email address',
                                icon: Icon(
                                  Icons.mail,
                                  color: Theme.of(context).primaryColor,
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
                                  color: Theme.of(context).primaryColor,
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
                                  return 'Please must be at lease 7 characters long.';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Password',
                                icon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColor,
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
                                  color: Theme.of(context).primaryColor,
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
                                          color: Theme.of(context).primaryColor,
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
                                      child: Text(
                                        'Validation Failed, Please check OTP!',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  Container(
                                    // width:
                                    //     MediaQuery.of(context).size.width / 2,
                                    child: TextButton(
                                      onPressed: () {
                                        _reSet();
                                      },
                                      child: Text('Reset'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          if (_signUpState == 'sendingotp')
                            CircularProgressIndicator(),
                          SizedBox(height: 12),
                          if (widget.isLoading) CircularProgressIndicator(),
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
                          SizedBox(height: 12),
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
              child: CircularProgressIndicator(),
            ),
          );
  }
}
