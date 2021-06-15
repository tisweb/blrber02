import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:search_map_place/search_map_place.dart';
import '../models/user_detail.dart';
import '../provider/get_current_location.dart';
import '../services/api_keys.dart';
import '../widgets/search_place_auto_complete_widget_custom.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  UserDetail userDataUpdated = UserDetail();
  UserDetail userData = UserDetail();
  GetCurrentLocation getCurrentLocation = GetCurrentLocation();
  List<DropdownMenuItem<String>> _userTypes = [];
  User user;
  File pickedImage, pickedLogoImage;
  String _countryCode = "";
  String _addressLocation = '';
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _imageUrl = "";
  bool _fetchingLocation = false;
  bool _updateComplete = false;
  var _initialSelectedItem = 'Unspecified';

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;

    getCurrentLocation =
        Provider.of<GetCurrentLocation>(context, listen: false);

    setState(() {
      _countryCode = getCurrentLocation.countryCode;
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    List<UserDetail> userDetails = Provider.of<List<UserDetail>>(context);
    if (userDetails.length > 0 && user != null) {
      userDetails = userDetails
          .where((e) => e.email.trim() == user.email.trim())
          .toList();
      if (userDetails.length > 0) {
        userDataUpdated = userDetails[0];
        print('userupdate - edit-profile');
      }
    }
    List<UserType> userTypes = Provider.of<List<UserType>>(context);

    _userTypes = [];
    if (userTypes != null) {
      for (UserType userType in userTypes) {
        _userTypes.add(
          DropdownMenuItem(
            value: userType.userType,
            child: Text(userType.userType),
          ),
        );
      }
    }
    super.didChangeDependencies();
  }

  Future<void> _trySubmit() async {
    print('Address Location22 - ${userDataUpdated.addressLocation}');
    print('_updateComplete2 -  $_updateComplete');
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();

      if (pickedImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('product_images')
            .child(userData.userDetailDocId + '.jpg');

        await ref.putFile(pickedImage);

        _imageUrl = await ref.getDownloadURL();

        userDataUpdated.userImageUrl = _imageUrl;
      }

      if (pickedLogoImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('product_images')
            .child(userData.userDetailDocId + 'Logo' + '.jpg');

        await ref.putFile(pickedLogoImage);

        _imageUrl = await ref.getDownloadURL();

        userDataUpdated.companyLogoUrl = _imageUrl;
      }

      if (_addressLocation.isNotEmpty) {
        userDataUpdated.addressLocation = _addressLocation;
        userDataUpdated.latitude = _latitude;
        userDataUpdated.longitude = _longitude;
      }

      await FirebaseFirestore.instance
          .collection('userDetails')
          .doc(userData.userDetailDocId.trim())
          .update({
        'userImageUrl': userDataUpdated.userImageUrl,
        'displayName': userDataUpdated.displayName,
        'addressLocation': userDataUpdated.addressLocation,
        'latitude': userDataUpdated.latitude,
        'longitude': userDataUpdated.longitude,
        'phoneNumber': userDataUpdated.phoneNumber,
        'alternateNumber': userDataUpdated.alternateNumber,
        'countryCode': _countryCode,
        'buyingCountryCode': _countryCode,
        'userType': userDataUpdated.userType,
        'licenceNumber': userDataUpdated.licenceNumber,
        'companyName': userDataUpdated.companyName,
        'companyLogoUrl': userDataUpdated.companyLogoUrl,
      }).then((value) {
        print("User Updated");
        setState(() {
          _updateComplete = true;
        });
      }).catchError((error) => print("Failed to update User Details: $error"));
    }
  }

  Future _pickImage(String sourceType) async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: sourceType == 'G' ? ImageSource.gallery : ImageSource.camera,
    );
    if (imageFile == null) {
      return null;
    }
    setState(() {
      pickedImage = File(imageFile.path);
    });
  }

  Future _pickLogoImage(String sourceType) async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: sourceType == 'G' ? ImageSource.gallery : ImageSource.camera,
    );
    if (imageFile == null) {
      return null;
    }
    setState(() {
      pickedLogoImage = File(imageFile.path);
    });
  }

  Future<void> _showUpdateDialog() async {
    print('_updateComplete1 -  $_updateComplete');
    var _completed = false;
    await _trySubmit().whenComplete(() => _completed = true);
    if (_completed) {
      setState(() {
        _updateComplete = true;
      });
    }
    print('_updateComplete3 -  $_updateComplete');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("User Update!!"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                  child: Text(_updateComplete
                      ? 'User Update !!Please Continue!'
                      : 'Update in progress...'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            if (_updateComplete)
              TextButton(
                  child: Center(
                    child: Text('Ok'),
                  ),
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // UserDetail userData = UserDetail();

    // final user = FirebaseAuth.instance.currentUser;
    // final userDetails = Provider.of<UserDetailsProvider>(context);
    // final getCurrentLocation =
    //     Provider.of<GetCurrentLocation>(context, listen: false);

    // setState(() {
    //   _countryCode = getCurrentLocation.countryCode;
    // });

    // if (userDetails != null) {
    //   userDetails.getUserDetail(user.uid);
    //   userData = userDetails.userData;
    // }

    print('Address Location11 - ${userDataUpdated.addressLocation}');

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: userDataUpdated.userDetailDocId != null
          ? Container(
              width: double.infinity,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.grey,
                              backgroundImage: pickedImage != null
                                  ? FileImage(pickedImage)
                                  : userDataUpdated.userImageUrl == ""
                                      ? AssetImage(
                                          'assets/images/default_user_image.png')
                                      : NetworkImage(
                                          userDataUpdated.userImageUrl),
                            ),
                            Positioned(
                              bottom: -10,
                              right: -10,
                              child: IconButton(
                                icon: FaIcon(FontAwesomeIcons.camera),
                                onPressed: () async {
                                  await _pickImage('G');
                                },
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Email : '),
                            Text(userDataUpdated.email)
                          ],
                        ),
                        // TextFormField(
                        //   initialValue: userDataUpdated.email,
                        //   key: ValueKey('email'),
                        //   validator: (value) {
                        //     return null;
                        //   },
                        //   keyboardType: TextInputType.emailAddress,
                        //   decoration: InputDecoration(
                        //     labelText: 'Email address',
                        //   ),
                        //   onSaved: (value) {},
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('User Name : '),
                            Text(userDataUpdated.userName)
                          ],
                        ),
                        // TextFormField(
                        //   initialValue: userDataUpdated.userName,
                        //   key: ValueKey('username'),
                        //   validator: (value) {
                        //     return null;
                        //   },
                        //   decoration: InputDecoration(labelText: 'Username'),
                        //   onSaved: (value) {},
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue: userDataUpdated.displayName,
                          key: ValueKey('displayName'),
                          validator: (value) {
                            if (value.isEmpty || value.length < 7) {
                              return 'Must be at lease 7 characters long.';
                            }
                            if (value.length > 20) {
                              return 'Should not be more than 20 characters long.';
                            }
                            return null;
                          },
                          decoration:
                              InputDecoration(labelText: 'Display Name'),
                          onSaved: (value) {
                            userDataUpdated.displayName = value;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue: userDataUpdated.phoneNumber,
                          key: ValueKey('phoneNumber'),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Phone number must not be empty';
                            }

                            return null;
                          },
                          decoration:
                              InputDecoration(labelText: 'Phone Number'),
                          onSaved: (value) {
                            userDataUpdated.phoneNumber = value;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue: userDataUpdated.alternateNumber,
                          key: ValueKey('alternateNumber'),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Phone number must not be empty';
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Alternate Phone Number'),
                          onSaved: (value) {
                            userDataUpdated.alternateNumber = value;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('User Type'),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        DropdownButtonFormField<String>(
                            items: _userTypes,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) async {
                              setState(() {
                                userDataUpdated.userType = value;
                              });
                            },
                            onSaved: (value) {
                              userDataUpdated.userType = value;
                            },
                            validator: (value) {
                              if (value == 'Unspecified') {
                                return 'Please select User Type!';
                              }
                              return null;
                            },
                            value: userDataUpdated.userType.isEmpty
                                ? _initialSelectedItem
                                : userDataUpdated.userType),
                        SizedBox(
                          height: 10,
                        ),
                        if (userDataUpdated.userType == 'Dealer')
                          Column(
                            children: [
                              TextFormField(
                                initialValue: userDataUpdated.companyName,
                                key: ValueKey('companyName'),
                                validator: (value) {
                                  return null;
                                },
                                decoration:
                                    InputDecoration(labelText: 'Company Name'),
                                onSaved: (value) {
                                  userDataUpdated.companyName = value;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                initialValue: userDataUpdated.licenceNumber,
                                key: ValueKey('licenceNumber'),
                                validator: (value) {
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: 'Licence Number'),
                                onSaved: (value) {
                                  userDataUpdated.licenceNumber = value;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text('Company Logo'),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.grey,
                                        backgroundImage: pickedLogoImage != null
                                            ? FileImage(pickedLogoImage)
                                            : userDataUpdated.companyLogoUrl ==
                                                    ""
                                                ? AssetImage(
                                                    'assets/images/default_user_image.png')
                                                : NetworkImage(userDataUpdated
                                                    .companyLogoUrl),
                                      ),
                                      Positioned(
                                        bottom: -10,
                                        right: -10,
                                        child: IconButton(
                                          icon: FaIcon(FontAwesomeIcons.camera),
                                          onPressed: () async {
                                            await _pickLogoImage('G');
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Present Address'),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(userDataUpdated.addressLocation),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('New Location'),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SearchPlaceAutoCompleteWidgetCustom(
                            apiKey: placeApiKey,
                            components: _countryCode,
                            placeType: PlaceType.address,
                            onSelected: (place) async {
                              print('place - $place');
                              setState(() {
                                _addressLocation = '';
                                _latitude = 0.0;
                                _longitude = 0.0;
                                _fetchingLocation = true;
                              });
                              await getCurrentLocation
                                  .getselectedPosition(place);

                              setState(() {
                                _addressLocation =
                                    getCurrentLocation.addressLocation;
                                _latitude = getCurrentLocation.latitude;
                                _longitude = getCurrentLocation.longitude;
                                _fetchingLocation = false;
                                // userDataUpdated.addressLocation =
                                //     _addressLocation;
                                // userDataUpdated.latitude = _latitude;
                                // userDataUpdated.longitude = _longitude;
                                print(
                                    'Address Location - ${userDataUpdated.addressLocation}');
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () async {
                              setState(() {
                                _addressLocation = '';
                                _latitude = 0.0;
                                _longitude = 0.0;
                                _fetchingLocation = true;
                              });

                              await getCurrentLocation.getCurrentPosition();
                              setState(() {
                                _addressLocation =
                                    getCurrentLocation.addressLocation;
                                _latitude = getCurrentLocation.latitude;
                                _longitude = getCurrentLocation.longitude;
                                _fetchingLocation = false;
                                // userDataUpdated.addressLocation =
                                //     _addressLocation;
                                // userDataUpdated.latitude = _latitude;
                                // userDataUpdated.longitude = _longitude;
                              });
                            },
                            icon: Icon(Icons.my_location),
                            label: Text("Current Location"),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('New Address'),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(_addressLocation),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        !_fetchingLocation
                            ? ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Colors.blueGrey[700],
                                  ),
                                ),
                                onPressed: () {
                                  _updateComplete = false;
                                  _showUpdateDialog();
                                  // _trySubmit();
                                },
                                icon: Icon(Icons.update),
                                label: Text('Update'),
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Container(
              child: Center(
                child:
                    Text('Something went wrong while getting user details!!'),
              ),
            ),
    );
  }
}
