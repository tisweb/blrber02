//Imports for pubspec Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flag/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Imports for Constants
import '../constants.dart';

//Imports for Widgets
import './display_product_catalog.dart';

//Imports for Models
import '../models/user_detail.dart';

//Imports for Provider
import '../provider/get_current_location.dart';

//Imports for Screens
import '../screens/edit_profile.dart';
import '../screens/customer_support.dart';
import '../screens/settings_screen.dart';

class DisplayProfile extends StatefulWidget {
  @override
  _DisplayProfileState createState() => _DisplayProfileState();
}

class _DisplayProfileState extends State<DisplayProfile> {
  List<UserDetail> userDetails = [];
  User user;
  GetCurrentLocation getCurrentLocation = GetCurrentLocation();
  String currentUserName = "";
  List<UserDetail> userDetailsCU = [];
  bool _initialData = false;

  static const double flagHeight = 20.0;
  static const double flagWidth = 25.0;

  @override
  void didChangeDependencies() {
    userDetails = Provider.of<List<UserDetail>>(context);
    getCurrentLocation = Provider.of<GetCurrentLocation>(context);
    user = FirebaseAuth.instance.currentUser;

    _initialData = false;
    if (userDetails != null) {
      if (userDetails.length > 0 && user != null) {
        userDetailsCU = userDetails
            .where((e) => e.email.trim() == user.email.trim())
            .toList();
        if (userDetailsCU.length > 0) {
          currentUserName = userDetailsCU[0].userName;
          _initialData = true;
        }
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _initialData
        ? Container(
            child: Column(
              children: [
                Container(
                  color: bBackgroundColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flag(
                        getCurrentLocation.countryCode,
                        height: flagHeight,
                        width: flagWidth,
                        fit: BoxFit.fill,
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(SettingsScreen.routeName);
                        },
                      )
                    ],
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  color: bBackgroundColor,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: userDetailsCU[0].userImageUrl == ""
                            ? AssetImage('assets/images/default_user_image.png')
                            : NetworkImage(userDetailsCU[0].userImageUrl),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              userDetailsCU[0].displayName,
                              style: const TextStyle(
                                  fontSize: 20, color: bDisabledColor),
                            ),
                            Text(
                              userDetailsCU[0].userType,
                              style: const TextStyle(
                                  fontSize: 15, color: bDisabledColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                Container(
                  color: bBackgroundColor,
                  child: ListTile(
                    leading: const Icon(
                      Icons.edit,
                      color: bPrimaryColor,
                    ),
                    title: const Text(
                      'Edit Profile',
                      style:
                          const TextStyle(fontSize: 18, color: bDisabledColor),
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
                const Divider(
                  thickness: 2,
                ),
                Container(
                  color: bBackgroundColor,
                  child: ListTile(
                    leading: const Icon(
                      Icons.category_outlined,
                      color: bPrimaryColor,
                    ),
                    title: const Text(
                      'Product Catalog',
                      style:
                          const TextStyle(fontSize: 18, color: bDisabledColor),
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
                const Divider(
                  thickness: 2,
                ),
                Container(
                  color: bBackgroundColor,
                  child: ListTile(
                    leading: const Icon(
                      Icons.support_agent,
                      color: bPrimaryColor,
                    ),
                    title: const Text(
                      'Customer Support',
                      style:
                          const TextStyle(fontSize: 18, color: bDisabledColor),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) {
                              return CustomerSupport();
                            },
                            fullscreenDialog: true),
                      );
                    },
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                Container(
                  color: bBackgroundColor,
                  child: ListTile(
                    leading: const Icon(
                      Icons.settings,
                      color: bPrimaryColor,
                    ),
                    title: const Text(
                      'Settings',
                      style:
                          const TextStyle(fontSize: 18, color: bDisabledColor),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(SettingsScreen.routeName);
                    },
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
              ],
            ),
          )
        : const Center(
            child: CupertinoActivityIndicator(),
          );
  }
}
