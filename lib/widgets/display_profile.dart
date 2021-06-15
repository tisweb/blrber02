import 'package:blrber/models/user_detail.dart';
import 'package:blrber/provider/get_current_location.dart';
import 'package:blrber/screens/edit_profile.dart';
import 'package:blrber/screens/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'display_product_catalog.dart';

class DisplayProfile extends StatefulWidget {
  @override
  _DisplayProfileState createState() => _DisplayProfileState();
}

class _DisplayProfileState extends State<DisplayProfile> {
  String currentUserName = "";
  List<UserDetail> userDetailsCU = [];
  bool _initialData = false;
  @override
  Widget build(BuildContext context) {
    final List<UserDetail> userDetails = Provider.of<List<UserDetail>>(context);
    final getCurrentLocation = Provider.of<GetCurrentLocation>(context);
    final user = FirebaseAuth.instance.currentUser;
    // print('calling userDetail in display profile!');
    // final userDetails =
    //     Provider.of<UserDetailsProvider>(context, listen: false);
    // print('called userDetail in display profile!');
    // UserDetail userData = UserDetail();
    // if (userDetails != null) {
    //   userDetails.getUserDetail(user.uid);
    //   userData = userDetails.userData;
    // }

    // print('user @ display profile - ${userData.email}');

    // final googleSignin =
    //     Provider.of<GoogleSignInProvider>(context, listen: false);

    // googleSignin.logout();

    // print('userDetails.length - ${userDetails.length}');

    print('display profile 1 ');
    _initialData = false;
    if (userDetails != null) {
      if (userDetails.length > 0 && user != null) {
        userDetailsCU = userDetails
            .where((e) => e.email.trim() == user.email.trim())
            .toList();
        if (userDetailsCU.length > 0) {
          currentUserName = userDetailsCU[0].userName;
          _initialData = true;
          print('currentUserName = $currentUserName');
        }
      }
    }
    print('display profile 2 ');

    // print('user CU - ${userDetailsCU[0].email}');

    // print('user name - ${userDetailsCU[0].userName}');
    return Scaffold(
      body: _initialData
          ? Container(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flag(
                          getCurrentLocation.countryCode,
                          height: 20,
                          width: 25,
                          fit: BoxFit.fill,
                        ),
                        IconButton(
                          icon: Icon(Icons.settings),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(SettingsScreen.routeName);
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: userDetailsCU[0].userImageUrl == ""
                              ? AssetImage(
                                  'assets/images/default_user_image.png')
                              : NetworkImage(userDetailsCU[0].userImageUrl),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                userDetailsCU[0].displayName,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).disabledColor),
                              ),
                              Text(
                                userDetailsCU[0].userType,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).disabledColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text(
                        'Edit Profile',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).disabledColor),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) {
                                return EditProfile();
                              },
                              fullscreenDialog: true),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: Icon(Icons.category_outlined),
                      title: Text(
                        'Product Catalog',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).disabledColor),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) {
                                return DisplayProductCatalog(
                                  adminUserPermission: '',
                                );
                              },
                              fullscreenDialog: true),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
